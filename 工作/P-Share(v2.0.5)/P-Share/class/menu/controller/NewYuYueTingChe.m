//
//  NewYuYueTingChe.m
//  P-Share
//
//  Created by fay on 16/5/19.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewYuYueTingChe.h"
#import "TextCell.h"
#import "YuYueModel.h"
#import "YuYueChooseTimeCell.h"
#import "YuYueTaoCanCell.h"
#import "ChooseTimeView.h"
#import "YuYueCell.h"
#import "YuYueTimeModel.h"
#import "YuYueModel.h"
#import "ShareTemParkingViewController.h"

#define TextCellId                      @"TextCell"
#define YuYueChooseTimeCellId           @"YuYueChooseTimeCell"
#define YuYueTaoCanCellId               @"YuYueTaoCanCell"
#define YuYueCellId                     @"YuYueCell"

@interface NewYuYueTingChe ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UIView          *_clearBackView;
    MBProgressHUD   *_mbView;
    YuYueModel      *_yuYueModel;
    NSMutableArray  *_taoCanArray;
    NSDictionary    *_changeDayDic;
    
    NSString        *_currentPrice;
    NSString        *_oldPrice;
    UIAlertView     *_alert;
    YuYueTaoCanCell *_temTaoCanCell;
    UIButton        *_sureBtn;
//    套餐id
    YuYueTimeModel  *_taoCanModel;
    
//    选择的时间
    NSString        *_chooseWeek;
    
}
@end
//requestPayWithWalletWithURL
@implementation NewYuYueTingChe

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD

    [self sureBtn];
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self loadUI];
    [self loadData];
    
}

- (void)sureBtn
{
    UIButton *sureBtn = [UIButton new];
    _sureBtn = sureBtn;
    _sureBtn.backgroundColor = [UIColor lightGrayColor];
    _sureBtn.userInteractionEnabled = NO;
    sureBtn.frame = CGRectMake(14, 20, SCREEN_WIDTH-28, 40);
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确认提交" forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [MobClick beginLogPageView:@"优惠停车进入"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"优惠停车退出"];
}
- (void)loadUI
{
    
    _changeDayDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"周一",@"2",@"周二",@"3",@"周三",@"4",@"周四",@"5",@"周五",@"6",@"周六",@"7",@"周日", nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TextCell class] forCellReuseIdentifier:TextCellId];
    [_tableView registerClass:[YuYueChooseTimeCell class] forCellReuseIdentifier:YuYueChooseTimeCellId];
    [_tableView registerClass:[YuYueTaoCanCell class] forCellReuseIdentifier:YuYueTaoCanCellId];
    [_tableView registerNib:[UINib nibWithNibName:@"YuYueCell" bundle:nil] forCellReuseIdentifier:YuYueCellId];
    _taoCanArray = [NSMutableArray array];
    
}

#pragma mark -- 获取上方时间数据
- (void)loadData
{
    BEGIN_MBPROGRESSHUD
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_parkModel.parkingId,@"parkingId",[MyUtil getVersion],@"version", nil];
   

    [RequestModel requestPayWithWalletWithURL:reservedParking WithDic:dic Completion:^(NSDictionary *dic) {
        END_MBPROGRESSHUD
        MyLog(@"%@",dic);
        _sureBtn.backgroundColor = NEWMAIN_COLOR;
        _sureBtn.userInteractionEnabled = YES;
        
        YuYueModel *model = [YuYueModel shareYuYueModelWithDic:dic[@"data"]];
        _yuYueModel = model;
        if (model.weekArray.count > 0) {
            YuYueTimeModel *timeModel = [model.weekArray objectAtIndex:0];
            _currentPrice = timeModel.price;
            _oldPrice = timeModel.price;
            _chooseWeek = [_changeDayDic valueForKey:timeModel.week];
            [self requestYuYueTingChaTaoCanWithDay:timeModel.week];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
        _sureBtn.userInteractionEnabled = NO;
        
        END_MBPROGRESSHUD
        
    }];
    
    
    
    
}

