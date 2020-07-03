//
//  RendPayForController.m
//  P-Share
//
//  Created by 亮亮 on 16/2/19.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "RendPayForController.h"
#import "ChooseFreeViewController.h"
#import "RequestModel.h"
#import "NSString+MD5.h"
#import "PayModel.h"
#import "DataSource.h"
#import "walletPayView.h"
#import "AgainSetCodeController.h"
#import "CouponModel.h"
#import "TradeDetailVC.h"


#define psharePay   @"psharePay"
#define wechat      @"wechat"
#define alipay      @"alipay"

@interface RendPayForController ()<ChooseFreeDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIAlertView *_aletView;
    UIAlertView *_alert;
    
    NSString *_payType;
    NSString *_actulOrderPay;
    BOOL _paySucceed;
    
    payModel *_payModel;
    
    UIImageView *_temImage;
    walletPayView *_walletView;
    UITextField *_temText;
    TradeDetailVC *_tradeVC;
    
}

@property (nonatomic,strong)CouponModel *discountModel;
@end

@implementation RendPayForController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ALLOC_MBPROGRESSHUD
    
    if (self.temParkingModel) {
        [self loadData1];
        
    }else{
    [self loadData];
    }
    _grayView.hidden = YES;
    _payType = psharePay;
    _temImage = _selectSelfpayImageView;
    _paySucceed = NO;
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
- (void)loadData1{
    if ([self.temParkingModel.orderType isEqualToString:@"13"]) {
        _infoL.text = @"    月租费用缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!";
        _titleL.text = @"月租支付";
        
    }else
    {
        _infoL.text = @"    产权车位费缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!";
        _titleL.text = @"产权支付";
        
    }
    CGFloat  price = [self.temParkingModel.amountPayable integerValue]/[self.temParkingModel.monthNum integerValue];
    self.price = [NSString stringWithFormat:@"%lf",price];
    [self createMyUI];
}
- (void)loadData
{
    
    
    NSString *orderType = [_paramDic objectForKey:@"orderType"];
    if ([orderType isEqualToString:@"13"]) {
        _infoL.text = @"    月租费用缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!";
        _titleL.text = @"月租支付";

    }else
    {
        _infoL.text = @"    产权车位费缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!";
        _titleL.text = @"产权支付";

    }
    BEGIN_MBPROGRESSHUD
    [RequestModel requestCreateMonthRentOrderWithDic:_paramDic Completion:^(TemParkingListModel  *model) {
        
        _temParkingModel = model;
        _temParkingModel.carNumber = [_paramDic objectForKey:@"carNumber"];
        _temParkingModel.orderType = [_paramDic objectForKey:@"orderType"];
        [self createMyUI];

        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD
    }];
}
- (void)createMyUI{
   
    _payModel = [[payModel alloc]init];
    self.yingFuPrice.text =[NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    self.zheKouPrice.text = [NSString stringWithFormat:@"%@",_temParkingModel.amountDiscount];
    self.shiFuPrice.text = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPaid];
    _actulOrderPay = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPaid];
   
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"RendPayForController";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRentPayResult:) name:@"RendPayForController" object:nil];//监听一个通知
    

    
}


- (void)getRentPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        [self payForSccend:@"微信支付"];
       
    }
    else
    {
        [self payForFailure:@"微信支付"];
        
       
    }
}
#pragma mark - 
#pragma mark - 优惠劵页面代理回调
- (void)selectedFreeWithModel:(CouponModel *)model;{
    BEGIN_MBPROGRESSHUD;
    _discountModel = model;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_discountModel.couponId,@"couponId",userID,@"customerId", self.temParkingModel.orderId,@"orderId",dateString,@"timestamp",nil];
    
    [RequestModel requestWithUserCouponWithURL:nil WithDic:dic Completion:^(NSDictionary *dic) {
        _shiFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPaid"]];
        _zheKouPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountDiscount"]];
        _yingFuPrice.text = [NSString stringWithFormat:@"%@",dic[@"amountPayable"]];
        _actulOrderPay = _shiFuPrice.text;
        END_MBPROGRESSHUD
        
    } Fail:^(NSString *error) {
        END_MBPROGRESSHUD
        
    }];
    
    return;
}
#pragma mark -
#pragma mark - 微信支付宝支付
- (void)ziFuBaoPayFor{
    _payModel.orderDescribute = @"口袋停月租产权支付";
    

    _payModel.orderName = @"口袋停月租产权支付";

    _payModel.orderID =   self.temParkingModel.orderId;
    _payModel.orderPrice = _actulOrderPay;

    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_%@",SERVER_ID,self.temParkingModel.orderType];
    
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
        

        [self payForFailure:@"支付宝支付"];
        
        //        2:跳转到订单界面
        
    }];
}


