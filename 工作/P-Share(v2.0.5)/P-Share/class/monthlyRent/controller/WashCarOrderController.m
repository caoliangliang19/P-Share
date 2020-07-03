//
//  WashCarOrderController.m
//  P-Share
//
//  Created by 亮亮 on 16/4/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "WashCarOrderController.h"
#import "NoPayForCell.h"
#import "MJRefresh.h"
#import "TemParkingListModel.h"
#import "DataSource.h"
#import "ClearCarPay.h"
@interface WashCarOrderController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate,cellClickEvent>
{
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _isPayFor;//判断是否付款
    UITableView *_tableView;//添加tableView
}
@end

@implementation WashCarOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self setUI];
    [self setRefresh];
    
}
#pragma mark -
#pragma mark - 设置ui画面
- (void)setUI{
    self.orderScrollView.delegate = self;
    self.orderScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 400);
    self.orderScrollView.pagingEnabled = YES;
    self.orderScrollView.bounces = NO;
    if (self.goInType ==  CLLIsGoInPushController) {
            _isPayFor = NO;
            [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.noView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
            [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.yesView.backgroundColor = [UIColor clearColor];
            [self.orderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
    }else if(self.goInType == CLLIsGoInOrderController){
           _isPayFor = YES;
           [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
           self.noView.backgroundColor = [UIColor clearColor];
           [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
           self.yesView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
           [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
           _tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DataSource shareInstance].noPayForArray removeAllObjects];
    [self downloadDataNoPayForWithBeginIndex:1];
    [self downloadDataPayForWithBeginIndex:1];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[DataSource shareInstance].yesPayForArray removeAllObjects];
    [[DataSource shareInstance].noPayForArray removeAllObjects];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - 添加MJ刷新效果
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = _tableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = _tableView;
    _mjFooterView.delegate = self;
    
    [self downloadDataNoPayForWithBeginIndex:_curIndex];
    [self downloadDataPayForWithBeginIndex:_curIndex];
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
    [self downloadDataNoPayForWithBeginIndex:_curIndex];
    [self downloadDataPayForWithBeginIndex:_curIndex];
}

//加载历史订单数据
#pragma mark 未付款数据请求
- (void)downloadDataNoPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;

   
    [RequestModel requestCarWashListWithURL:beginIndex orderStare:@"10" orderType:self.orderType Completion:^{
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_tableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
     
     
     

    
}
#pragma mark 已经付款数据请求
- (void)downloadDataPayForWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(customer_id),@"customerId",@"11",@"orderStatus",[NSString stringWithFormat:@"%ld",beginIndex],@"pageIndex",[MyUtil getTimeStamp],@"timestamp", nil];
    [RequestModel requestCarWashListWithURL:beginIndex orderStare:@"11" orderType:self.orderType Completion:^{
        _isLoading = NO;
        
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        [_tableView reloadData];
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        _isLoading = NO;
        [_mjHeaderView endRefreshing];
        [_mjFooterView endRefreshing];
        END_MBPROGRESSHUD;
    }];
    
    
    
//    [RequestModel requestMonthRentOrderListWithURL:beginIndex orderStare:@"11" orderType:self.orderType Completion:^{
//        _isLoading = NO;
//        
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        [_tableView reloadData];
//        END_MBPROGRESSHUD;
//    } Fail:^(NSString *error) {
//        _isLoading = NO;
//        [_mjHeaderView endRefreshing];
//        [_mjFooterView endRefreshing];
//        END_MBPROGRESSHUD;
//    }];
    
    
    
}
- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}
#pragma mark -
#pragma mark - 点击button更新数据源
- (void)isPayForSign{
    
    [_tableView reloadData];
}
#pragma mark -
#pragma mark - createTableView
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"NoPayForCell" bundle:nil] forCellReuseIdentifier:@"callID"];
    [self.orderScrollView addSubview:_tableView];
}
#pragma mark -
#pragma mark - button 的点击事件
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)payForBtnClick:(UIButton *)payBtn{
    if (payBtn.tag == 1) {
        _isPayFor = NO;
        [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
        self.noView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
        [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
        self.yesView.backgroundColor = [UIColor clearColor];
        [self.orderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
        
        
        
    }else if(payBtn.tag == 2){
        _isPayFor = YES;
        [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
        self.noView.backgroundColor = [UIColor clearColor];
        [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
        self.yesView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
        [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        _tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
        
        
    }
    [self isPayForSign];
}
#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       
    if (_isPayFor == NO) {
        return [DataSource shareInstance].noPayForArray.count;
    }else if(_isPayFor == YES){
        return [DataSource shareInstance].yesPayForArray.count;
    }
 
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoPayForCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callID"];
    cell.orderTitleL.hidden = YES;
    cell.orderBeginTimerL.hidden = YES;
    cell.index = indexPath.row;
    cell.myDelegate = self;
    TemParkingListModel *model = nil;
    if (_isPayFor == NO) {
        model = [DataSource shareInstance].noPayForArray[indexPath.row];
        cell.payFor.hidden = NO;
        cell.canclePayFor.hidden = NO;
        cell.LineView.hidden = NO;
        cell.payForMoneyL.hidden = YES;
        cell.orderLH.constant = 0;
        cell.orderLH1.constant = 0;
        cell.lineLay.constant = 0;
        cell.viewHeight.constant = 130;
        cell.xuFeiGoTimeL.text = @"预约时间";
        cell.xuFeiGoTimeW.constant = 55;
        cell.getDateTimeL.text = model.reserveDate;
        cell.xuFeiTimeL.text =  @"订单金额";
        cell.xuFeiMoneyW.constant = 55;
        cell.payTimerL.text =[NSString stringWithFormat:@"%@元",model.amountPayable];
        cell.payForTitleL.text = @"订单生成时间";
        cell.xuFeiMoneyW.constant = 80;
        cell.payMoney.text = model.createDate;
        
        
    }else if (_isPayFor == YES){
        model = [DataSource shareInstance].yesPayForArray[indexPath.row];
        cell.payFor.hidden = YES;
        cell.canclePayFor.hidden = YES;
        cell.LineView.hidden = YES;
        cell.payForMoneyL.hidden = NO;
        cell.viewHeight.constant = 90;
        cell.orderLH.constant = 0;
        cell.orderLH1.constant = 0;
        cell.lineLay.constant = 0;
        
        
        cell.xuFeiGoTimeL.text = @"服务项目";
        cell.xuFeiGoTimeW.constant = 55;
        cell.getDateTimeL.text = @"洗车";
        cell.xuFeiTimeL.text =  @"预约时间";
        cell.xuFeiMoneyW.constant = 55;
        cell.payTimerL.text = model.reserveDate;
        cell.payForTitleL.text = @"付款时间";
        cell.xuFeiMoneyW.constant = 55;
        cell.payMoney.text = model.payTime;

}
    cell.payForMoneyL.text = [NSString stringWithFormat:@"已付款%@元",model.amountPaid];
    cell.parkName.text = model.parkingName;
    cell.carNumber.text = model.carNumber;
//    //续费时长
//    cell.payTimerL.text =[NSString stringWithFormat:@"%@个月",model.monthNum];
//    //订单生成时间
//    cell.orderBeginTimerL.text  =model.createDate;
//    
//    cell.carNumber.text = model.carNumber;
//    //续费到期时间
//    cell.getDateTimeL.text = model.endTime;
//    cell.payForMoneyL.text =[NSString stringWithFormat:@"已付款%@元",model.amountPaid];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isPayFor == NO) {
        return 134;
    }else{
        return 95;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isPayFor == YES) {
//        TemParkingListModel *model = [DataSource shareInstance].yesPayForArray[indexPath.row];
        
        
//        AllHistoryDetailViewController *allHistory = [[AllHistoryDetailViewController alloc]init];
//        allHistory.temParkModel = model;
//        allHistory.monthRent =@"monthRent";
//        if ([model.orderType isEqualToString:@"14"]) {
//            allHistory.historyType = @"chanQuan";
//        }else if ([model.orderType isEqualToString:@"13"]){
//            allHistory.historyType = @"yueZu";
//        }
//        [self.navigationController pushViewController:allHistory animated:YES];
    }
}
#pragma mark -
#pragma mark - ScrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat float1 = self.orderScrollView.contentOffset.x;
    if (scrollView == self.orderScrollView) {
        if (float1 == 0) {
            _isPayFor = NO;
            [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.noView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
            [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.yesView.backgroundColor = [UIColor clearColor];
            [self.orderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
            
            
            [self isPayForSign];
            
        }else if(float1 == SCREEN_WIDTH){
            _isPayFor = YES;
            [self.noPayfor setTitleColor:[MyUtil colorWithHexString:@"696969"] forState:UIControlStateNormal];
            self.noView.backgroundColor = [UIColor clearColor];
            [self.yesPayfor setTitleColor:[MyUtil colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.yesView.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
            [self.orderScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            
            _tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104);
            
            [self isPayForSign];
        }
    }
}
#pragma mark -
#pragma mark - cell的点击事件
- (void)payFor:(NSInteger)index;{
    TemParkingListModel *model = [DataSource shareInstance].noPayForArray[index];
    ClearCarPay *rend = [[ClearCarPay alloc]init];
    
    rend.temParkingModel = model;
    rend.parkingId = model.parkingId;
    [self.navigationController pushViewController:rend animated:YES];
}
- (void)canclePayFor:(NSInteger)index;{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancleOrder:index];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)cancleOrder:(NSInteger)index
{
    TemParkingListModel *model = [DataSource shareInstance].noPayForArray[index];
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求----取消订单
    
    
    NSString *summery = [[NSString stringWithFormat:@"%@%@",model.orderId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",cancelOrder,model.orderId,summery];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *requestModel = [RequestModel new];
    [requestModel getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            if ([dict[@"errorNum"] isEqualToString:@"0"]) {
                [[DataSource shareInstance].noPayForArray removeObjectAtIndex:index];
                
                OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];
                
                if ([_orderType isEqualToString:@"13"]) {
                    
                    if (orderPoint.monthly>0) {
                        orderPoint.monthly--;
                    }
                }else
                {
                    if (orderPoint.equity>0) {
                        orderPoint.equity--;
                    }
                }
                [_tableView reloadData];
            }
        }
        END_MBPROGRESSHUD;
        
    } error:^(NSString *error) {
        END_MBPROGRESSHUD;

    } failure:^(NSString *fail) {
        END_MBPROGRESSHUD;

    }];
    
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