#pragma mark -- 请求套餐
- (void)requestYuYueTingChaTaoCanWithDay:(NSString *)day
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_parkModel.parkingId,@"parkingId",[_changeDayDic valueForKey:day],@"week",[MyUtil getVersion],@"version", nil];
    [RequestModel requestPayWithWalletWithURL:choseWeek WithDic:dic Completion:^(NSDictionary *dic) {
        NSMutableArray *taoCanArray = [NSMutableArray array];
        NSArray *dataArray = dic[@"data"];
        [_taoCanArray removeAllObjects];
        if (dataArray.count >0) {
            for (NSDictionary *dic in dataArray) {
                YuYueTimeModel *model = [YuYueTimeModel shareYuYUeTimeModel:dic];
                [taoCanArray addObject:model];
            }
            _taoCanArray = taoCanArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        });
        
    } Fail:^(NSString *error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 0.1;
    }else if(section == 2){
        return 42;
    }
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        [view addSubview:_sureBtn];
        return view;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
         return 80;
    }
    return 0.1;
}

#pragma mark -- 确认提交
- (void)sureButtonClick
{
    ShareTemParkingViewController *shareVC = [[ShareTemParkingViewController alloc] init];
    shareVC.pModel = self.parkModel;
    shareVC.packageId = [NSString stringWithFormat:@"%@",_taoCanModel.Id];
    shareVC.appointmentDate = _chooseWeek;
    shareVC.carModel = self.carModel;
    shareVC.nowLatitude = self.nowLatitude;
    shareVC.nowLongitude = self.nowLongitude;
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UILabel *title = [UILabel new];
        title.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
        title.textColor = [MyUtil colorWithHexString:@"333333"];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = 1;
        if (_taoCanArray.count == 0) {
            title.text = @"暂无优惠套餐";
        }else
        {
            title.text = @"优惠套餐";

        }
        title.backgroundColor = [UIColor whiteColor];
        return title;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _taoCanArray.count;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:TextCellId];
        cell.model = _yuYueModel;
        _yuYueModel.cell = cell;
        return cell;
    }else if (indexPath.section == 1){
        YuYueChooseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:YuYueChooseTimeCellId];
        cell.timeArrar = _yuYueModel.weekArray;
        cell.chooseTimeView = ^(ChooseTimeView *view){
            _currentPrice = view.model.price;
            _oldPrice = _currentPrice;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationRight];
            _chooseWeek = [_changeDayDic valueForKey:view.model.week];
            _taoCanModel = nil;
            [self requestYuYueTingChaTaoCanWithDay:view.model.week];
            MyLog(@"****");
        };
        return cell;
        
    }else if (indexPath.section == 2)
    {
        YuYueTaoCanCell *cell = [tableView dequeueReusableCellWithIdentifier:YuYueTaoCanCellId];
        
        YuYueTimeModel *model = [_taoCanArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"优惠套餐%ld",indexPath.row+1];
        cell.timeArrar = _yuYueModel.weekArray;
        cell.model = model;
        if (model.isSelect) {
            cell.selectStyle = YuYueTaoCanCellSelectStyleSelected;
        }else
        {
            cell.selectStyle = YuYueTaoCanCellSelectStyleUnSelect;
        }
        return cell;
        
    }else
    {
        YuYueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueCell"];
        [cell.rightImg removeFromSuperview];
        cell.mainL.text = @"优惠停车价格";
        cell.subL.text = [NSString stringWithFormat:@"%@  元",_currentPrice];
        NSAttributedString *attributeStr = [MyUtil getLableText:cell.subL.text changeText:_currentPrice Color:[MyUtil colorWithHexString:@"f98100"] font:28];
        cell.subL.attributedText = attributeStr;
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return _yuYueModel.cellHeight;
    }else if (indexPath.section == 1){
        return 160;
        
    }else if (indexPath.section == 2)
    {
        return 62;
        
    }else
    {
        return 55;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
        YuYueTimeModel *model = [_taoCanArray objectAtIndex:indexPath.row];

        if (model.isSelect) {
            model.isSelect = NO;
            _currentPrice = _oldPrice;
            _taoCanModel = nil;

        }else
        {
            _taoCanModel.isSelect = NO;
            model.isSelect = YES;
            _currentPrice = [NSString stringWithFormat:@"%@",model.price];
            _taoCanModel = model;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        
        [_tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationFade)];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
//        [_tableView reloadData];

    }
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
