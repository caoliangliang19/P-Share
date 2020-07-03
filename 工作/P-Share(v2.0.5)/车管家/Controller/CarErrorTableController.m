//
//  CarErrorTableController.m
//  P-Share
//
//  Created by 亮亮 on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CarErrorTableController.h"
#import "CarErrorCell.h"
#import "MJRefresh.h"
#import "CarErrorDetailController.h"
#import "RegulationsModel.h"
@interface CarErrorTableController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@end

@implementation CarErrorTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = _resultModel.listsArray;
    
    _carNumber.text = _resultModel.hphm;
    
    [self createTableView];
//    [self setRefresh];
}
- (void)setRefresh{
    _curIndex = 1;
    _isLoading = NO;
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.carDetailTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.carDetailTableView;
    _mjFooterView.delegate = self;
    [self downloadDataWithBeginIndex:_curIndex];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (_mjHeaderView == refreshView) {
        _curIndex = 1;
    }
    if (refreshView == _mjFooterView) {
        _curIndex += 1;
    }
    [self downloadDataWithBeginIndex:_curIndex];
}
- (void)downloadDataWithBeginIndex:(NSInteger)curindex{
    
}
- (void)dealloc{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}
- (void)createTableView{
    self.carDetailTableView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    self.carDetailTableView.delegate = self;
    self.carDetailTableView.dataSource = self;
    self.carDetailTableView.tableFooterView = [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *gayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    gayView.backgroundColor = [UIColor clearColor];
    return gayView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CarErrorCell1";
    CarErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarErrorCell" owner:self options:nil]lastObject];
        
    }
    
    RegulationsModel *model = [_dataArray objectAtIndex:indexPath.section];
    cell.carErrorTime.text = model.date;
    cell.caeErrorPlace.text = model.area;
    if ([model.handled isEqualToString:@"1"]) {
        cell.carType.text = @"已处理";
    }
    else if ([model.handled isEqualToString:@"0"])
    {
        cell.carType.text = @"未处理";
    }
    else
    {
        cell.carType.text = @"处理状态未知";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RegulationsModel *regulation = [_dataArray objectAtIndex:indexPath.section];
    CarErrorDetailController *detail = [[CarErrorDetailController alloc]init];
    detail.regulation = regulation;
    
    detail.regulation.place = _resultModel.place;
    
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
