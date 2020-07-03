//
//  NewTemParkingPayVC.m
//  P-Share
//
//  Created by fay on 16/2/17.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NewDaiBoPayVC.h"
#import "ChooseFreeViewController.h"
#import "DiscountModel.h"
#import "CouponModel.h"
#import "PayModel.h"
#import "RequestModel.h"
#import "NSString+MD5.h"
#import "walletPayView.h"
#import "temParkingPayResultVC.h"
#import "AgainSetCodeController.h"
#define psharePay   @"psharePay"
#define wechat      @"wechat"
#define alipay      @"alipay"
#define DaiBoPayType    @"12"
@interface NewDaiBoPayVC ()<ChooseFreeDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSString *_payType;
    NSInteger _currentSelectIndex;
    UIAlertView *_alert;
    UIAlertView *_aletView;
    NSString *_actulOrderPay;
    payModel *_payModel;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    CouponModel *_discountModel;
    temParkingPayResultVC *_temParkingPayResultVC;
    UIImageView *_temImage;
    
    walletPayView *_walletView;
    
    UITextField *_temText;
}

@end

@implementation NewDaiBoPayVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //    初始化MBProgressHUD
    ALLOC_MBPROGRESSHUD;

    
    [self initData];
    
//    [self payForFailure:psharePay];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];

    [self.view insertSubview:btn belowSubview:_grayView];
    
    
}

- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadData
{
    _payModel = [[payModel alloc]init];
    _payType = psharePay;
    _temImage = _selectSelfpayImageView;
    
    _grayView.hidden = YES;
    
    
    _yingFuPrice.text = _price;
    _zheKouPrice.text = [NSString stringWithFormat:@"%d",0];
    _shiFuPrice.text = _price;
    _actulOrderPay = _shiFuPrice.text;
    

    
    
}
//- (void)hiddenGrayView:(UITapGestureRecognizer *)tapGesture
//{
//    _grayView.hidden = YES;
//    _commentView.hidden = YES;
//}

- (void)initData
{
    _payModel = [[payModel alloc]init];
    _payType = psharePay;
    _currentSelectIndex = 0;
    _shiFuPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountPaid];
    _zheKouPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountDiscount];
    _yingFuPrice.text = [NSString stringWithFormat:@"%@",_temPayModel.amountPayable];
    _actulOrderPay = _yingFuPrice.text;
    _grayView.hidden = YES;
    _temImage = _selectSelfpayImageView;


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 4) {
        if (buttonIndex == 0) {
            
            MyLog(@"支付");
            _actulOrderPay = _yingFuPrice.text;
            
            MyLog(@"%@",_actulOrderPay);
            
            if ([_payType isEqualToString:wechat]) {
                MyLog(@"微信支付");
                [self weixinZhiFu];
            }else if ([_payType isEqualToString:alipay]){
                MyLog(@"支付宝支付");
                [self ziFuBaoPayFor];
            }else if ([_payType isEqualToString:psharePay]){
                MyLog(@"钱包支付");
                [self payOrderWithWallet];
            }
            
        }if (buttonIndex == 1) {
            
            [self payForFailure:psharePay];
            
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
    app.payResultType = @"NewDaiBoPayVC";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRentPayResult:) name:@"NewDaiBoPayVC" object:nil];//监听一个通知
}

- (void)getRentPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {

        _grayView.hidden = YES;
        [self payForSccend:wechat];
        [self changeBtnType];
    }
    else
    {
        
        [self payForFailure:wechat];
    }
}
#pragma mark - 
#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState{

    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temPayModel.orderId,self.temPayModel.orderType,MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",self.temPayModel.orderId,self.temPayModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,self.temPayModel.orderId,self.temPayModel.orderType,summary];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                [self changeBtnType];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
                
                
                OrderPointModel *orderPoint = [OrderPointModel shareOrderPoint];
                if (orderPoint.paker>0) {
                    orderPoint.paker--;
                }
            }else{
                MyLog(@"fail");
            }
        }
        END_MBPROGRESSHUD;
    } error:^(NSString *error) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(error);
        _alert = nil;

    } failure:^(NSString *fail) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(fail);
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

- (void)payForFailure:(NSString *)payState{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temPayModel.orderId,DaiBoPayType,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",CANCEL,self.temPayModel.orderId,DaiBoPayType,summary];
    
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
    chooseCtrl.orderType = DaiBoPayType;
    chooseCtrl.parkingId = self.parkingId;
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
        _actulOrderPay = _shiFuPrice.text;
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        
    }];
}

