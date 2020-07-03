//
//  ShareTemParkingViewController.m
//  P-Share
//
//  Created by fay on 15/12/31.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ShareTemParkingViewController.h"
#import "ChooseFreeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <MapKit/MapKit.h>
#import "payRequsestHandler.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Order.h"
#import "OrderModel.h"
#import "ParkingModel.h"
#import "PayModel.h"
#import "walletPayView.h"
#import "CouponModel.h"
#import "NSString+MD5.h"
#import "TemParkingListModel.h"
#import "ShareHistoryDetailController.h"
#import "AgainSetCodeController.h"
#import "TradeDetailVC.h"
#define psharePay       @"psharePay"
#define wechat          @"wechat"
#define alipay          @"alipay"

#define OrderType       @"10"
@interface ShareTemParkingViewController ()<UITextFieldDelegate,ChooseFreeDelegate,UIActionSheetDelegate>
{
    NSString *_payType;

    UIAlertView *_alert;
    TradeDetailVC *_tradeVC;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    NSString *_actulOrderPay;
    
    OrderModel *_orderModel;
    ParkingModel *_parkModel;
    
     NSString *_priceStr;
    
    payModel *_payModel;
    
    CouponModel *_discountModel;
    
    UIAlertView *_aletView;
    
    
    TemParkingListModel *_temParkingModel;
    
    UIImageView *_temImage;
    walletPayView *_walletView;
    
    UITextField *_temText;
    
    
}
@property (nonatomic,strong)NSDictionary *parkInfoDict;

@end

@implementation ShareTemParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD;
    
    _grayView.hidden = YES;


    [self loadUI];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString= [dateFormatter stringFromDate:date];
//    创建订单
    if (self.temModel) {
        [self craeteOrder];
    }else{
    [self createOrderWithTime:timeString];
    }
    _payModel = [[payModel alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
    
}

- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)loadUI
{
//    BEGIN_MBPROGRESSHUD;
    _temImage = _selectSelfImageView;
    _tingCheMaL.layer.cornerRadius = 8;
    _tingCheMaL.layer.masksToBounds = YES;
    
    [self clipWithView:_surePayBtn size:3];
    
    _payType = psharePay;


}

#pragma mark --监听一个通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"shareTempParkGetResult";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShareTemParkingPayResult:) name:@"shareTempParkGetResult" object:nil];//监听一个通知

    
}


#pragma mark -- 监听微信支付返回的结果
- (void)getShareTemParkingPayResult:(NSNotification *)notification
{
    MyLog(@"weixin");
    
    
    if ([notification.object isEqualToString:@"success"]) {
        MyLog(@"success");
        
        [self payForSccend:@"微信支付"];

    }
    else
    {
        MyLog(@"fail");
        
        [self payForFailure:@"微信支付"];

    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
           
            MyLog(@"支付");
            _actulOrderPay = _yingFuPrice.text;
            
            MyLog(@"%@",_actulOrderPay);
            
            if ([_payType isEqualToString:wechat]) {
                MyLog(@"微信支付");
                [self payOrderWithWeiXin];
            }else if ([_payType isEqualToString:alipay]){
                MyLog(@"支付宝支付");
                [self payOrderWithZhiFuBao];
            }else if ([_payType isEqualToString:psharePay]){
                MyLog(@"钱包支付");
                [self payOrderWithWallet];
            }
            
        }if (buttonIndex == 1) {
            MyLog(@"不支付");
            [self payForFailure:nil];

        }
        
    }else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self payForFailure:psharePay];

            AgainSetCodeController *againVC = [[AgainSetCodeController alloc]init];
            againVC.isBeginCode = @"NO";
            [self.navigationController pushViewController:againVC animated:YES];
        }else
        {
            
            [self payForFailure:psharePay];
            
        }
    }else
    {
        if (buttonIndex == 0) {
            
            NewMapHomeVC *newHomeVC = [[NewMapHomeVC alloc] init];
            [self.navigationController pushViewController:newHomeVC animated:YES];
        }if (buttonIndex == 1) {
            [self myAnnotationTapForNavigationWithIndex];
        }
    }
    
    
}

