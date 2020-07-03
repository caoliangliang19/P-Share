//
//  ShareHistoryDetailController.m
//  P-Share
//
//  Created by 亮亮 on 15/12/31.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ShareHistoryDetailController.h"
#import "ShareHistoryCell.h"
#import "JZAlbumViewController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Order.h"
#import "YuYuePingZhengDetail.h"
#import "payModel.h"
#import "faySheetVC.h"
#import "RequestModel.h"
#import "TemParkingListModel.h"
#import "ShowTingCheMaViewController.h"



@interface ShareHistoryDetailController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,myCellDelegate>
{
    faySheetVC *_faySheet;
    BOOL _iszhiFuBao;
    BOOL _isWeiXin;
    AppDelegate *_app;
    NSString *_orderNumber;//订单号
    NSString *_orderState;//订单状态
    NSString *_orderBeginTimer;//订单开始时间
    NSString *_parkingHome;//小区名称
    NSString *_carNumber;//车牌号
    NSString *_stopCarNumber;//停车码
    NSString *_payState;//支付方式
    NSString *_goInTimer;
    NSString *_outTimer;
    NSString *_payTimer;
    NSString *_stopCar1Number;
    NSInteger _tableViewSecond;
    NSInteger _tableViewRow;
    NSInteger _tableViewRow1;
    NSString *_order;
    NSString *_myTimer;
    NSString *_payOffer;
    BOOL _isDiscountStop;
    
    UIView *footerView;
    
    payModel *_payModel;
    
    UIAlertView *_alert;
    
   
    
}
@property (nonatomic,copy)NSString *payPrice;//应付金额
@property (nonatomic,copy)NSString *retusePrice;//抵扣金额
@property (nonatomic,copy)NSString *turePrice;//支付金额

@property(nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong) TemParkingListModel *detailModel;
@end

