//
//  PurseTopUpController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "PurseTopUpController.h"
#import "TemParkingListModel.h"
#import "AgainSetCodeController.h"
#import "PayAlertView.h"
#define wechat      @"wechat"
#define alipay      @"alipay"
#define orderType   @"16"


@interface PurseTopUpController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSInteger _payMoney;
    NSString *_payType;
    TemParkingListModel *_orderModel;
    payModel *_payModel;
    UIAlertView *_alert;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    NSString *_getMeMoney;
    
    UIView *_bgView;
    
    
}
@end

@implementation PurseTopUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBorder)];
    [_ContainView addGestureRecognizer:tapGesture];
    [self setUI];
}
- (void)hiddenKeyBorder
{
    [_payForTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - 加载UI设置
- (void)setUI{
    
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        _bgView.hidden = YES;
        [self.view addSubview:_bgView];
    }
    
    _getMeMoney = [NSString stringWithFormat:@"%@",@"100"];
   
    _payType = wechat;
    _payMoney = 100;
    _payModel = [[payModel alloc] init];
    
    self.payForTextField.layer.borderWidth = 1;
    self.payForTextField.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.payForTextField.delegate = self;
    self.button1.layer.borderWidth = 1;
    self.button1.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.button2.layer.borderWidth = 1;
    self.button2.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.button3.layer.borderWidth = 1;
    self.button3.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    
}
#pragma mark - 
#pragma mark - Button点击事件
#pragma mark - 选择钱的大小
- (IBAction)selectMoney:(UIButton *)btn;{
    
    _payForTextField.text = @"";
    if (btn.tag == 13) {
        _payMoney = 100;
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if (btn.tag == 14){
        _payMoney = 200;
        [self.button1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
        [self.button3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else if (btn.tag == 15){
        _payMoney = 500;
        [self.button1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.button3 setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - 
#pragma mark - 到账金额

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"PurseTopUpController";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWallerPayResult:) name:@"PurseTopUpController" object:nil];//监听一个通知
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)getWallerPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        
        
        [self payForSccend:wechat];
        
    }
    else
    {
        
    }

}


#pragma mark - 确认支付
- (IBAction)PayForClick:(id)sender {
    
    [_payForTextField resignFirstResponder];
    
    BEGIN_MBPROGRESSHUD
    [RequestModel requestCalcGiftAmountWithUrl:_payMoney WithDic:nil Completion:^(NSDictionary *dic) {
        END_MBPROGRESSHUD
        _getMeMoney = [NSString stringWithFormat:@"%@",dic[@"totalAmount"]];
        
        if (_getMeMoney.length > 0) {
            PayAlertView *payAlertV = [[PayAlertView alloc]initWithFrame:CGRectZero WithPayMoney:_getMeMoney ActureMoney:[NSString stringWithFormat:@"%ld",(long)_payMoney]];
            _bgView.hidden = NO;
            [self.view addSubview:payAlertV];
            __weak typeof(self)weakSelf = self;
            [payAlertV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(weakSelf.view);
                make.width.mas_equalTo(weakSelf.view.mas_width).multipliedBy(0.75);
                make.height.mas_equalTo(weakSelf.view.mas_width).multipliedBy(0.52);
            }];
            payAlertV.cancelBlock = ^(){
                
                _bgView.hidden = YES;
                
            };
            payAlertV.payBlock = ^(){
                
                _bgView.hidden = YES;
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *userID = [userDefault objectForKey:customer_id];
                NSString *payType = [_payType isEqualToString:wechat] ? @"01":@"00";
                
                if (_payForTextField.text.length > 0) {
                    _payMoney = [_payForTextField.text integerValue];
                    
                }
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"customerId",orderType,@"orderType",@"",@"useInfo",[NSString stringWithFormat:@"%ld",(long)_payMoney],@"amountPayable",payType,@"payType",@"2.0.4",@"version",nil];
                
                [RequestModel requestCreateTemparkingOrderWithURL:ORDERC WithType:@"0" WithDic:dic Completion:^(TemParkingListModel *model) {
                    
                    _orderModel = model;
                    if ([_payType isEqualToString:wechat]) {
                        MyLog(@"微信支付");
                        [self payOrderWithWeiXin];
                    }else if ([_payType isEqualToString:alipay]){
                        MyLog(@"支付宝支付");
                        [self payOrderWithZhiFuBao];
                    }
                    
                } Fail:^(NSString *error) {
                    ALERT_VIEW(error);
                    _alert = nil;
                    
                }];
                
            };
            
        }

        
    } Fail:^(NSString *errror) {
        END_MBPROGRESSHUD
    }];
    
  
}

#pragma mark -- 支付宝、微信支付
- (void)payOrderWithZhiFuBao
{
    _payModel.orderDescribute = @"口袋停钱包充值";
    
    _payModel.orderName = @"口袋停钱包充值";
    
    _payModel.orderID = _orderModel.orderId;
    _payModel.orderPrice = _orderModel.amountPayable;
    
//    _payModel.orderPrice = [NSString stringWithFormat:@"%f",0.01];
    
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_16",SERVER_ID];
    
    [_payModel payWithAlipayDic:nil CanOpenAlipay:^(BOOL isCan) {
        if (isCan == NO) {
            
            ALERT_VIEW(@"您未安装支付宝或版本不支持");
            _alert = nil;
            return;
        }
        
    } Completion:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            [self payForSccend:alipay];
            
        }
        
    } Fail:^(BOOL fail) {
        
    }];
    
}