- (void)clipWithView:(UIView *)view size:(CGFloat)size
{
    view.layer.cornerRadius = size;
    view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --使用优惠券
- (IBAction)useYouHuiQuanClick:(UIButton *)sender {
    
    ChooseFreeViewController *chooseCtrl = [[ChooseFreeViewController alloc] init];
    chooseCtrl.delegate = self;
    chooseCtrl.parkingId = _pModel.parkingId;
    chooseCtrl.orderType = _temParkingModel.orderType;

    chooseCtrl.orderTotalPay =  [_yingFuPrice.text intValue];
    
    [self.navigationController pushViewController:chooseCtrl animated:YES];

}

- (void)craeteOrder{
    _temParkingModel = self.temModel;
    
    _yingFuPrice.text = [NSString stringWithFormat:@"%@",self.temModel.amountPayable];
    _shiFuPrice.text = [NSString stringWithFormat:@"%@",self.temModel.amountPaid];
    _zheKouPrice.text = [NSString stringWithFormat:@"%@",self.temModel.amountDiscount];
    
    // 最终付的价格
    _actulOrderPay = _shiFuPrice.text;
}
#pragma mark -- 生成订单
- (void)createOrderWithTime:(NSString *)timeStr
{
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----发起预约
    
    //               获取时间戳
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    MyLog(@"%@",userID);
//    orderType  10 : 共享   11: 临停
    
//    appointmentDate  与 packageId  
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"customerId",@"10",@"orderType",dateString,@"timestamp",_pModel.parkingId,@"parkingId",_carModel.carNumber,@"carNumber",_appointmentDate,@"appointmentDate",nil];
    
    if (![_packageId containsString:@"null"]) {
        [dic setValue:_packageId forKey:@"packageId"];
    }
    [RequestModel requestCreateTemparkingOrderWithURL:ORDERC WithType:@"0" WithDic:dic Completion:^(TemParkingListModel *model) {
        
        _temParkingModel = model;

         _yingFuPrice.text = [NSString stringWithFormat:@"%@",model.amountPayable];
        _shiFuPrice.text = [NSString stringWithFormat:@"%@",model.amountPaid];
        _zheKouPrice.text = [NSString stringWithFormat:@"%@",model.amountDiscount];
        
        // 最终付的价格
        _actulOrderPay = _shiFuPrice.text;
        END_MBPROGRESSHUD;
        
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD;

    }];
    
        
}


#pragma mark --使用优惠券时发送网络请求
- (void)selectedFreeWithModel:(CouponModel *)model
{
    
    BEGIN_MBPROGRESSHUD;
    _discountModel = model;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_discountModel.couponId,@"couponId",userID,@"customerId", _temParkingModel.orderId,@"orderId",dateString,@"timestamp",nil];
    
    [RequestModel requestWithUserCouponWithURL:nil WithDic:dic Completion:^(NSDictionary *dic) {
        _shiFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPaid"]];
        _zheKouPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountDiscount"]];
        _yingFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPayable"]];
        
        _actulOrderPay = _shiFuPrice.text;
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        
    }];
    
}

#pragma mark -- 选择支付方式
- (IBAction)choosePayKindClick:(UIButton *)sender {
    
    _temImage.image = [UIImage imageNamed:@"unselect"];
//    _temImage.image = [UIImage imageNamed:@"selected"];

    
    
    if (sender.tag == 0) {
//        钱包支付
        _selectSelfImageView.image = [UIImage imageNamed:@"selected"];
        _temImage = _selectSelfImageView;
        
        _payType = psharePay;
        
    }
    else if (sender.tag == 1){
//        微信支付
        _selectWechatImageView.image = [UIImage imageNamed:@"selected"];
        _temImage = _selectWechatImageView;
        _payType = wechat;
        
    }else
    {
//         支付宝支付
        _selectAlipayImageView.image = [UIImage imageNamed:@"selected"];
        _temImage = _selectAlipayImageView;
        _payType = alipay;
        
        
    }
}

