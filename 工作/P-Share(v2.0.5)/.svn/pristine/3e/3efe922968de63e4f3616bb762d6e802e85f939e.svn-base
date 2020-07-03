//
//  ClearCarPay.m
//  P-Share
//
//  Created by fay on 16/4/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ClearCarPay.h"
#import "ChooseFreeViewController.h"
#import "walletPayView.h"
#import "TemParkingListModel.h"
#import "CouponModel.h"
#import "TradeDetailVC.h"
#import "AgainSetCodeController.h"
#import "WashCarOrderController.h"

#define psharePay   @"psharePay"
#define wechat      @"wechat"
#define alipay      @"alipay"
@interface ClearCarPay ()<ChooseFreeDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSString *_payType;
    UIImageView *_temImage;
    NSString *_actulOrderPay;
    UIAlertView *_alert;
    UIAlertView *_aletView;
    CouponModel *_discountModel;
    walletPayView *_walletView;
    payModel *_payModel;
    UITextField *_temText;
    UIView *_grayView;
    TradeDetailVC *_tradeVC;
    

}
@end

@implementation ClearCarPay

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD
    if (self.temParkingModel) {
        [self loadData1];
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

- (void)loadData1{
    _payModel = [[payModel alloc]init];
    
    self.yingFuPrice.text =[NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    self.zheKouPrice.text = [NSString stringWithFormat:@"%@",_temParkingModel.amountDiscount];
    self.shiFuPrice.text = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPaid];
    _actulOrderPay = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    
    if (!_grayView) {
        _grayView = [[UIView alloc] initWithFrame:self.view.frame];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0.3;
        [self.view addSubview:_grayView];
        _grayView.hidden = YES;
    }
    self.temParkingModel.carNumber = [_pamaDict objectForKey:@"carNumber"];

    _temImage = _selectSelfImageView;
    _payType = psharePay;
}
- (void)requestOrder{
     BEGIN_MBPROGRESSHUD;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.pamaDict];
    [RequestModel requestCreateMonthRentOrderWithDic:dict Completion:^(TemParkingListModel *model) {
        
        self.temParkingModel = model;
        self.temParkingModel.carNumber = [_pamaDict objectForKey:@"carNumber"];

        [self loadUI];
         END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
         END_MBPROGRESSHUD
    }];
    
    
}
- (void)loadUI
{
    _payModel = [[payModel alloc]init];
    self.yingFuPrice.text =[NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    self.zheKouPrice.text = [NSString stringWithFormat:@"%@",_temParkingModel.amountDiscount];
    self.shiFuPrice.text = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPaid];
    _actulOrderPay = [NSString stringWithFormat:@"%@",self.temParkingModel.amountPayable];
    if (!_grayView) {
        _grayView = [[UIView alloc] initWithFrame:self.view.frame];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0.3;
        [self.view addSubview:_grayView];
        _grayView.hidden = YES;
    }
    
    _temImage = _selectSelfImageView;
    _payType = psharePay;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
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
#pragma mark --使用优惠券
- (IBAction)useYouHuiQuanClick:(UIButton *)sender {
    
    ChooseFreeViewController *chooseCtrl = [[ChooseFreeViewController alloc] init];
    chooseCtrl.delegate = self;
    chooseCtrl.orderType = @"17";
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

#pragma mark -- 确认支付
- (IBAction)ensurePayClick:(UIButton *)sender {
    
    //        保护防止订单为nil的情况
    if (_temParkingModel.orderId == nil || _actulOrderPay == nil || [_yingFuPrice.text isEqualToString:@"0"]) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    
    if ([_payType isEqualToString:@"0"]){
        ALERT_VIEW(@"请选择支付方式");
        _alert = nil;
    }else{
        
        
        [self pinlessOrderAndConpon];
        
        
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
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _temParkingModel.orderId,@"orderId",@"17",@"orderType",payType,@"payType",dateString,@"timestamp",_actulOrderPay,@"price",dataStr,@"useInfo",@"2.0.4",@"version",nil];
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

     UIAlertController *alert = [MyUtil alertController:@"为保护账号的安全，请您先设置交易密码" Completion:^{
         AgainSetCodeController *againVC = [[AgainSetCodeController alloc]init];
         againVC.isBeginCode = @"NO";
         [self.navigationController pushViewController:againVC animated:YES];
        
     }Fail:^{
         
         [self payForFailure:psharePay];
         
     }];
        
       
        [self presentViewController:alert animated:YES completion:^{
            
       
    }];
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
    
    [_walletView loadMimaLabel];
    
    _walletView.hidden = NO;
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
        
        BEGIN_MBPROGRESSHUD
        
        NSString *str = [NSString stringWithFormat:@"%@%@",_temText.text,string];
        _temText.text = str;
        
#pragma mark -- 密码输到六位时自动支付
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_temParkingModel.orderId,@"orderId",[_temText.text MD5] ,@"payPassword", nil];
        [RequestModel requestPayWithWalletWithURL:walletPay WithDic:dic Completion:^(NSDictionary *dic) {
            [self cancelWalletView:nil];
            _temText.text = @"";
            _walletView.hidden = YES;
            [self.view endEditing:YES];
            _grayView.hidden = YES;
            
            [self payForSccend:@"钱包支付"];
            
            
            END_MBPROGRESSHUD
            
        } Fail:^(NSString *erroe) {
            [self cancelWalletView:nil];
            ALERT_VIEW(erroe);
            _alert = nil;
            _temText.text = @"";
            textField.text = @"";

            [self payForFailure:@"钱包支付"];
            
            END_MBPROGRESSHUD
        }];
    }
    
    return YES;
}



