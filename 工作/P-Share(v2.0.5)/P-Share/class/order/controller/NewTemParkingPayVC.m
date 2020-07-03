//
//  NewTemParkingPayVC.m
//  P-Share
//
//  Created by fay on 16/2/17.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewTemParkingPayVC.h"
#import "ChooseFreeViewController.h"
#import "DiscountModel.h"
#import "CouponModel.h"
#import "PayModel.h"
#import "RequestModel.h"
#import "NSString+MD5.h"
#import "temParkingPayResultVC.h"
#import "walletPayView.h"
#import "AgainSetCodeController.h"
#import "TradeDetailVC.h"



#define psharePay   @"psharePay"
#define wechat      @"wechat"
#define alipay      @"alipay"
@interface NewTemParkingPayVC ()<ChooseFreeDelegate,UITextFieldDelegate>
{
    NSString *_payType;

    
    UIAlertView *_alert;
    UIAlertView *_aletView;

    NSString *_actulOrderPay;

    payModel *_payModel;

    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    TemParkingListModel *_temModel;
    CouponModel *_discountModel;
    temParkingPayResultVC *_temParkingPayResultVC;
    UIImageView *_temImage;
    walletPayView *_walletView;
    UITextField *_temText;
    TradeDetailVC *_tradeVC;

}

@end

@implementation NewTemParkingPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ALLOC_MBPROGRESSHUD;
    _payModel = [[payModel alloc] init];
    _grayView.hidden = YES;
    
    _temModel = _temPayModel;
    MyLog(@"%@",_temModel);
    if (self.temParkModel) {
        [self createOrder];
    }else{
      [self requestOrder];
    }
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
- (void)createOrder{
    _temPayModel = self.temParkModel;
    
    [self initData];
}
- (void)requestOrder
{
//               获取时间戳
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"customerId",_temPayModel.carNumber,@"carNumber",@"11",@"orderType",dateString,@"timestamp",_temPayModel.parkingId,@"parkingId",nil];
    
    BEGIN_MBPROGRESSHUD;
    [RequestModel requestCreateTemparkingOrderWithURL:ORDERC WithType:@"0" WithDic:dic Completion:^(TemParkingListModel *temOrderModel) {
        _temPayModel = temOrderModel;
        
        [self initData];
        
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        
        _aletView = [[UIAlertView alloc] initWithTitle:error message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_aletView show];
        END_MBPROGRESSHUD;
        
    }];
    

}

- (void)initData
{
    _payType = psharePay;
    _temImage = _selectSelfpayImageView;

    _shiFuPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountPaid];
    _zheKouPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountDiscount];
    _yingFuPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountPayable];
    _actulOrderPay = _shiFuPrice.text;
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

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
            [self payForFailure:nil];
            
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self payForFailure:psharePay];

            AgainSetCodeController *againVC = [[AgainSetCodeController alloc]init];
            againVC.isBeginCode = @"NO";
            [self.navigationController pushViewController:againVC animated:YES];
        }else
        {
            
            [self payForFailure:psharePay];
            
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"NewTemParkingPayVC";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRentPayResult:) name:@"NewTemParkingPayVC" object:nil];//监听一个通知
}

- (void)getRentPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        [self payForSccend:@"微信支付"];
//        ALERT_VIEW(@"您已支付成功\n请在15分钟之内离场");
        

    }
    else
    {
        [self payForFailure:@"微信支付"];

    }
}
#pragma mark - 
#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState;{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPaySuccess object:nil];
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temPayModel.orderId,self.temPayModel.orderType,MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",self.temPayModel.orderId,self.temPayModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,self.temPayModel.orderId,self.temPayModel.orderType,summary];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BEGIN_MBPROGRESSHUD
    [RequestModel requestGetLatestInvoiceInfoWithURL:urlString Completion:^(NSDictionary *dic) {
        END_MBPROGRESSHUD
        
        if ([dic[@"errorNum"] isEqualToString:@"0"])
        {
            MyLog(@"success");
            [self changeBtnType];
            if (!_tradeVC) {
                _tradeVC = [[TradeDetailVC alloc] init];
            }else{
                return ;
            }
            
            _tradeVC.pingZhengModel = [TemParkingListModel shareTemParkingListModelWithDic:dic[@"order"]];
            _tradeVC.style = TradeStylelinTing;
            [self.navigationController pushViewController:_tradeVC animated:YES];
          
            
            
            
        }else
        {
           
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
        }

       

        
    } Fail:^(NSString *error) {
        
        END_MBPROGRESSHUD;
        ALERT_VIEW(error);
        _alert = nil;
        
    }];

}
- (void)changeBtnType{
    self.tureBtn.userInteractionEnabled = NO;
    [self.tureBtn setTitle:@"已支付" forState:(UIControlStateNormal)];

    self.tureBtn.backgroundColor = [UIColor grayColor];
    
}
#pragma mark -
#pragma mark - 支付失败解除优惠劵

