//
//  NewYuYueTingChe.m
//  P-Share
//
//  Created by fay on 16/5/19.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewYuYueTingChe.h"
#import "TextCell.h"
#import "YuYueChooseTimeCell.h"
#import "YuYueTaoCanCell.h"
#import "ChooseTimeView.h"
#import "YuYueCell.h"
#import "YuYueTimeModel.h"
//#import "YuYueModel.h"
//#import "ShareTemParkingViewController.h"

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
    Order           *_taoCanModel;
    
    
//    选择的时间
    NSString        *_chooseWeek;
    UITableView     *_tableView;
    
    
}
@end

@implementation NewYuYueTingChe

- (void)viewDidLoad {
    [super viewDidLoad];

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
//    [MobClick beginLogPageView:@"优惠停车进入"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"优惠停车退出"];
}
- (void)loadUI
{
    
    _changeDayDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"周一",@"2",@"周二",@"3",@"周三",@"4",@"周四",@"5",@"周五",@"6",@"周六",@"7",@"周日", nil];
    
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TextCell class] forCellReuseIdentifier:TextCellId];
    [_tableView registerClass:[YuYueChooseTimeCell class] forCellReuseIdentifier:YuYueChooseTimeCellId];
    [_tableView registerClass:[YuYueTaoCanCell class] forCellReuseIdentifier:YuYueTaoCanCellId];
    [_tableView registerNib:[UINib nibWithNibName:@"YuYueCell" bundle:nil] forCellReuseIdentifier:YuYueCellId];
    _taoCanArray = [NSMutableArray array];
    
}

#pragma mark -- 获取上方时间数据
- (void)loadData
{
    
    
    
}

#pragma mark -- 请求套餐
- (void)requestYuYueTingChaTaoCanWithDay:(NSString *)day
{
    
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
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

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

    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
