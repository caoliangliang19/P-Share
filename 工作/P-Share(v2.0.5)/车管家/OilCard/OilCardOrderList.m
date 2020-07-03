//
//  OilCardOrderList.m
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "OilCardOrderList.h"
#import "OrderListCell.h"
#import "DataSource.h"
#import "OilOrderList.h"
#import "MJRefresh.h"


@interface OilCardOrderList ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}
@end

@implementation OilCardOrderList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshDatasource];
    [_tableV registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:@"OrderListCell"];
//    self.tableV.tableFooterView = [[UIView alloc]init];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)refreshDatasource{
    //添加下拉刷新，上拉加载
   _curIndex = 1;
   _isLoading = NO;
        
   _mjHeaderView = [MJRefreshHeaderView header];
   _mjHeaderView.scrollView = self.tableV;
   _mjHeaderView.delegate = self;
        
   _mjFooterView = [MJRefreshFooterView footer];
   _mjFooterView.scrollView = self.tableV;
   _mjFooterView.delegate = self;
    
    [self createOrderList:_curIndex];
    
}
- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}
#pragma mark -MJRefreshBaseView代理方法
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
    [self createOrderList:_curIndex];
}

- (void)createOrderList:(NSInteger)pageIndex{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    [RequestModel requestAddCardOrderListWithURL:userId WithType:page Completion:^(NSMutableArray *array) {
        [self.tableV reloadData];
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataSource shareInstance].oilOrderListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    OilOrderList *model = [DataSource shareInstance].oilOrderListArray[indexPath.row];
    cell.myCellView.layer.cornerRadius = 6;
    cell.myCellView.clipsToBounds = YES;
    cell.myCellView.layer.borderWidth = 1;
    cell.myCellView.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    if ([model.cardType integerValue] == 1) {
        cell.chinaName.text = @"中国石化";
        cell.chinaImage.image = [UIImage imageNamed:@"sinopec_w"];
    }else{
        cell.chinaName.text = @"中国石油";
        cell.chinaImage.image = [UIImage imageNamed:@"cnpc"];
    }

    cell.oilCardNo.text = model.cardNo;
    cell.payMoney.text = [NSString stringWithFormat:@"%@元",model.amountPayable];
    cell.payTimer.text =[NSString stringWithFormat:@"%@",model.payTime] ;
    cell.readyMoney.text = [NSString stringWithFormat:@"%@元",model.amountPaid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 217;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)backVC:(UIButton *)sender {
    if ([self.push integerValue]==2) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -3] animated:YES];
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