- (void)weixinZhiFu{
    _payModel.orderDescribute = @"口袋停月租产权支付";
    _payModel.orderName = @"口袋停月租产权支付";
    _payModel.orderID =self.temParkingModel.orderId;
    _payModel.orderPrice =_actulOrderPay;
    //    _payModel.WeChatUrl = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay";
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_%@",SERVER_ID,self.temParkingModel.orderType];
    
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
    
    
    _turePay.userInteractionEnabled = NO;

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
        
    if (range.location == 5) {
     
        NSString *str = [NSString stringWithFormat:@"%@%@",_temText.text,string];
        _temText.text = str;
        
#pragma mark -- 密码输到六位时自动支付
        BEGIN_MBPROGRESSHUD
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temParkingModel.orderId,@"orderId",[_temText.text MD5],@"payPassword", nil];
        [RequestModel requestPayWithWalletWithURL:walletPay WithDic:dic Completion:^(NSDictionary *dic) {
            [self cancelWalletView:nil];
            [self payForSccend:@"钱包支付"];
            
            END_MBPROGRESSHUD
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
    _turePay.userInteractionEnabled = YES;

    if (btn.tag == 2) {
        [self payForFailure:@"钱包支付"];

    }
}

#pragma mark -
#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPaySuccess object:@"notification"];
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temParkingModel.orderId,self.temParkingModel.orderType,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,self.temParkingModel.orderId,self.temParkingModel.orderType,summary];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *requestModel = [RequestModel new];
    
    [requestModel getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            NSLog(@"%@",dict);
            
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                MyLog(@"success");
                [self chooseTureBtn];
                
                if (!_tradeVC) {
                    _tradeVC = [[TradeDetailVC alloc] init];
                }else{
                    return ;
                }
                
                _tradeVC.pingZhengModel = [TemParkingListModel shareTemParkingListModelWithDic:dict[@"data"]];
                _tradeVC.style = TradeStyleYueZu;
                [self.navigationController pushViewController:_tradeVC animated:YES];
             }else{
                
                
                ALERT_VIEW(dict[@"errorInfo"]);
                _alert = nil;
                
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
- (void)chooseTureBtn{
    
    self.turePay.backgroundColor = [UIColor grayColor];
    [self.turePay setTitle:@"已支付" forState:(UIControlStateNormal)];
   
    self.turePay.userInteractionEnabled = NO;
    
}
#pragma mark -
#pragma mark - 支付失败解除优惠劵

- (void)payForFailure:(NSString *)payState{
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temParkingModel.orderId,self.temParkingModel.orderType,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",CANCEL,self.temParkingModel.orderId,self.temParkingModel.orderType,summary];
   
    [RequestModel changeOrderInfoWithURl:url Completion:^(NSString *info) {
        
        
        
    } Fail:^(NSString *error) {
        
    }];
}
#pragma mark -
#pragma mark - 按钮的点击
- (IBAction)distanceMoney:(id)sender {
    ChooseFreeViewController *chooseCtrl = [[ChooseFreeViewController alloc] init];
    chooseCtrl.delegate = self;
    if (self.temParkingModel) {
          chooseCtrl.parkingId = self.temParkingModel.parkingId;
        
    }else{
        chooseCtrl.parkingId = self.parkingId;
    }
    
    chooseCtrl.orderType = self.temParkingModel.orderType;
    chooseCtrl.orderTotalPay =  [_yingFuPrice.text intValue];
    
    [self.navigationController pushViewController:chooseCtrl animated:YES];

    
}

- (IBAction)payBtn:(UIButton *)sender {
    
    if (self.temParkingModel.orderId == nil || _actulOrderPay == nil) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    if ([self.temParkingModel.orderStatus integerValue] == 11) {
        ALERT_VIEW(@"请勿重复支付");
        _alert = nil;
        return;
    }else{
        [self pinlessOrderAndConpon];
    }
}

- (IBAction)choosePayKind:(UIButton *)sender {
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
//    NSString *price = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    NSString *dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"口袋停月租产权支付\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",self.temParkingModel.orderId,self.price];
   
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _temParkingModel.orderId,@"orderId",self.temParkingModel.orderType,@"orderType",payType,@"payType",dateString,@"timestamp",self.price,@"price",dataStr,@"useInfo",@"2.0.4",@"version",_discountModel.couponId,@"couponId",nil];
    BEGIN_MBPROGRESSHUD
   [RequestModel pinlessOrderAndConponWithDic:dic Completion:^(NSDictionary *dic) {
        
        //           支付类型 00:支付宝，01:微信，02:银联
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            
            MyLog(@"支付");
            _actulOrderPay = _yingFuPrice.text;
            
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
            MyLog(@"不支付");
            
        }
    }
    else if (alertView.tag == 2) {
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

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
