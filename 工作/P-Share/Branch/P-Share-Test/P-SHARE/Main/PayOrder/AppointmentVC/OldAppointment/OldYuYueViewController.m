//
//  OldYuYueViewController.m
//  P-SHARE
//
//  Created by fay on 2016/11/11.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "OldYuYueViewController.h"
#import "OldTextCell.h"
#import "YuYueChooseTimeCell.h"
#import "OldYuYueTaoCanCell.h"
#import "YuYueTimeModel.h"
#import "YuYueModel.h"
#import "ChooseTimeView.h"
static NSString *const KYuYueTimeModel = @"yuYueTimeModel";

@interface OldYuYueViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString        *_currentPrice;
    NSString        *_oldPrice;
    //    套餐id
    YuYueTimeModel  *_taoCanModel;
    //    选择的时间
    NSString        *_chooseWeek;
    UIButton        *_sureBtn;
}
@property (nonatomic,strong)GroupManage *manage;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *taoCanArray;
@property (nonatomic,strong)YuYueModel      *yuYueModel;
@property (nonatomic,copy)NSDictionary    *changeDayDic;

@end

@implementation OldYuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = YES;
    [self initData];
    [self setUI];
}
- (void)initData{
    self.changeDayDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"周一",@"2",@"周二",@"3",@"周三",@"4",@"周四",@"5",@"周五",@"6",@"周六",@"7",@"周日", nil];
    _manage = [GroupManage shareGroupManages];
    [self loadData];
}


- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFF4"];
    [_tableView registerClass:[OldTextCell class] forCellReuseIdentifier:@"OldTextCell"];
    [_tableView registerClass:[YuYueChooseTimeCell class] forCellReuseIdentifier:@"YuYueChooseTimeCell"];
    [_tableView registerClass:[OldYuYueTaoCanCell class] forCellReuseIdentifier:@"OldYuYueTaoCanCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.title = @"预约停车";
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)taoCanArray{
    if (!_taoCanArray) {
        _taoCanArray = [NSMutableArray array];
    }
    return _taoCanArray;
}



#pragma mark --tableView delegate dateSource
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
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 68)];
        footView.backgroundColor = [UIColor clearColor];
        UIButton *sureBtn = [UIButton new];
        _sureBtn = sureBtn;
        _sureBtn.backgroundColor = KMAIN_COLOR;
        sureBtn.frame = CGRectMake(14, 14, SCREEN_WIDTH-28, 40);
        sureBtn.titleLabel.textColor = [UIColor whiteColor];
        sureBtn.layer.cornerRadius = 6;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn setTitle:@"确认提交" forState:(UIControlStateNormal)];
        [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:sureBtn];
        return footView;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 68;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UILabel *title = [UILabel new];
        title.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
        title.textColor = [UIColor colorWithHexString:@"333333"];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = 1;
        if (self.taoCanArray.count == 0) {
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
        return self.taoCanArray.count;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OldTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OldTextCell"];
        cell.model = _yuYueModel;
        return cell;
    }else if (indexPath.section == 1){
        YuYueChooseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YuYueChooseTimeCell"];
        cell.timeArrar = _yuYueModel.weekArray;
        cell.chooseTimeView = ^(ChooseTimeView *view){
            _currentPrice = view.model.price;
            _oldPrice = _currentPrice;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
            _chooseWeek = [_changeDayDic valueForKey:view.model.week];
            _taoCanModel = nil;
            [self requestYuYueTingChaTaoCanWithDay:view.model];
            
            MyLog(@"****");
        };
        return cell;
        
    }else if (indexPath.section == 2)
    {
        OldYuYueTaoCanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OldYuYueTaoCanCell"];
        
        YuYueTimeModel *model = [self.taoCanArray objectAtIndex:indexPath.row];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"696969"];
        cell.textLabel.text = @"优惠停车价格";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  元",_currentPrice];
        NSAttributedString *attributeStr = [UtilTool getLableText:cell.detailTextLabel.text changeText:_currentPrice Color:[UIColor colorWithHexString:@"f98100"] font:28];
        cell.detailTextLabel.attributedText = attributeStr;
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return _yuYueModel.cellHeight;
    }else if (indexPath.section == 1){
        return 160;
    }else if (indexPath.section == 2){
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
        
    }
}


- (void)sureButtonClick
{
    PayCenterViewController *payCenterVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayCenterViewController"];
    payCenterVC.orderKind = PayCenterViewControllerOrferTypeYuYue;
    payCenterVC.packageId = _taoCanModel.Id;
    payCenterVC.appointmentDate = _chooseWeek;
    [self.rt_navigationController pushViewController:payCenterVC animated:YES complete:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end


@implementation OldYuYueViewController(LoadData)


- (void)loadData
{
    Parking *parking = [GroupManage shareGroupManages].parking;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:parking.parkingId,@"parkingId",@"1.3.7",@"version", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(reservedParking) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        YuYueModel *model = [YuYueModel shareYuYueModelWithDic:responseObject[@"data"]];
        self.yuYueModel = model;
        if (model.weekArray.count > 0) {
            YuYueTimeModel *timeModel = [model.weekArray objectAtIndex:0];
            _currentPrice = timeModel.price;
            _oldPrice = timeModel.price;
            _chooseWeek = [_changeDayDic valueForKey:timeModel.week];
            [self requestYuYueTingChaTaoCanWithDay:timeModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        
    }];
    
}
#pragma mark -- 请求套餐
- (void)requestYuYueTingChaTaoCanWithDay:(YuYueTimeModel *)timeModel
{
    MyLog(@"%@",timeModel.week);
    _manage.yuYueTimeModel = timeModel;
    Parking *parking = _manage.parking;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:parking.parkingId,@"parkingId",[_changeDayDic valueForKey:timeModel.week],@"week",@"1.3.7",@"version", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(choseWeek) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.taoCanArray removeAllObjects];
        for (NSDictionary *dic in responseObject[@"data"]) {
            YuYueTimeModel *model = [YuYueTimeModel shareObjectWithDic:dic];
            model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
            [self.taoCanArray addObject:model];
        }
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        
        MyLog(@"%@",responseObject);
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        
    }];
    
}




@end