- (void)payForFailure:(NSString *)payState;{

    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temPayModel.orderId,self.temPayModel.orderType,MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",self.temPayModel.orderId,self.temPayModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",CANCEL,self.temPayModel.orderId,self.temPayModel.orderType,summary];
    MyLog(@"%@",url);
    [RequestModel changeOrderInfoWithURl:url Completion:^(NSString *info) {
        
    } Fail:^(NSString *error) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (IBAction)useYouHuiQuanClick:(UIButton *)sender {
    ChooseFreeViewController *chooseCtrl = [[ChooseFreeViewController alloc] init];
    chooseCtrl.delegate = self;
    if (self.temParkModel) {
        chooseCtrl.parkingId = _temParkModel.parkingId;
    }else{
        chooseCtrl.parkingId = _temModel.parkingId;
   
    }
   
    chooseCtrl.orderType = _temPayModel.orderType;
    chooseCtrl.orderTotalPay =  [_yingFuPrice.text intValue];
    
    [self.navigationController pushViewController:chooseCtrl animated:YES];
    
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_discountModel.couponId,@"couponId",userID,@"customerId", _temPayModel.orderId,@"orderId",dateString,@"timestamp",nil];
    
    [RequestModel requestWithUserCouponWithURL:nil WithDic:dic Completion:^(NSDictionary *dic) {
        _shiFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPaid"]];
        _zheKouPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountDiscount"]];
        _yingFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPayable"]];
        
        _temPayModel.amountDiscount = _zheKouPrice.text;
        _temPayModel.amountPaid = _shiFuPrice.text;
        _temPayModel.amountPayable = _yingFuPrice.text;
        _actulOrderPay = _shiFuPrice.text;
        END_MBPROGRESSHUD

    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        
    }];
    
    return;
    
    

}

#pragma mark -- 选择支付方式
- (IBAction)choosePayKindClick:(UIButton *)sender {
    
    
    
    _temImage.image = [UIImage imageNamed:@"unselect"];
    //    _temImage.image = [UIImage imageNamed:@"selected"];
    
    
    if (sender.tag == 0) {
        //        钱包支付
        _selectSelfpayImageView.image = [UIImage imageNamed:@"selected"];
        _temImage = _selectSelfpayImageView;
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

#pragma mark -- 确认支付
- (IBAction)ensurePayClick:(UIButton *)sender {
    
        
    //        保护防止订单为nil的情况
    if (_temPayModel.orderId == nil || _actulOrderPay == nil || [_yingFuPrice.text isEqualToString:@"0"]) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    
    if ([_temPayModel.orderStatus isEqualToString:@"11"]) {
        ALERT_VIEW(@"请勿重复支付");
        _alert = nil;
        return;
    }
    else
    {
        [self pinlessOrderAndConpon];
    }
    
}


- (void)payOrderWithZhiFuBao
{
   
    _payModel.orderDescribute = @"口袋停临停支付";
    _payModel.orderName = @"口袋停临停支付";
    _payModel.orderID = _temPayModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_11",SERVER_ID];
    
    [_payModel payWithAlipayDic:nil CanOpenAlipay:^(BOOL isCan) {
        if (isCan == NO) {
            [self payForFailure:@"支付宝支付"];
            ALERT_VIEW(@"您未安装支付宝或版本不支持");
            _alert = nil;
            return;
        }
        
    } Completion:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            [self payForSccend:@"支付宝支付"];
            
        }
        
    } Fail:^(BOOL fail) {
        
        //        1:支付失败：告诉服务器  让订单与优惠券进行解绑
        
        [self payForFailure:@"支付宝支付"];
        
        //        2:跳转到订单界面
        
    }];
    
}