#pragma mark -- 支付相关

#pragma mark -- 确认支付
- (IBAction)ensurePayClick:(UIButton *)sender {
    
    //        保护防止订单为nil的情况
    if (_temParkingModel.orderId == nil || _actulOrderPay == nil) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    
    if ([_payType isEqualToString:wechat] || [_payType isEqualToString:alipay] ) {
        if ([_actulOrderPay isEqualToString:@"0"]) {
            ALERT_VIEW(@"订单获取失败");
            _alert = nil;
            return;
        }
    }
        
    if ([_payType isEqualToString:@"0"]){
        ALERT_VIEW(@"请选择支付方式");
        _alert = nil;
    }else{
        
        
        [self pinlessOrderAndConpon];

        
    }
        
}


- (void)payOrderWithZhiFuBao
{
    _payModel.orderDescribute = @"口袋停优惠停车支付";

    _payModel.orderName = @"口袋停优惠停车支付";
        
    _payModel.orderID = _temParkingModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
//    _payModel.orderPrice = [NSString stringWithFormat:@"%d",0];
    
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_10",SERVER_ID];

    [_payModel payWithAlipayDic:nil CanOpenAlipay:^(BOOL isCan) {
        if (isCan == NO) {
            [self payForFailure:@"支付宝支付"];
            
            ALERT_VIEW(@"您未安装支付宝或版本不支持");
            _alert = nil;
            
            return;
        }
        
    } Completion:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            MyLog(@"----支付宝支付成功-");
            [self payForSccend:@"支付宝支付"];
            
        }
        
    } Fail:^(BOOL fail) {

//        1:支付失败：告诉服务器  让订单与优惠券进行解绑
        [self payForFailure:@"支付宝支付"];
        
    }];
    

}

- (void)payOrderWithWeiXin
{
    
    _payModel.orderDescribute = @"口袋停优惠停车支付";
    _payModel.orderName = @"口袋停优惠停车支付";
    _payModel.orderID = _temParkingModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_10",SERVER_ID];

    [_payModel payWithWeChatDic:nil CanOpenWeChat:^(BOOL isCan) {
        
        if (isCan == NO) {
            [self payForFailure:@"微信支付"];

            ALERT_VIEW(@"您未安装微信或版本不支持");
            _alert = nil;
        }
        return ;
        
    } Completion:^(BOOL isSuccess) {
        
        
    } Fail:^(BOOL fail) {
#pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
    
//        获取订单失败的时候  先让订单与优惠券解绑
        [self payForFailure:@"微信支付"];

        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
    }];
    
}


#pragma mark -- 展示停车码
- (void)showTingCheMa
{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,customer_id,_orderModel.order_Id,order_id,_discountModel.couponId,@"cdkey", nil] ;
    
    [_payModel requestTingCheMaWith:paramDic Completion:^(NSDictionary *dic) {
        if ([dic[@"code"] isEqualToString:@"000000"])
        {
            //                 支付码获取成功
            NSDictionary *orderDic = dic[@"datas"][@"orderInfo"];
            _orderModel = [[OrderModel alloc]init];
            [_orderModel setValuesForKeysWithDictionary:orderDic];
            _tingCheMaL.text = _orderModel.parking_code;
            _grayView.hidden = NO;
            
        }
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(error);
        _alert = nil;
    }];
   
    
}


#pragma mark --地图跳转
- (void)myAnnotationTapForNavigationWithIndex
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    
    [shareSheet showInView:self.view];
}

