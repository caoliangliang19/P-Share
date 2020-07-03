//
//  CardPayViewController.m
//  P-Share
//
//  Created by fay on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CardPayViewController.h"
#import "PayModel.h"
#import "RequestModel.h"
#import "TemParkingListModel.h"
#import "OilCardOrderList.h"

@interface CardPayViewController ()
{
    NSString *_payType;

    UIAlertView *_alert;
    
    payModel *_payModel;
    
    UIAlertView *_aletView;
    
    NSString  *_actulOrderPay;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;

}
@property(nonatomic,strong)TemParkingListModel *temModel;
@end

@implementation CardPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
    [self createUI];
    if (self.temModel1) {
    [self createOrder1];
    }else{
    [self createOrder];
    }
}
- (void)createUI{
    _payType = @"wechat";
     _payModel = [[payModel alloc] init];
    self.payMoneyL.text = [NSString stringWithFormat:@"%@",self.myMoney];
}
- (void)createOrder1{
    self.temModel = self.temModel1;
    _actulOrderPay = [NSString stringWithFormat:@"%@",self.temModel.amountPaid];
}
- (void)createOrder{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefault objectForKey:customer_id];
    NSString *cardnum = nil;
    if ([self.proid integerValue] ==10001||[self.proid integerValue] ==10003||[self.proid integerValue] ==10004) {
        cardnum = @"1";
    }else{
        cardnum = self.Money;
    }
    NSString *distance = [NSString stringWithFormat:@"%.2lf",[self.Money floatValue] - [self.myMoney floatValue]];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"customerId",@"15",@"orderType",self.model.id,@"cardId",cardnum,@"topupNum",self.proid,@"topupType",self.Money,@"amountPayable",distance,@"amountDiscount",dateString,@"timestamp",nil];
    
    [RequestModel requestCreateTemparkingOrderWithURL:ORDERC WithType:@"0" WithDic:dic Completion:^(TemParkingListModel *model) {
        self.temModel = model;
        _actulOrderPay = [NSString stringWithFormat:@"%@",model.amountPaid];
    } Fail:^(NSString *error) {
        self.tureBtn.userInteractionEnabled = NO;
        self.tureBtn.backgroundColor = [UIColor grayColor];
        ALERT_VIEW(@"加油卡信息错误");
        
}];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --监听一个通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"CardPayViewController";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardPayViewControllerPayResult:) name:@"CardPayViewController" object:nil];//监听一个通知
    
    
}


#pragma mark -- 监听微信支付返回的结果
- (void)getCardPayViewControllerPayResult:(NSNotification *)notification
{
    MyLog(@"weixin");
    
    
    if ([notification.object isEqualToString:@"success"]) {
        MyLog(@"success");
        [self payForSucceed:@"微信支付"];

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



- (IBAction)choosePayKind:(UIButton *)sender {
    if (sender.tag == 0) {
        
//        选择微信支付
        self.selectWechatImageView.image = [UIImage imageNamed:@"pay_selected"];
        self.selectAlipayImageView.image = [UIImage imageNamed:@"pay_selected_no"];
        _payType = @"wechat";
    }
    else
    {
//        选择支付宝支付
        self.selectWechatImageView.image = [UIImage imageNamed:@"pay_selected_no"];
        self.selectAlipayImageView.image = [UIImage imageNamed:@"pay_selected"];
        _payType = @"alipay";
    }
}

- (IBAction)surePay:(UIButton *)sender {
    if ([_payMoneyL.text isEqualToString:@""]) {
        ALERT_VIEW(@"订单获取失败");
        _alert = nil;
        return;
    }
    
    [self pinlessOrderAndConpon];
    
}

#pragma mark -- 订单与可选优惠券绑定，保存支付请求信息（确认支付）
- (void)pinlessOrderAndConpon
{
    NSString *payType = [_payType isEqualToString:@"wechat"]?@"01":@"00";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    NSString *dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"口袋停加油卡支付\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",self.temModel.orderId,_actulOrderPay];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.temModel.orderId,@"orderId",@"15",@"orderType",payType,@"payType",dateString,@"timestamp",dataStr,@"useInfo",@"2.0.4",@"version",nil];
    
    
    [RequestModel pinlessOrderAndConponWithDic:dic Completion:^(NSDictionary *dic) {
//        MyLog(@"%@",str);
        if ([dic[@"errorNum"] isEqualToString:@"3"]) {
            _aletView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"优惠券不可用，是否继续支付?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            _aletView.tag = 3;
            
            [_aletView show];
            return ;
            
        }
        
        else if ([dic[@"errorNum"] isEqualToString:@"0"]) {
            if ([_payType isEqualToString:@"wechat"]) {
                MyLog(@"微信支付");
                [self payOrderWithWeiXin];
            }else if ([_payType isEqualToString:@"alipay"]){
                MyLog(@"支付宝支付");
                [self payOrderWithZhiFuBao];
            }
        }else {
            ALERT_VIEW(dic[@"errorInfo"]);
            
            _alert = nil;
        }
        
        
    } Fail:^(NSString *error) {
        
        ALERT_VIEW(error);
        
        _alert = nil;
        
    }];
    
    
    MyLog(@"%@",dic);
    
}
#pragma mark -------------订单详情内容需要改
#pragma mark -- 微信支付

- (void)payOrderWithWeiXin
{
    
    _payModel.orderDescribute = @"口袋停加油卡支付";
    _payModel.orderName = @"口袋停加油卡支付";
    _payModel.orderID = self.temModel.orderId;
    _payModel.orderPrice = self.myMoney;
    MyLog(@"%@%@",_payModel.orderID,_payModel.orderPrice);
    _payModel.WeChatUrl = [NSString stringWithFormat:@"http://%@/share/payment/wechat/backpay_15",SERVER_ID];
    
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
- (void)payForFailure:(NSString *)str{
    
}
- (void)payForSucceed:(NSString *)str{
  
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.temModel.orderId,@"15",MD5_SECRETKEY] MD5];
    MyLog(@"%@%@",self.temModel.orderId,self.temModel.orderType);
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",PAID,self.temModel.orderId,@"15",summary];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                MyLog(@"success");
                
                [self changeBtnType];
            }else{
                
                MyLog(@"fail");
                
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

    OilCardOrderList *list = [[OilCardOrderList alloc]init];
    list.push = @"2";
    [self.navigationController pushViewController:list animated:YES];
    
}

#pragma mark -- 支付宝支付
- (void)payOrderWithZhiFuBao
{
    _payModel.orderDescribute = @"口袋停优惠停车支付";
    
    _payModel.orderName = @"口袋停优惠停车支付";
    
    
    _payModel.orderID = self.temModel.orderId;
    _payModel.orderPrice = self.myMoney;
    _payModel.AlipayUrl = [NSString stringWithFormat:@"http://%@/share/payment/alipay/backpay_15",SERVER_ID];
    
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
            [self payForSucceed:@"支付宝支付"];
            
        }
        
    } Fail:^(BOOL fail) {
        
        //        1:支付失败：告诉服务器  让订单与优惠券进行解绑
        [self payForFailure:@"支付宝支付"];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