- (void)cancelWalletView:(UIButton *)btn
{
    _walletView.hidden = YES;
    [self.view endEditing:YES];
    _grayView.hidden = YES;
    _surePayBtn.userInteractionEnabled = YES;
    if (btn.tag == 2) {
        
        [self payForFailure:@"钱包支付"];
        
    }
    
}


- (void)payOrderWithZhiFuBao
{
    _payModel.orderDescribute = @"口袋停洗车支付";
    
    _payModel.orderName = @"口袋停洗车支付";
    
    _payModel.orderID = _temParkingModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    //    _payModel.orderPrice = [NSString stringWithFormat:@"%d",0];
    
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_17",SERVER_ID];
    
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
    _payModel.orderDescribute = @"口袋停洗车支付";
    _payModel.orderName = @"口袋停洗车支付";
    _payModel.orderID = _temParkingModel.orderId;
    _payModel.orderPrice = _actulOrderPay;
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_17",SERVER_ID];
    
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

#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState;{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_temParkingModel.orderId,@"17",MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",_temParkingModel.orderId,_temParkingModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,_temParkingModel.orderId,@"17",summary];
    
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
           
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                
                [self changeBtnType];
                if (!_tradeVC) {
                     _tradeVC = [[TradeDetailVC alloc] init];
                }else{
                    return ;
                }
               
                _tradeVC.pingZhengModel = [TemParkingListModel shareTemParkingListModelWithDic:dict[@"data"]];
                _tradeVC.style = TradeStyleWashCar;
                [self.navigationController pushViewController:_tradeVC animated:YES];
                

                
            }else{
                
                
                ALERT_VIEW(dict[@"errorInfo"]);
                _alert = nil;
                
            }
            MyLog(@"支付调用---不需要查看返回----%@",dict);
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
    self.surePayBtn.backgroundColor = [UIColor lightGrayColor];
    [self.surePayBtn setTitle:@"支付成功" forState:(UIControlStateNormal)];
    self.surePayBtn.userInteractionEnabled = NO;
}
- (void)payForFailure:(NSString *)payState;{
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_temParkingModel.orderId,_temParkingModel.orderType,MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",_temParkingModel.orderId,_temParkingModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",CANCEL,_temParkingModel.orderId,_temParkingModel.orderType,summary];
    MyLog(@"%@",url);
    [RequestModel changeOrderInfoWithURl:url Completion:^(NSString *info) {
        
    } Fail:^(NSString *error) {
        
    }];
}



- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