- (void)payOrderWithWeiXin
{
    
    _payModel.orderDescribute = @"口袋停临停支付";
    _payModel.orderName = @"口袋停临停支付";
    _payModel.orderID = _temPayModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_11",SERVER_ID];
    
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
        
        ALERT_VIEW(@"订单获取失败");
        
        _alert = nil;
    }];
    
}
- (void)cancelWalletView:(UIButton *)btn
{
    [self.view endEditing:YES];
    _walletView.hidden = YES;
    _grayView.hidden = YES;
    _tureBtn.userInteractionEnabled = YES;
    if (btn.tag == 2) {
        [self payForFailure:@"钱包支付"];
    }


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
    _tureBtn.userInteractionEnabled = NO;
    
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

    __weak typeof(self) weakSelf = self;
    [_walletView.mimaLabel becomeFirstResponder];
    _temText = _walletView.mimaLabel;
    _walletView.moneyL.text = [NSString stringWithFormat:@"¥%@",_actulOrderPay];
    
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
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, SCREEN_WIDTH *0.7));
                
                
            }];
        }];
    }];

}



#pragma mark -- 监听密码输入

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    MyLog(@"%@",string);
    
    if (range.location == 5) {
        NSString *str = [NSString stringWithFormat:@"%@%@",_temText.text,string];
        _temText.text = str;
        
#pragma mark -- 密码输到六位时自动支付
        BEGIN_MBPROGRESSHUD
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temPayModel.orderId,@"orderId",[_temText.text MD5],@"payPassword", nil];
        
        [RequestModel requestPayWithWalletWithURL:walletPay WithDic:dic Completion:^(NSDictionary *dic) {
            [self cancelWalletView:nil];
            [self payForSccend:@"钱包支付"];
            END_MBPROGRESSHUD
        } Fail:^(NSString *error) {
            [self cancelWalletView:nil];
            ALERT_VIEW(error);
            _alert = nil;
            [self payForFailure:@"钱包支付"];
            END_MBPROGRESSHUD
        }];
        
        
    }
    
    return YES;
}


- (IBAction)backVC:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- 订单与可选优惠券绑定，保存支付请求信息（确认支付）
- (void)pinlessOrderAndConpon
{
    _tureBtn.userInteractionEnabled = NO;
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
    
    NSString *dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"口袋停临停支付\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",_temPayModel.orderId,_actulOrderPay];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _temPayModel.orderId,@"orderId",@"11",@"orderType",payType,@"payType",dateString,@"timestamp",dataStr,@"useInfo",@"2.0.4",@"version",nil];
    [dic setValue:_discountModel.couponId forKey:@"couponId"];
    BEGIN_MBPROGRESSHUD
    [RequestModel pinlessOrderAndConponWithDic:dic Completion:^(NSDictionary *dic) {
        
        _tureBtn.userInteractionEnabled = YES;
       
        //           支付类型 00:支付宝，01:微信，02:银联
        
        if ([dic[@"errorNum"] isEqualToString:@"3"]) {
            _aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"优惠券不可用，是否继续支付?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            _aletView.tag = 3;
            
            [_aletView show];
            return ;
            
        }
        
        else if ([dic[@"errorNum"] isEqualToString:@"0"]) {
            
#pragma mark --     psharePay
            
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
        END_MBPROGRESSHUD

        
    } Fail:^(NSString *error) {

        END_MBPROGRESSHUD
        ALERT_VIEW(@"订单支付失败");
        
        _alert = nil;
        _tureBtn.userInteractionEnabled = YES;
    }];
    
  
    
    
    //      拼接json字符串
    
    //    NSString *dataStr=@"{\"cross\":{\"1\":\"true\",\"2\":\"false\",\"3\":\"true\"}}";
    //
    //    MyLog(@"%@",dataStr);

    
    //    _payModel.orderDescribute = @"口袋停缴费";
//    _payModel.orderName = @"口袋停临停支付";
//    _payModel.orderID = _temPayModel.orderId;
//    _payModel.orderPrice = _actulOrderPay;
//    //    _payModel.WeChatUrl = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay";
//    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay",SERVER_ID];
    
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
