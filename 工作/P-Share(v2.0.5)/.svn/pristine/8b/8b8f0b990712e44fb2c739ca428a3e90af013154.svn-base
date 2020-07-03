//
//  HistoryOrderViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/25.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HistoryOrderViewController.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "AllHistoryDetailViewController.h"
#import "TemParkingListModel.h"

@interface HistoryOrderViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIAlertView *_alert;
}

@property (nonatomic,strong)NSMutableArray *orderArray;

@end

@implementation HistoryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.orderArray = [NSMutableArray array];
    ALLOC_MBPROGRESSHUD;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MyLog(@"%f",_topEdge.constant);
    if ([[UIDevice currentDevice].systemVersion  isEqual: @"8.4"]) {
        _topEdge.constant = 95;
        
    }
    [self setRefresh];
}



//添加下拉刷新，上拉加载
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.historyTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.historyTableView;
    _mjFooterView.delegate = self;
    
    [self downloadDataWithBeginIndex:_curIndex];
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
    [self downloadDataWithBeginIndex:_curIndex];
}

//加载历史订单数据
- (void)downloadDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看历史订单列表
    NSString *bage = [NSString stringWithFormat:@"%ld",(long)beginIndex];
    NSMutableDictionary *daiBoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",[MyUtil getVersion],@"version",bage,@"pageIndex", nil];
    [RequestModel requestQueryFinishParkOrder:queryFinishParkOrder WithType:nil WithDic:daiBoDic Completion:^(NSDictionary *dict) {
        if (beginIndex == 1) {
        [self.orderArray removeAllObjects];
        }
        NSArray *dataArray = dict[@"list"];
       
            for (NSDictionary *infoDict in dataArray){
            TemParkingListModel *model = [[TemParkingListModel alloc] init];
            [model setValuesForKeysWithDictionary:infoDict];
        
           [self.orderArray addObject:model];
        
                }

                [self.historyTableView reloadData];
        
     
                 _isLoading = NO;
                 END_MBPROGRESSHUD;
        
                 [_mjHeaderView endRefreshing];
                 [_mjFooterView endRefreshing];
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(error);
        _alert = nil;
                 _isLoading = NO;
            [_mjHeaderView endRefreshing];
            [_mjFooterView endRefreshing];
    }];
   
//    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//         if ([result isKindOfClass:[NSDictionary class]])
//         {
//             NSDictionary *dict = result;
//             
//             if ([dict[@"code"] isEqualToString:@"000000"])
//             {
//                 if (beginIndex == 1) {
//                     [self.orderArray removeAllObjects];
//                 }
//                 NSArray *dataArray = dict[@"datas"][@"orderList"];
//                 if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
//                     for (NSDictionary *infoDict in dataArray){
//                         HistoryOrderModel *model = [[HistoryOrderModel alloc] init];
//                         [model setValuesForKeysWithDictionary:infoDict];
//                         
//                         [self.orderArray addObject:model];
//                     }
//                 }
//                 [self.historyTableView reloadData];
//             }else{
//                 if (beginIndex == 1) {
//                     ALERT_VIEW(@"还没订单,赶紧去预约车位吧");
//                     _alert = nil;
//                 }else{
//                     ALERT_VIEW(@"已加载完毕");
//                     _alert = nil;
//                 }
//             }
//         }
//         _isLoading = NO;
//         END_MBPROGRESSHUD;
//
//         [_mjHeaderView endRefreshing];
//         [_mjFooterView endRefreshing];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         END_MBPROGRESSHUD;
//
//         MyLog(@"77777777%@",error);
//         _isLoading = NO;
//         [_mjHeaderView endRefreshing];
//         [_mjFooterView endRefreshing];
//     }];
    //---------------------------网路请求
//    END_MBPROGRESSHUD;
}


#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"orderCellId";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil]lastObject];
    }
    
    TemParkingListModel *model = self.orderArray[indexPath.row];
    cell.parkTitleLabel.text = model.parkingName;
    cell.parkAddressLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.carNumber];
    cell.createDateLabel.text = model.createDate;
    cell.payMoneyLabel.text = [NSString stringWithFormat:@"已付款%@元",model.amountPaid];
    cell.lineView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    cell.typeLabel.text = @"已完成";
    cell.typeLabel.textColor = [MyUtil colorWithHexString:@"39d5b8"];
    cell.rentMonthLabel.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllHistoryDetailViewController *detailCtrl = [[AllHistoryDetailViewController alloc] init];
    detailCtrl.orderModel = self.orderArray[indexPath.row];
    detailCtrl.historyType = @"daiBo";
    [self.navigationController pushViewController:detailCtrl animated:YES];
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


@end




