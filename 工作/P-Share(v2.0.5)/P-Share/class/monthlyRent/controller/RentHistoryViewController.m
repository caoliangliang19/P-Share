//
//  RentHistoryViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/10/18.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "RentHistoryViewController.h"
#import "OrderCell.h"
#import "AllHistoryDetailViewController.h"
#import "MJRefresh.h"

@interface RentHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIAlertView *_alert;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}
@property (nonatomic,strong)NSMutableArray *historyDataArray;

@end

@implementation RentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    
    self.historyDataArray = [NSMutableArray array];
    
    ALLOC_MBPROGRESSHUD;
    
    [self setRefresh];
}

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
    
    [self loadMonthlyRentDataWithBeginIndex:_curIndex];
}

- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
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
    [self loadMonthlyRentDataWithBeginIndex:_curIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)loadMonthlyRentDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看历史订单列表
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)beginIndex];
    [RequestModel requestGetHistoryOrderListWithURL:indexStr WithType:@"2" Completion:^(NSMutableArray *resultArray) {
        self.historyDataArray = resultArray;
        _isLoading = NO;
        [self.historyTableView reloadData];
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        MyLog(@"77777777%@",error);
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
        
    }];
    //---------------------------网路请求
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyDataArray.count;
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
    NewOrderModel *model = self.historyDataArray[indexPath.row];
    cell.parkTitleLabel.text = model.parkingName;
    //车牌号
    if (!(model.carNumber.length == 0)) {
        cell.parkAddressLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.carNumber];
    }else{
        cell.parkAddressLabel.text = @"车牌号:";
    }
    cell.createDateLabel.text = [NSString stringWithFormat:@"%@",model.payTime];//订单支付时间
    cell.payMoneyLabel.text = [NSString stringWithFormat:@"已付款%.1f元",[model.amountPayable floatValue]];
    cell.lineView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    
    if ([model.orderType integerValue] == 14) {
        cell.typeLabel.text = @"产权车位";
        cell.typeLabel.textColor = NEWMAIN_COLOR;
       
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%@:%@元",model.orderStatusName,model.amountPaid];
       
        
    }else{
        cell.typeLabel.text = @"月租车位";
        cell.typeLabel.textColor = [MyUtil colorWithHexString:@"035aa4"];
        
            cell.payMoneyLabel.text = [NSString stringWithFormat:@"%@:%@元",model.orderStatusName,model.amountPaid];
     
    }
    
    
//    //时间数据源   @"yyyy-MM-dd HH:mm:ss"
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy/MM/dd";
//    NSDate *date = [formatter dateFromString:model.validityEndTime];
//    //获取当前年份
//    formatter.dateFormat = @"yyyy";
//    NSString *yearStr= [formatter stringFromDate:date];
//    formatter.dateFormat = @"MM";
//    NSString *monStr = [formatter stringFromDate:date];
//    cell.rentMonthLabel.text = [NSString stringWithFormat:@"%@",self.ren];;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewOrderModel *model = self.historyDataArray[indexPath.row];
    AllHistoryDetailViewController *havePayCtrl = [[AllHistoryDetailViewController alloc] init];
    havePayCtrl.myOrderModel = model;
    if ([model.orderType isEqualToString:@"14"]) {
        havePayCtrl.historyType = @"chanQuan";
    }else if ([model.orderType isEqualToString:@"13"]){
        havePayCtrl.historyType = @"yueZu";
    }
    [self.navigationController pushViewController:havePayCtrl animated:YES];
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