@implementation ShareHistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _payModel = [[payModel alloc]init];
    _shareTableView.backgroundColor = GRAY_COLOR;
    
    _app = [UIApplication sharedApplication].delegate;
    [self createModel];
    _payModel = [[payModel alloc] init];
    
    _iszhiFuBao = NO;
    _isWeiXin = YES;
    _tableViewSecond = 2;
    _tableViewRow = 2;
    _tableViewRow1 = 3;
    self.canclePay.layer.cornerRadius = 5;
    self.canclePay.clipsToBounds = YES;
    self.turePayfor.layer.cornerRadius = 5;
    self.turePayfor.clipsToBounds = YES;
    _goToPay.layer.cornerRadius = 5;
    _goToPay.clipsToBounds = YES;
    _PopSuperView.layer.cornerRadius = 5;
    _PopSuperView.clipsToBounds = YES;
    self.StopCarView.hidden = YES;
    self.PopSuperView.alpha = 0;
    self.ScreenView.hidden = YES;
    self.shareTableView.delegate = self;
    self.shareTableView.dataSource = self;
    self.shareTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shareTableView.bounces = YES;
    self.shareTableView.tableFooterView = [[UIView alloc]init];
    
}
- (void)createModel{
    NSLog(@"%@%@",self.model.orderId,self.model.orderType);
    [RequestModel requestHistoryOrderDetailListWithURL:self.model.orderId WithType:self.model.orderType Completion:^(TemParkingListModel *model) {
        self.detailModel = model;
        if ([self.passOnState isEqualToString:@"从历史订单"]) {
            [self cretaeMyOrderTableView];
        }else{
            [self createDataSourse];
        }
    } Fail:^(NSString *error) {
        
    }];
}
- (void)hidden
{
    _turePayfor.hidden = YES;
    _canclePay.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"hidden" object:nil];
    [self createModel];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"ShareHistoryDetailController";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinzifu:) name:@"ShareHistoryDetailController" object:nil];//监听一个通知
    
    
   
}
#pragma mark - 从订单页生成订单
- (void)cretaeMyOrderTableView{
    if ([self.detailModel.orderType integerValue] == 10) {        self.self.headerTitle.text = @"预约停车订单详情";
        _isDiscountStop = YES;
    if ([self.detailModel.orderStatus integerValue] == 10) {
        _tableViewSecond = 2;
        _tableViewRow = 2;
        _tableViewRow1 = 3;
//        self.canclePay.hidden = NO;
//        self.turePayfor.hidden = NO;
        _orderNumber = [NSString stringWithFormat:@"订单号:%@",self.detailModel.orderId];
        _order =  [NSString stringWithFormat:@"%@",self.detailModel.orderId];
         [self myOrder];
        _orderState = self.detailModel.orderStatusName;
        
    }else if([self.detailModel.orderStatus integerValue] == 11){
        _tableViewSecond = 4;
        _tableViewRow = 5;
        _tableViewRow1 = 4;
        self.canclePay.hidden = YES;
        self.turePayfor.hidden = YES;
         [self myOrder];
        _orderState =[NSString stringWithFormat:@"订单状态:%@",self.detailModel.orderStatusName];
 
    
    }else{
        _tableViewSecond = 2;
        _tableViewRow = 2;
        _tableViewRow1 = 3;
        self.canclePay.hidden = YES;
        self.turePayfor.hidden = YES;
        [self myOrder];
        _orderState =[NSString stringWithFormat:@"订单状态:%@",self.detailModel.orderStatusName];
        
     }
}else{
    
    
        self.canclePay.hidden = YES;
        self.turePayfor.hidden = YES;
        self.headerTitle.text = @"临停订单详情";
        _isDiscountStop = NO;
        [self myOrder];
        if ([self.detailModel.orderStatus integerValue] == 10) {
            _tableViewSecond = 3;
            _tableViewRow = 5;
            _tableViewRow1 = 4;
             _orderState =[NSString stringWithFormat:@"订单状态:%@",self.detailModel.orderStatusName];
             _turePrice =[NSString stringWithFormat:@"已付金额:%@",@"0"];
             [self createTableViewFooterView];
         }else if ([self.detailModel.orderStatus integerValue] == 11){
              _tableViewSecond = 4;
              _tableViewRow = 5;
              _tableViewRow1 = 4;
              _orderState =[NSString stringWithFormat:@"订单状态:%@",self.detailModel.orderStatusName];
         }else{
             _tableViewSecond = 3;
             _tableViewRow = 5;
             _tableViewRow1 = 4;
              _orderState =[NSString stringWithFormat:@"订单状态:%@",self.detailModel.orderStatusName];
         }
    [self.shareTableView reloadData];
    }
}
- (void)createTableViewFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    footerView.backgroundColor = [UIColor clearColor];
    CGFloat width = (SCREEN_WIDTH-45)/2;
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(15, 23, width, 35);
    [sureBtn setTitle:@"取 消 付 款" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor orangeColor]];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn];
    
    UIButton *sureBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn1.frame = CGRectMake(30+width, 23, width, 35);
    [sureBtn1 setTitle:@"付 款" forState:UIControlStateNormal];
    [sureBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn1 setBackgroundColor:[UIColor orangeColor]];
    sureBtn1.layer.cornerRadius = 4;
    sureBtn1.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn1.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn1];
    
    [sureBtn addTarget:self action:@selector(nonment:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn1 addTarget:self action:@selector(payfor:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareTableView.tableFooterView = footerView;
}

#pragma mark - 从地图页获取订单信息生成订单
- (void)createDataSourse{
    if (self.orderModel.order_state == 10) {
        if ([_payOffer isEqualToString:@"支付过"]) {
            
        }else{
        _tableViewSecond = 2;
        _tableViewRow = 2;
        self.canclePay.hidden = NO;
        self.turePayfor.hidden = NO;
        self.canclePay.backgroundColor = [UIColor grayColor];
        
        _orderNumber = [NSString stringWithFormat:@"订单号:%@",self.orderModel.order_Id];
        _order = self.orderModel.order_Id;
        self.priceLable.text = [NSString stringWithFormat:@"%@",self.payPrice1];
        _orderState = @"订单状态:未付款";
        _orderBeginTimer = [NSString stringWithFormat:@"下单时间:%@",self.orderModel.create_at];
        _parkingHome = [NSString stringWithFormat:@"小区名称:%@",self.orderModel.parker_name];
        _carNumber = [NSString stringWithFormat:@"车牌号:%@",self.orderModel.car_Number];
        
        [self.shareTableView reloadData];
        }
        
    }
}
#pragma mark - 订单页信息汇总；
- (void)myOrder{
    NSLog(@"%lu",(unsigned long)self.detailModel.parkingName.length);
    if (self.detailModel.parkingName.length == 0) {
         _parkingHome = [NSString stringWithFormat:@"小区名称:%@",@" "];
    }else{
        
        _parkingHome = [NSString stringWithFormat:@"小区名称:%@",self.detailModel.parkingName];
    }
    
    if (!(self.detailModel.carNumber.length == 0)) {
        _carNumber = [NSString stringWithFormat:@"车牌号:%@",self.detailModel.carNumber];
    }else{
        _carNumber = [NSString stringWithFormat:@"车牌号:%@",@""];
    }
    //支付时间
    if (!(self.detailModel.payTime.length == 0)) {
        _payTimer = [NSString stringWithFormat:@"支付时间:%@",self.detailModel.payTime];
    }else{
        _orderBeginTimer = [NSString stringWithFormat:@"支付时间:%@",@""];
    }
    //停车码
    if (!(self.detailModel.parkingCode.length == 0)) {
        _stopCar1Number = [NSString stringWithFormat:@"停车码:%@",self.detailModel.parkingCode];
    }else{
        _stopCar1Number = [NSString stringWithFormat:@"停车码:%@",@""];
    }
    NSString *str = [NSString stringWithFormat:@"%@",self.detailModel.orderBeginDate];
    if (!(str.length == 0)) {
        _orderBeginTimer = [NSString stringWithFormat:@"订单开始时间:%@",self.detailModel.orderBeginDate];
    }else{
        _orderBeginTimer = [NSString stringWithFormat:@"订单开始时间:%@",@""];
    }
   
    
    
    _orderNumber = [NSString stringWithFormat:@"订单号:%@",self.detailModel.orderId];
    _order = self.detailModel.orderId;
    
    
    if ([self.detailModel.payType integerValue] == 00) {
        _payState = @"支付方式:支付宝支付";
    }else if([self.detailModel.payType integerValue] == 01){
        _payState = @"支付方式:微信支付";
        
    }else if([self.detailModel.payType integerValue] == 05){
        _payState = @"支付方式:钱包支付";
        
    }
    _payPrice =[NSString stringWithFormat:@"应付金额:%@",self.detailModel.amountPayable];
    self.priceLable.text = [NSString stringWithFormat:@"%@",self.detailModel.amountPaid];
    _retusePrice = [NSString stringWithFormat:@"抵扣金额:%@",self.detailModel.amountDiscount];
    _turePrice =[NSString stringWithFormat:@"已付金额:%@",self.detailModel.amountPaid];
    if(!(self.detailModel.actualBeginDate.length == 0)){
         _goInTimer  = [NSString stringWithFormat:@"%@%@",@"进场时间:",self.detailModel.actualBeginDate];
    }else{
        _goInTimer  = [NSString stringWithFormat:@"%@%@",@"进场时间:",@""];
    }
    if (!(self.detailModel.actualEndDate.length == 0)) {
        _outTimer = [NSString stringWithFormat:@"%@%@",@"出场时间:",self.detailModel.actualEndDate];
    }else{
        _outTimer = [NSString stringWithFormat:@"%@%@",@"出场时间:",@""];
    }
     [self.shareTableView reloadData];
}
#pragma mark -- 监听微信支付
- (void)weiXinzifu:(NSNotification *)notification
{
    NSLog(@"weixin");
    if ([notification.object isEqualToString:@"success"]) {
        NSLog(@"success");
        [self showTingCheMa:@"微信支付"];
    }
    else
    {
        NSLog(@"fail");
        _PopSuperView.alpha = 0;
        self.ScreenView.hidden = YES;

    }
}
#pragma mark - 获取停车码  支付成功后调
- (void)showTingCheMa:(NSString *)str{
   
    if ([self.temOrderModel.order_Type integerValue] == 2) {
        
        NSString *url = [NSString stringWithFormat:@"%@?order_id=%@",UPDATEORDERSTATE,self.temOrderModel.order_ID];
        NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        RequestModel *model = [RequestModel new];
        
        [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = responseObject;
                
                if ([dict[@"code"] isEqualToString:@"000000"])
                {
                    NSLog(@"success");
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    NSLog(@"fail");
                    
                }
            }

        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
        
        }else{
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        //    NSDictionary *paramDic = @{customer_id:userId,order_id:_order};
        
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,customer_id,_order,order_id, nil] ;
        [_payModel requestTingCheMaWith:paramDic Completion:^(NSDictionary *dic) {
            if ([dic[@"code"] isEqualToString:@"000000"])
            {
                //                 支付码获取成功
                //                 NSArray *orderArr = dict[@"datas"][@"orderInfo"];
                //[_orderModel setValuesForKeysWithDictionary:orderArr[0]];
                
                self.StopLable.text = dic[@"datas"][@"orderInfo"][@"parking_code"];
                _stopCar1Number = [NSString stringWithFormat:@"停车码:%@",dic[@"datas"][@"orderInfo"][@"parking_code"]];
                
                _orderBeginTimer =[NSString stringWithFormat:@"下单时间:%@",dic[@"datas"][@"orderInfo"][@"create_at"]];
                _myTimer = [NSString stringWithFormat:@"%@",dic[@"datas"][@"orderInfo"][@"create_at"]];
                _payTimer = [NSString stringWithFormat:@"支付时间：%@",dic[@"datas"][@"orderInfo"][@"updated_at"]];
                _goInTimer  = [NSString stringWithFormat:@"%@",@"进场时间:"];
                _outTimer = [NSString stringWithFormat:@"%@",@"出场时间:"];
                _payOffer = @"支付过";
                self.payState1 = str;
                _payState = [NSString stringWithFormat:@"支付方式：%@",str];
                
                _payPrice = [NSString stringWithFormat:@"应付金额：%@",self.priceLable.text];
                
                _retusePrice = [NSString stringWithFormat:@"抵扣金额：%d",0];
                _turePrice = [NSString stringWithFormat:@"支付金额：%@",self.priceLable.text];
                _orderState = @"订单状态:已付款";
                [self.shareTableView reloadData];
            }
        } Fail:^(NSString *error) {

            ALERT_VIEW(error);
            _alert = nil;
            
        }];
    
    //---------------------------网路请求
    self.StopCarView.hidden = NO;
    self.ScreenView.hidden = NO;
    self.ScreenView.backgroundColor = [UIColor darkGrayColor];
    
    self.ScreenView.alpha = 0.5;
    self.PopSuperView.hidden = YES;
    _tableViewSecond = 4;
    _tableViewRow = 5;
    _tableViewRow1 = 4;
    self.canclePay.hidden = YES;
    self.turePayfor.hidden = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   //支付成功之后返回4
   
    return  _tableViewSecond;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
         return 1;
    }else if(section == 1){
        //支付成功之后返回3
        return _tableViewRow1;
       
    }else if(section == 2){
         return _tableViewRow;
       
    }else{
         return 4;
       
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    
    if (section == 0) {
        backView.backgroundColor = [UIColor whiteColor];
    }else
    {
        backView.backgroundColor = GRAY_COLOR;

    }
 
    
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 35)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:whiteView];
        UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 300, 20) title:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [whiteView addSubview:titleLabel];
        if (section == 0) {
              titleLabel.text = @"停车凭证";
        }else if (section == 1){
              titleLabel.text = @"订单信息";
           
        }else if(section == 2){
            if (_isDiscountStop == YES) {
                 titleLabel.text = @"优惠停车信息";
            }else{
                 titleLabel.text = @"临停信息";
            }
            
            
        }else if (section == 3){
            titleLabel.text = @"支付信息";
           
        }
        return backView;
   
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        return 60;
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addRentCellId";
    ShareHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareHistoryCell" owner:self options:nil]lastObject];
    }
    cell.stopCarButton.hidden = YES;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.myLable.text = _orderNumber;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.myLable.text = _orderState;
    }else if (indexPath.section == 1 && indexPath.row == 2){
        cell.myLable.text = _orderBeginTimer;
    }else if (indexPath.section == 1 && indexPath.row == 3){
        cell.myLable.text = _payTimer;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        cell.myLable.text = _parkingHome;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        cell.myLable.text = _carNumber;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        cell.myLable.text = _stopCar1Number;
    }else if (indexPath.section == 2 && indexPath.row == 3){
        cell.myLable.text = _goInTimer;
    }else if (indexPath.section == 2 && indexPath.row == 4){
        cell.myLable.text = _outTimer;
    }else if (indexPath.section == 3 && indexPath.row == 0){
        cell.myLable.text =[ NSString stringWithFormat:@"%@",
                            _payState];
    }else if (indexPath.section == 3 && indexPath.row == 1){
        cell.myLable.text = _payPrice;
    }else if (indexPath.section == 3 && indexPath.row == 2){
        cell.myLable.text =_retusePrice;
    }else if (indexPath.section == 3 && indexPath.row == 3){
        cell.myLable.text = _turePrice;
    }else if (indexPath.section == 0 && indexPath.row == 0){
        cell.stopCarButton.hidden = NO;
        cell.stopCarButton.layer.cornerRadius = 2;
        cell.stopCarButton.clipsToBounds = YES;
        cell.myLable.hidden = YES;
    }
    
    return cell;
}
#pragma mark - 查看停车凭证点击事件
- (void)myCellButtonClick{
    if ([self.detailModel.orderType integerValue] == 10) {
        
    
    YuYuePingZhengDetail *show = [[YuYuePingZhengDetail alloc]init];
    if ([self.detailModel.voucherStatus integerValue] == 0) {
        show.type = @"left";
    }else if ([self.detailModel.voucherStatus integerValue] == 1){
        show.type = @"center";
    }else if ([self.detailModel.voucherStatus integerValue] == 2){
        show.type = @"right";
    }
      
    show.pingZhengModel = self.detailModel;
    [self.navigationController pushViewController:show animated:YES];
    }else{
        ShowTingCheMaViewController *show = [[ShowTingCheMaViewController alloc]init];
        show.model = self.detailModel;
        [self.navigationController pushViewController:show animated:YES];
    }
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
- (IBAction)backUp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择支付方法
- (IBAction)gotoPayfor:(UIButton *)sender {
    if (_iszhiFuBao==NO&&_isWeiXin==NO) {
        [self alertController:@"请选择支付方式"];
    }else{
        if (_iszhiFuBao == YES) {
            [self zifubaoPayfor];
        }
        if (_isWeiXin) {
            [self weixinPayfor];
        }
    }
}
#pragma mark - 取消订单
- (IBAction)nonment:(UIButton *)sender {

    NSArray *array = [_orderNumber componentsSeparatedByString:@":"];
    NSDictionary *paramDic = @{order_id:array[1]};
    [_payModel payFailWithDic:paramDic];
    NSString *urlString = [CANCLESHAREOLDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            NSLog(@"%@",dict);
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }

    } error:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        
    } failure:^(NSString *fail) {
        ALERT_VIEW(fail);
        _alert = nil;

    }];
    //---------------------------网路请求
}
#pragma mark - 支付
- (IBAction)payfor:(UIButton *)sender {
    self.PopSuperView.alpha = 1;
    self.ScreenView.hidden = NO;
    self.ScreenView.backgroundColor = [UIColor darkGrayColor];

    self.ScreenView.alpha = 0.5;
   
}
#pragma mark - 支付弹框取消
- (IBAction)cancelButton:(UIButton *)sender {
    self.PopSuperView.alpha = 0;
    
    self.ScreenView.hidden = YES;
   
}
#pragma mark - 选择支付宝支付
- (IBAction)zhifubao:(UIButton *)sender {
    self.zifubaoClick.image = [UIImage imageNamed:@"shape-18-copy_s"];
    self.weiXinClick.image = [UIImage imageNamed:@"shape-18-copy"];
    _iszhiFuBao = YES;
    _isWeiXin = NO;
}
#pragma mark - 选择微信支付
- (IBAction)weiXin:(UIButton *)sender {
    self.zifubaoClick.image = [UIImage imageNamed:@"shape-18-copy"];
    self.weiXinClick.image = [UIImage imageNamed:@"shape-18-copy_s"];
    _iszhiFuBao = NO;
    _isWeiXin = YES;
}
#pragma mark - 停车码框消失
- (IBAction)stopCarCancle:(UIButton *)sender {
    self.StopCarView.hidden = YES;
    self.ScreenView.hidden = YES;
    [self alertController];
    
    
}
#pragma mark - 支付宝支付
- (void)zifubaoPayfor{
    NSURL *url = [NSURL URLWithString:[@"alipay://" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [self alertController:@"你没安装支付宝App"];
       return;
    }
    
//    AlipaySDK *alipay = [AlipaySDK defaultService];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*=======================需要填写商户app申请的===================================*/
    NSString *partner = @"2088021550883080";
    NSString *seller = @"zhifu@forwell-parking.com";
   
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    //    order.tradeNO = self.parkInfoDict[@"order_id"]; //订单ID（由商家自行制定）
    order.tradeNO = _order;
    
    order.productName = @"口袋停优惠停车支付"; //商品标题
    order.productDescription = @"口袋停缴费"; //商品描述
//        order.amount = [NSString stringWithFormat:@"%.2f",[_actulOrderPay floatValue]]; //商品价格
    order.amount = [NSString stringWithFormat:@"%@",self.priceLable.text]; //商品价格
  //   order.amount = [NSString stringWithFormat:@"%@",@"0.01"];
    
    //    order.amount = @"100";
    
//    order.notifyURL =  @"http://www.p-share.com/ShanganParking/payBackTempoOrder.jsp"; //回调URL
    
    order.notifyURL =  [NSString stringWithFormat:@"http://%@/ShanganParking/payBackTempoOrder.jsp",SERVER_ID]; //回调URL

    
    _payModel.orderDescribute = @"口袋停缴费";
    _payModel.orderName = @"口袋停优惠停车支付";
    _payModel.orderID = order.tradeNO;
    _payModel.orderPrice = order.amount;
    //    _payModel.orderPrice = [NSString stringWithFormat:@"%d",0];
    
//    _payModel.AlipayUrl = @"http://www.p-share.com/ShanganParking/payBackTempoOrder.jsp";
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/ShanganParking/payBackTempoOrder.jsp",SERVER_ID];

    [_payModel payWithAlipayDic:nil CanOpenAlipay:^(BOOL isCan) {
        if (isCan == NO) {
            [self alertController:@"您未安装支付宝或版本不支持"];
            return;
        }
        
    } Completion:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            MyLog(@"----支付宝支付成功-");
            
             [self showTingCheMa:@"支付宝支付"];
        }
        
    } Fail:^(BOOL fail) {
        
    }];
}