#pragma mark -- 选择支付方式
- (IBAction)choosePayKindClick:(UIButton *)sender {
    
    _temImage.image = [UIImage imageNamed:@"unselect"];
    
    
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
    
        
    if (self.temPayModel.orderId == nil || _actulOrderPay == nil) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    if ([self.temPayModel.orderStatus integerValue] == 11) {
        ALERT_VIEW(@"请勿重复支付");
        _alert = nil;
        return;
    }else{
        [self pinlessOrderAndConpon];
    }
    
}

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
    //    NSString *price = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    NSString *dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"口袋停代泊支付\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",self.temPayModel.orderId,_actulOrderPay];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _temPayModel.orderId,@"orderId",DaiBoPayType,@"orderType",payType,@"payType",dateString,@"timestamp",_actulOrderPay,@"price",dataStr,@"useInfo",@"2.0.4",@"version",_discountModel.couponId,@"couponId",nil];
    
    BEGIN_MBPROGRESSHUD;
    [RequestModel pinlessOrderAndConponWithDic:dic Completion:^(NSDictionary *dic) {
        
        END_MBPROGRESSHUD
        //           支付类型 00:支付宝，01:微信，02:银联
        
        if ([dic[@"errorNum"] isEqualToString:@"3"]) {
            _aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"优惠券不可用，是否继续支付?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            _aletView.tag = 3;
            
            [_aletView show];
            return ;
            
        }
        
        else if ([dic[@"errorNum"] isEqualToString:@"0"]) {
            if ([_payType isEqualToString:wechat]) {
                MyLog(@"微信支付");
                [self weixinZhiFu];
            }else if ([_payType isEqualToString:alipay]){
                MyLog(@"支付宝支付");
                [self ziFuBaoPayFor];
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
}

- (void)weixinZhiFu
{
    _payModel.orderDescribute = @"口袋停代泊支付";
    
    _payModel.orderName = @"口袋停代泊支付";
    
    _payModel.orderID = _temPayModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_%@",SERVER_ID,DaiBoPayType];
    
    [_payModel payWithWeChatDic:nil CanOpenWeChat:^(BOOL isCan) {
        
        if (isCan == NO) {
            
            [self payForFailure:wechat];
            
            ALERT_VIEW(@"您未安装微信或版本不支持");
            _alert = nil;
        }
        return ;
        
    } Completion:^(BOOL isSuccess) {
        
        
    } Fail:^(BOOL fail) {
#pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
        
        ALERT_VIEW(@"订单支付失败");
        _alert = nil;
        
        
        [self payForFailure:wechat];
        
    }];

    
}

- (void)ziFuBaoPayFor
{
    _payModel.orderDescribute = @"口袋停代泊支付";
    
    _payModel.orderName = @"口袋停代泊支付";
    
    _payModel.orderID = _temPayModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_%@",SERVER_ID,DaiBoPayType];
    
    [_payModel payWithAlipayDic:nil CanOpenAlipay:^(BOOL isCan) {
        if (isCan == NO) {
            
            [self payForFailure:alipay];
            ALERT_VIEW(@"您未安装支付宝或版本不支持");
            _alert = nil;
            return;
        }
        
    } Completion:^(BOOL isSuccess) {
        
        if (isSuccess) {
            [self payForSccend:alipay];
            
            _grayView.hidden = YES;
            [self changeBtnType];
            
        }
        
    } Fail:^(BOOL fail) {
        
        
        //        1:支付失败：告诉服务器  让订单与优惠券进行解绑
        
        [self payForFailure:alipay];
        
        
        
    }];

    
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
    
    [_walletView loadMimaLabel];
    _walletView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [_walletView.mimaLabel becomeFirstResponder];
    
    _walletView.mimaLabel.tag = 2;
    
    _temText = _walletView.mimaLabel;
    
    _walletView.mimaLabel.delegate = self;
    
    _walletView.transform = CGAffineTransformMakeScale(1.03, 1.03);
    
    _walletView.moneyL.text = [NSString stringWithFormat:@"¥%@",_actulOrderPay];

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
    
    if (textField.tag == 2) {
        
        if (range.location == 5) {
            NSString *str = [NSString stringWithFormat:@"%@%@",_temText.text,string];
            _temText.text = str;
            
#pragma mark -- 密码输到六位时自动支付
            BEGIN_MBPROGRESSHUD
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temPayModel.orderId,@"orderId",[_temText.text MD5],@"payPassword", nil];
            
            [RequestModel requestPayWithWalletWithURL:walletPay WithDic:dic Completion:^(NSDictionary *dic) {
                [self cancelWalletView:nil];
                [self payForSccend:psharePay];
                [self changeBtnType];
                END_MBPROGRESSHUD
            } Fail:^(NSString *erroe) {
                [self cancelWalletView:nil];
                ALERT_VIEW(erroe);
                _alert = nil;
                [self payForFailure:psharePay];
                END_MBPROGRESSHUD
            }];
        }
    }
    return YES;
}

- (void)cancelWalletView:(UIButton *)btn
{
    [self.view endEditing:YES];
    _walletView.hidden = YES;
    _grayView.hidden = YES;
    _tureBtn.userInteractionEnabled = YES;
    
    if (btn.tag == 2) {
        [self payForFailure:psharePay];
    }
}

- (IBAction)backVC:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