#pragma mark -UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_nowLatitude, _nowLongitude);
            
            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([_pModel.parkingLatitude floatValue], [_pModel.parkingLongitude floatValue]);
            
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
            
            currentLocation.name = @"当前位置";
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
            
            toLocation.name = _pModel.parkingName;
            
            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
            
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            [MKMapItem openMapsWithItems:items launchOptions:options];
            
            NewMapHomeVC *newHomeVC = [[NewMapHomeVC alloc] init];
            [self.navigationController pushViewController:newHomeVC animated:YES];
            
        }
            break;
        case 1:{
            //百度地图导航
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
            {
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",_nowLatitude,_nowLongitude,[_pModel.parkingLatitude floatValue], [_pModel.parkingLongitude floatValue], _pModel.parkingName];
                
                //                 NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?destination=latlng:%f,%f|name:%@&mode=driving",[_pModel.parking_Latitude floatValue], [_pModel.parking_Longitude floatValue], _pModel.parking_Name];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
                
                NewMapHomeVC *newHomeVC = [[NewMapHomeVC alloc] init];
                [self.navigationController pushViewController:newHomeVC animated:YES];
                
            }else{
                ALERT_VIEW( @"您未安装百度地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        case 2:{
            //高德地图导航  067c1d2281fc7f9141e3725058c9e240
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",_pModel.parkingName, [_pModel.parkingLatitude floatValue], [_pModel.parkingLongitude floatValue]];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
                
                NewMapHomeVC *newHomeVC = [[NewMapHomeVC alloc] init];
                [self.navigationController pushViewController:newHomeVC animated:YES];
                
            }else{
                ALERT_VIEW( @"您未安装高德地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        default:
            break;
    }
    
}


#pragma mark -- 订单与可选优惠券绑定，保存支付请求信息（确认支付）
- (void)pinlessOrderAndConpon
{
    NSString *payType;
    if ([_payType isEqualToString:wechat]) {
        payType = @"01";
    }else if ([_payType isEqualToString:alipay]){
        payType = @"00";
    }else
    {
        payType = @"05";

    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSString *dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"口袋停优惠停车支付\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",_temParkingModel.orderId,_actulOrderPay];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _temParkingModel.orderId,@"orderId",@"10",@"orderType",payType,@"payType",dateString,@"timestamp",dataStr,@"useInfo",@"2.0.4",@"version",nil];
    [dic setValue:_discountModel.couponId forKey:@"couponId"];
    BEGIN_MBPROGRESSHUD
    [RequestModel pinlessOrderAndConponWithDic:dic Completion:^(NSDictionary *dic) {
        
        END_MBPROGRESSHUD
        if ([dic[@"errorNum"] isEqualToString:@"3"]) {
            _aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"优惠券不可用，是否继续支付?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            _aletView.tag = 3;
            
            [_aletView show];
            return ;
            
        }
        
        else if ([dic[@"errorNum"] isEqualToString:@"0"]) {
            if ([_payType isEqualToString:wechat]) {
                MyLog(@"微信支付");
                [self payOrderWithWeiXin];
            }else if ([_payType isEqualToString:alipay]){
                MyLog(@"支付宝支付");
                [self payOrderWithZhiFuBao];
            }else if ([_payType isEqualToString:psharePay]){
                MyLog(@"钱包支付");
                [self payOrderWithWallet];
            }
        }else {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
        }

    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        ALERT_VIEW(@"订单支付失败");
        
        _alert = nil;
        
    }];
    
    MyLog(@"%@",dic);
    
}


#pragma mark --钱包支付
- (void)payOrderWithWallet
{

    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:pay_password] isEqualToString:@"0"]) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为保护账号的安全，请您先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertV.tag = 2;
        
        [alertV show];
        
        return;
        
    }

    _surePayBtn.userInteractionEnabled = NO;
    if (!_walletView) {
        _walletView = [[NSBundle mainBundle] loadNibNamed:@"walletPayView" owner:nil options:nil][0];
        [_walletView.cancelBtn addTarget:self action:@selector(cancelWalletView:) forControlEvents:(UIControlEventTouchUpInside)];
        _walletView.cancelBtn.tag = 2;
        [self.view addSubview:_walletView];
        [self.view addSubview:_mbView];
        [self.view addSubview:_clearBackView];

    }
    _walletView.hidden = NO;
    [_walletView loadMimaLabel];
    
    _walletView.moneyL.text = [NSString stringWithFormat:@"¥%@",_actulOrderPay];
    
    __weak typeof(self) weakSelf = self;
    [_walletView.mimaLabel becomeFirstResponder];
    _temText = _walletView.mimaLabel;
    
    _walletView.mimaLabel.delegate = self;
    _walletView.transform = CGAffineTransformMakeScale(1.03, 1.03);

    [UIView animateWithDuration:2 animations:^{
        _grayView.hidden = NO;

        [_walletView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(weakSelf.view);
            
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, SCREEN_WIDTH *0.7));
            
            
        }];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.1 animations:^{
            _walletView.transform = CGAffineTransformMakeScale(1.0, 1.0);

        }];
        
       [UIView animateWithDuration:4.6 animations:^{
           [_walletView mas_updateConstraints:^(MASConstraintMaker *make) {
               
               make.centerY.mas_equalTo(weakSelf.view).offset(-SCREEN_WIDTH*0.23);
               make.centerX.mas_equalTo(weakSelf.view);
           }];

       }];
        
    }];
    
    
}

