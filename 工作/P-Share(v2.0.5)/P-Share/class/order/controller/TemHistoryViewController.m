//
//  TemHistoryViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/10.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "TemHistoryViewController.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "NewOrderModel.h"
#import "ShareHistoryDetailController.h"
#import "NSString+MD5.h"
#import "RequestModel.h"

@interface TemHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
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

@implementation TemHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.orderArray = [[NSMutableArray alloc]init];
    ALLOC_MBPROGRESSHUD;
     [self setRefresh];
    [self.temHistoryTableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"orderCellId"];
    self.temHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.temHistoryTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
   

}

#pragma mark -- 待解决

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self downloadDataWithBeginIndex:1];
    
}
//添加下拉刷新，上拉加载
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.temHistoryTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.temHistoryTableView;
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
//    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看历史订单列表
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)beginIndex];
    [RequestModel requestGetHistoryOrderListWithURL:indexStr WithType:@"1" Completion:^(NSMutableArray *resultArray) {
        self.orderArray = resultArray;
        MyLog(@"%@", self.orderArray);
        _isLoading = NO;
      
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [self.temHistoryTableView reloadData];
//        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        MyLog(@"77777777%@",error);
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
//        END_MBPROGRESSHUD;
        
    }];
    
    //---------------------------网路请求
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCellId"];
   
    
    NewOrderModel *model = self.orderArray[indexPath.row];
    
    cell.parkTitleLabel.text =[NSString stringWithFormat:@"%@",model.parkingName];
    //车牌号
    if (!(model.carNumber.length == 0)) {
        cell.parkAddressLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.carNumber];
    }else{
        cell.parkAddressLabel.text = @"车牌号:";
    }
    //付款
    if ([model.orderType integerValue] == 10) {
        cell.typeLabel.text = @"优惠停车";
       
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%@:%@元",@"已付款",model.amountPaid];
       
    }else if([model.orderType integerValue] == 11) {
        cell.typeLabel.text = @"临停缴费";
       
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%@:%@元",@"已付款",model.amountPaid];
       
    }
    cell.createDateLabel.text =[NSString stringWithFormat:@"%@",model.payTime];
   
   
    
    cell.lineView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    cell.typeLabel.text = @"已付款";
    cell.typeLabel.textColor = [MyUtil colorWithHexString:@"39d5b8"];
    cell.rentMonthLabel.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareHistoryDetailController *detailCtrl = [[ShareHistoryDetailController alloc] init];
    detailCtrl.model = self.orderArray[indexPath.row];
    detailCtrl.passOnState = @"从历史订单";
    //MyLog(@"%@---",detailCtrl.temOrderModel.parking_Name);
   
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