- (void)weixinPayfor{
    if ([WXApi isWXAppInstalled]) {
       
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        //配置微信回调URL
        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        app.weiXinNotify_url = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay";
        app.weiXinNotify_url = [NSString stringWithFormat:@"http://%@/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay",SERVER_ID];

        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[self.priceLable.text floatValue]*100];
        
        NSString *nameString = nil;
        if([self.temOrderModel.order_Type integerValue] == 3){
            nameString = @"口袋停优惠停车支付";
        }else if([self.temOrderModel.order_Type integerValue] == 2){
            nameString = @"口袋停临停支付";
        }else{
            nameString = @"口袋停优惠停车支付";
        }
        //        NSString *priceStr = [NSString stringWithFormat:@"%.0f",0.1*10];
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:nameString order_price:priceStr order_ID:_order];
        
        if(dict == nil){
            [self alertController:@"获取订单失败"];
            
        }else{
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        }
    }else{
         [self alertController:@"您未安装微信或版本不支持"];
        }
}
- (void)alertController:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)alertController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进入导航" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self myAnnotationTapForNavigationWithIndex];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark --地图跳转
- (void)myAnnotationTapForNavigationWithIndex
{
    OrderModel *model = self.orderModel;
    
    _faySheet = [[faySheetVC alloc] init];
    _faySheet.nowLatitude = _nowLatitude;
    _faySheet.nowLongitude = _nowLongitude;
    _faySheet.modelLatitude = model.parking_Latitude;
    _faySheet.modelLongitude = model.parking_Longitude;
    _faySheet.modelParkingName = model.parking_Name;
    [self.view addSubview:_faySheet.view];
    [self addChildViewController:_faySheet];
//    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
//    
//    [shareSheet showInView:self.view];
}