- (void)payOrderWithWeiXin
{
    
    _payModel.orderDescribute = @"口袋停钱包充值";

    _payModel.orderName = @"口袋停钱包充值";
    
    _payModel.orderID = _orderModel.orderId;
    _payModel.orderPrice = _orderModel.amountPayable;
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_16",SERVER_ID];
    
    [_payModel payWithWeChatDic:nil CanOpenWeChat:^(BOOL isCan) {
        
        if (isCan == NO) {
            
            ALERT_VIEW(@"您未安装微信或版本不支持");
            _alert = nil;
        }
        return ;
        
    } Completion:^(BOOL isSuccess) {
        
        
    } Fail:^(BOOL fail) {
#pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
        
        ALERT_VIEW(@"订单支付失败");
        _alert = nil;
        
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            AgainSetCodeController *againVC = [[AgainSetCodeController alloc]init];
            againVC.isBeginCode = @"NO";
            [self.navigationController pushViewController:againVC animated:YES];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if(alertView.tag == 3){
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

#pragma mark -- 充值成功后调用
#pragma mark - 支付成功修改订单状态
- (void)payForSccend:(NSString *)payState{

    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_orderModel.orderId,orderType,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,_orderModel.orderId,orderType,summary];
    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"errorNum"] isEqualToString:@"0"]||[dict[@"errorNum"] isEqualToString:@"1"])
            {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                if (![[user objectForKey:pay_password] isEqualToString:@"1"]) {
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为保护账号的安全，请您先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertV.tag = 2;
                    [alertV show];
                    
                }else
                {
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"充值成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alertV.tag = 3;
                    [alertV show];
                }
                
                //                 刷新钱包界面数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWalletMoney" object:nil];
                
                [self changeBtnType];
                
            }else{
                NSLog(@"fail");
                
            }
            MyLog(@"支付调用---不需要查看返回----%@",dict);
        }

    } error:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
    } failure:^(NSString *fail) {
        ALERT_VIEW(fail);
        _alert = nil;
    }];
}

- (void)changeBtnType
{
    [_payForBtn setTitle:@"充值成功" forState:(UIControlStateNormal)];
    _payForBtn.backgroundColor = [UIColor grayColor];
    _payForBtn.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    
}
#pragma mark - 返回
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 选择支付方式
- (IBAction)selectBtn:(id)button;{
    if (button == self.weixinBtn) {
        self.zhifubaoImage.image = [UIImage imageNamed:@"unselect"];
        self.weixinImage.image = [UIImage imageNamed:@"selected"];
         _payType = wechat;
    }else if (button == self.zhifubaoBtn){
        self.zhifubaoImage.image = [UIImage imageNamed:@"selected"];
        self.weixinImage.image = [UIImage imageNamed:@"unselect"];
        _payType = alipay;
    }
   
}

#pragma mark -
#pragma mark - textField 代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    if(textField == self.payForTextField){
        static NSString *str = nil;
       if (range.length == 0) {
            str = [NSString stringWithFormat:@"%@%@",_payForTextField.text,string];
            
           _payMoney = [str integerValue];
            return YES;
        }
        if (range.length == 1) {
            NSString *str1 = [str substringToIndex:range.location];
             _payMoney = [str1 integerValue];
        }
        
   
}
     return YES;
}
@end