#pragma mark -- 监听密码输入

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 5) {
    
        NSString *str = [NSString stringWithFormat:@"%@%@",_temText.text,string];
        _temText.text = str;
        
#pragma mark -- 密码输到六位时自动支付
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temParkingModel.orderId,@"orderId",[_temText.text MD5] ,@"payPassword", nil];
        
        BEGIN_MBPROGRESSHUD

        [RequestModel requestPayWithWalletWithURL:walletPay WithDic:dic Completion:^(NSDictionary *dic) {
            [self cancelWalletView:nil];
            END_MBPROGRESSHUD
            
            [self payForSccend:@"钱包支付"];
            
            
            
        } Fail:^(NSString *erroe) {
            [self cancelWalletView:nil];

            ALERT_VIEW(erroe);
            _alert = nil;
            [self payForFailure:@"钱包支付"];

            END_MBPROGRESSHUD
        }];
        
    }
    
    return YES;
}



- (void)cancelWalletView:(UIButton *)btn
{
    [self.view endEditing:YES];

    _walletView.hidden = YES;
    _grayView.hidden = YES;
    _surePayBtn.userInteractionEnabled = YES;
    if (btn.tag == 2) {
        
        [self payForFailure:@"钱包支付"];
        
    }

}

#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState;{

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temParkingModel.orderId,@"orderId",OrderType,@"orderType", nil];
    if (![_packageId containsString:@"null"]) {
        [dic setValue:_packageId forKey:@"packageId"];
    }else
    {
        [dic setValue:_appointmentDate forKey:@"appointmentDate"];
    }
    
    BEGIN_MBPROGRESSHUD
    [RequestModel requestAddCarWithURL:paidOrder WithDic:dic Completion:^(NSDictionary *dict) {
        END_MBPROGRESSHUD
        if ([dict[@"errorNum"] isEqualToString:@"0"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KYuYuePaySuccess object:_pModel.parkingId];
            
            
            [self changeBtnType];
            if (!_tradeVC) {
                _tradeVC = [[TradeDetailVC alloc] init];
            }else{
                return;
            }
            
            _tradeVC.pingZhengModel = [TemParkingListModel shareTemParkingListModelWithDic:dict[@"orderMap"]];
            _tradeVC.style = TradeStyleLinTing;
            [self.navigationController pushViewController:_tradeVC animated:YES];
            
            
        }else{
            
            ALERT_VIEW(dict[@"errorInfo"]);
            _alert = nil;
        }

    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        
    }];
    
}


- (void)changeBtnType{
    self.surePayBtn.userInteractionEnabled = NO;
    [self.surePayBtn setTitle:@"已支付" forState:(UIControlStateNormal)];
    
    self.surePayBtn.backgroundColor = [UIColor grayColor];
}
- (void)payForFailure:(NSString *)payState;{
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_temParkingModel.orderId,@"10",MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",_temParkingModel.orderId,_temParkingModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",CANCEL,_temParkingModel.orderId,@"10",summary];
    MyLog(@"%@",url);
    [RequestModel changeOrderInfoWithURl:url Completion:^(NSString *info) {
        
    } Fail:^(NSString *error) {
        
    }];
}

//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