#pragma mark -UIActionSheet代理方法
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    
//    switch (buttonIndex) {
//        case 0:{
//            //自带地图导航
//            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_nowLatitude, _nowLongitude);
//            
//            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([_orderModel.parking_Latitude floatValue], [_orderModel.parking_Longitude floatValue]);
//            
//            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
//            
//            currentLocation.name = @"当前位置";
//            
//            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
//            
//            toLocation.name = _orderModel.parking_Name;
//            
//            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
//            
//            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
//            [MKMapItem openMapsWithItems:items launchOptions:options];
//            
//            NewHomeViewController *newHomeVC = [[NewHomeViewController alloc] init];
//            [self.navigationController pushViewController:newHomeVC animated:YES];
//            
//        }
//            break;
//        case 1:{
//            //百度地图导航
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
//            {
//                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",_nowLatitude,_nowLongitude,[_orderModel.parking_Latitude floatValue], [_orderModel.parking_Longitude floatValue], _orderModel.parking_Name];
//                
//                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSURL *url = [NSURL URLWithString:urlString];
//                [[UIApplication sharedApplication] openURL:url];
//                
//                NewHomeViewController *newHomeVC = [[NewHomeViewController alloc] init];
//                [self.navigationController pushViewController:newHomeVC animated:YES];
//                
//            }else{
//                
//                [self alertController:@"您未安装百度地图或版本不支持"];
//               
//            }
//        }
//            break;
//        case 2:{
//            //高德地图导航  067c1d2281fc7f9141e3725058c9e240
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",_orderModel.parking_Name, [_orderModel.parking_Latitude floatValue], [_orderModel.parking_Longitude floatValue]];
//                
//                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSURL *url = [NSURL URLWithString:urlString];
//                [[UIApplication sharedApplication] openURL:url];
//                
//                NewHomeViewController *newHomeVC = [[NewHomeViewController alloc] init];
//                [self.navigationController pushViewController:newHomeVC animated:YES];
//                
//            }else{
//                 [self alertController:@"您未安装百度地图或版本不支持"];
//            }
//        }
//            break;
//        default:
//            break;
//    }

//}
@end
