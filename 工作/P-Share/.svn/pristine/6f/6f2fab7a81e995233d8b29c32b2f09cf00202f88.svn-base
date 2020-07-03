//
//  ProofListController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ProofListController.h"
#import "DistanceCell.h"
#import "YuYuePingZhengDetail.h"

@interface ProofListController ()

@end

@implementation ProofListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的停车凭证";
    _select.selectArray =[[NSMutableArray alloc]initWithArray:@[@"未使用",@"已使用",@"已失效"]];
    [self createTableView];
    [self firstRefresh];
    [self createNSNotifition];
}
- (void)createNSNotifition{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRequst) name:@"REFRESHPINGZ" object:nil];
}
- (void)refreshRequst{
    if ([self.tab integerValue] == 0) {
        [self createRequest:self.leftPageIndex tab:self.tab];
        [self createRequest:self.centerPageIndex tab:@"1"];
    }else if ([self.tab integerValue] == 1){
        [self createRequest:self.leftPageIndex tab:@"0"];
        [self createRequest:self.centerPageIndex tab:self.tab];
    }
    
}
- (void)createTableView{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.tag = 2;
    _leftTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_leftTableView];
    
    _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _centerTableView.delegate = self;
    _centerTableView.dataSource = self;
    _centerTableView.tag = 3;
    _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _centerTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [_scrollView addSubview:_centerTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:(UITableViewStylePlain)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.tag = 4;
    _rightTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_rightTableView];
    self.tableView = _leftTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tab integerValue] == 0){
        return self.leftArray.count;
    }else if ([self.tab integerValue] == 1){
        return self.centerArray.count;
    }else if ([self.tab integerValue] == 2){
        return self.rightArray.count;
    }
    return 0;
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DistanceCell *cell = [DistanceCell instanceTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    OrderModel *model = nil;
    if ([self.tab integerValue] == 0) {
        model = self.leftArray[indexPath.row];
    }else if ([self.tab integerValue] == 1){
        model = self.centerArray[indexPath.row];
    }else if ([self.tab integerValue] == 2){
        model = self.rightArray[indexPath.row];
    }
    [cell upDataModel:model];
    __weak typeof (self)weakSelf = self;
    cell.lookUpPingZ = ^(NSInteger index){
        [weakSelf jumpPingZPage:index];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}
- (void)jumpPingZPage:(NSInteger)index{
    OrderModel *model = nil;
    YuYuePingZhengDetail *detail = [[YuYuePingZhengDetail alloc]init];
    if ([self.tab isEqualToString:@"0"]) {
       model = self.leftArray[index];
        model.voucherStatus = @"0";
    }else if ([self.tab isEqualToString:@"1"]){
        model = self.centerArray[index];
        model.voucherStatus = @"1";
    }else if ([self.tab isEqualToString:@"2"]){
         model = self.rightArray[index];
         model.voucherStatus = @"2";
    }
 
    detail.pingZhengModel = model;
   
    [self.rt_navigationController pushViewController:detail animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
