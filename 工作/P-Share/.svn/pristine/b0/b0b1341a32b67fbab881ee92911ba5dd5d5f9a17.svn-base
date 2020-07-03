//
//  PursePayForVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/19.
//  Copyright © 2016年 fay. All rights reserved.
//
#define orderType   @"16"
#import "PursePayForVC.h"
#import "TurePayView.h"
#import "PayEngine.h"
@interface PursePayForVC ()
{
    UITextField *_purseTextField;
    UIView *_lineView;
    UILabel *_payLable;
     UIView *_lineView1;
    UIView *_weChatView;
    UIView *_zhifbView;
    UIImageView *_selectImageV;
    UIButton *_tureBtn;
    
    NSInteger _selectMoney;
    NSInteger _importMoney;
    NSString *_payType;
    
    OrderModel *_orderModel;
}
@end

@implementation PursePayForVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包充值";
    self.view.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [self createUI];
}
- (void)createUI{
    _purseTextField = [[UITextField alloc] init];
    _purseTextField.borderStyle = UITextBorderStyleLine;
    _purseTextField.placeholder = @"请输入充值金额";
    _purseTextField.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    _purseTextField.layer.borderWidth = 1;
    [self.view addSubview:_purseTextField];
    
    CGFloat width = (SCREEN_WIDTH - 28 - 40)/3;
    _payType = @"01";
    _selectMoney = 100;
    NSArray *array = @[@"100元",@"200元",@"500元"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(14+(width+20)*i, 94, width, 32);
        button.tag = 10+i;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (i == 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
            button.layer.borderWidth = 1;
        }
        [self.view addSubview:button];
    }
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.view addSubview:_lineView];
    
    _payLable = [[UILabel alloc]init];
    _payLable.textColor = [UIColor colorWithHexString:@"696969"];
    _payLable.text = @"支付方式";
    _payLable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_payLable];
    
    _lineView1 = [[UIView alloc]init];
    _lineView1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.view addSubview:_lineView1];
    
    _weChatView = [self createView:@"微信支付"];
    [self.view addSubview:_weChatView];
    _zhifbView = [self createView:@"支付宝支付"];
    [self.view addSubview:_zhifbView];
    
    _tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tureBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [_tureBtn setTitle:@"确 认 支 付" forState:UIControlStateNormal];
    [_tureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _tureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_tureBtn addTarget:self action:@selector(onTureBtn) forControlEvents:(UIControlEventTouchUpInside)];
    _tureBtn.layer.cornerRadius = 4;
    _tureBtn.clipsToBounds = YES;
    [self.view addSubview:_tureBtn];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(142);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(1);
    }];
    [_purseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(36);
        make.height.mas_equalTo(32);
    }];
    [_payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(18);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_payLable.mas_bottom).offset(4);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [_weChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView1.mas_bottom).offset(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [_zhifbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_weChatView.mas_bottom).offset(0);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [_tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(_zhifbView.mas_bottom).offset(20);
        make.height.mas_equalTo(38);
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayResult:) name:WECHAT_PAY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPayResult:) name:ALIPAY_PAY_NOTIFICATION object:nil];
    
}
- (void)alipayPayResult:(NSNotification *)notifi
{
    if ([notifi.object isEqualToString:@"success"]) {
        //        支付宝支付成功
        [self payForSccend];
    }else
    {
        //        支付宝支付失败
    }
}
#pragma  mark -- 监听微信支付结果
- (void)wechatPayResult:(NSNotification *)notifi
{
    if ([notifi.object isEqualToString:@"success"]) {
        //        微信支付成功
        [self payForSccend];
    }else
    {
        //        微信支付失败
    }
}
#pragma mark -- 充值成功后调用
#pragma mark - 支付成功修改订单状态
- (void)payForSccend{
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_orderModel.orderId,orderType,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(PAID),_orderModel.orderId,orderType,summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
            {
              NSDictionary *dict = responseObject;
                
                if ([dict[@"errorNum"] isEqualToString:@"0"]||[dict[@"errorNum"] isEqualToString:@"1"])
                   {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    if (![[user objectForKey:@"pay_password"] isEqualToString:@"1"]) {
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
                        
                    }
                }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
//    [model getRequestUse:(self) WithURL:url WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dict = responseObject;
//            
//            if ([dict[@"errorNum"] isEqualToString:@"0"]||[dict[@"errorNum"] isEqualToString:@"1"])
//            {
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                if (![[user objectForKey:pay_password] isEqualToString:@"1"]) {
//                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为保护账号的安全，请您先设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alertV.tag = 2;
//                    [alertV show];
//                    
//                }else
//                {
//                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"充值成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    alertV.tag = 3;
//                    [alertV show];
//                }
//                
//                //                 刷新钱包界面数据
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWalletMoney" object:nil];
//                
//                [self changeBtnType];
//                
//            }else{
//                NSLog(@"fail");
//                
//            }
//            MyLog(@"支付调用---不需要查看返回----%@",dict);
//        }
//        
//    } error:^(NSString *error) {
//        ALERT_VIEW(error);
//        _alert = nil;
//    } failure:^(NSString *fail) {
//        ALERT_VIEW(fail);
//        _alert = nil;
//    }];
}

- (void)changeBtnType
{
    [_tureBtn setTitle:@"充值成功" forState:(UIControlStateNormal)];
    _tureBtn.backgroundColor = [UIColor grayColor];
    _tureBtn.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    
}
- (void)onClickBtn:(UIButton *)btn{
    NSArray *moneyArray = @[@100,@200,@500];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [self.view viewWithTag:10+i];
        if ((i+10) == btn.tag) {
            _selectMoney = [moneyArray[button.tag-10] integerValue];
           [button setBackgroundImage:[UIImage imageNamed:@"parkingPay"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
            button.layer.borderWidth = 1;
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"parkingPay1"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor clearColor].CGColor;
            button.layer.borderWidth = 1;
        }
    }
}
- (UIView *)createView:(NSString *)imageName{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]init];
    lable.text = imageName;
    lable.textColor = [UIColor colorWithHexString:@"333333"];
    lable.font = [UIFont systemFontOfSize:15];
    [view  addSubview:lable];
   
    UIImageView *logoImageView = [[UIImageView alloc]init];
    if ([imageName isEqualToString:@"微信支付"]) {
        logoImageView.image = [UIImage imageNamed:@"wechatpay"];
    }else{
        logoImageView.image = [UIImage imageNamed:@"alipay"];
    }
    [view addSubview:logoImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([imageName isEqualToString:@"微信支付"]) {
        button.tag = 1;
    }else{
        button.tag = 2;
    }
    [button addTarget:self action:@selector(onselectBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [view addSubview:lineView];
    
    _selectImageV = [[UIImageView alloc] init];
    if ([imageName isEqualToString:@"微信支付"]) {
        _selectImageV.image = [UIImage imageNamed:@"selected"];
        _selectImageV.tag = 3;
    }else{
        _selectImageV.image = [UIImage imageNamed:@"unselect"];
        _selectImageV.tag = 4;
    }
    [view addSubview:_selectImageV];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
        make.left.mas_equalTo(logoImageView.mas_right).offset(4);
        
    }];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    [_selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.right.mas_equalTo(-14);
        make.width.height.mas_equalTo(16);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(0);
    }];
    return view;
}
- (void)onselectBtn:(UIButton *)selectBtn{
     UIImageView *imageView = [self.view viewWithTag:3];
    UIImageView *imageView1 = [self.view viewWithTag:4];
    if (selectBtn.tag == 1) {
       
        imageView.image = [UIImage imageNamed:@"selected"];
         imageView1.image = [UIImage imageNamed:@"unselect"];
        _payType = @"01";
        
        
    }else{
      
        imageView1.image = [UIImage imageNamed:@"selected"];
        imageView.image = [UIImage imageNamed:@"unselect"];
         _payType = @"00";
    }
}
- (void)onTureBtn{
    if ([UtilTool isBlankString:_purseTextField.text] == NO&&[_purseTextField.text integerValue]!=0) {
        _importMoney = [_purseTextField.text integerValue];
    }else{
        _importMoney = _selectMoney;
    }
    [_purseTextField resignFirstResponder];
    
    NSString *summery = [[NSString stringWithFormat:@"%ld%@",(long)_importMoney,SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%ld/%@",APP_URL(calcGiftAmount),(long)_importMoney,summery];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        TurePayView *payView = [[TurePayView alloc]init];
        [payView setValueMoney:_importMoney money:responseObject[@"totalAmount"] addTarget:self action:@selector(onClick:)];
        [self.view addSubview:payView];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}
- (void)onClick:(UIButton *)button{
    
      NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",orderType,@"orderType",@"",@"useInfo",[NSString stringWithFormat:@"%ld",(long)_importMoney],@"amountPayable",_payType,@"payType",@"2.0.4",@"version",nil];
        [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(orderc) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            _orderModel =[OrderModel shareObjectWithDic:responseObject[@"order"]];
            if ([_payType isEqualToString:@"01"]) {
                MyLog(@"微信支付");
                [self payOrder:_payType];
            }else if ([_payType isEqualToString:@"00"]){
                MyLog(@"支付宝支付");
                [self payOrder:_payType];
            }
        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
   }
- (void)payOrder:(NSString *)payType{
    if ([payType isEqualToString:@"00"]) {
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.orderId,ORDER_ID,_orderModel.amountPaid,ORDER_PRICE,@"口袋停钱包充值",ORDER_NAME,@(16),ORDER_TYPE, nil];

        [PayEngine payOrderWithType:PayEngineTypeAlipay WithDic:dic];
    }else if ([payType isEqualToString:@"01"]){
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_orderModel.orderId,ORDER_ID,_orderModel.amountPaid,ORDER_PRICE,@"口袋停钱包充值",ORDER_NAME,@(16),ORDER_TYPE, nil];
        
        [PayEngine payOrderWithType:PayEngineTypeWechat WithDic:dic];
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

@end
