//
//  PayCenterViewController.m
//  P-SHARE
//
//  Created by fay on 16/9/2.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PayCenterViewController.h"
#import "PasswordView.h"
#import "PayEngine.h"
#import "CouponModel.h"
#import "TradeDetailVC.h"
#import "ChooseFreeCouponVC.h"
#import "YuYueRequest.h"
#import "PassWordIsController.h"
@interface PayCenterViewController ()<ChooseFreeDelegate>
{

    NSString            *_price;//用来记录月租产权单价
    NSArray             *_titleArray;
    GroupManage         *_manage;
    IQKeyboardManager   *_keyboardManager;
    NSString            *_originAmountPayable;
    NSString            *_originAmountPaid;
    NSString            *_originAmountDiscount;

}
@property (nonatomic,strong)CouponModel *couponModel;
@property (weak, nonatomic) IBOutlet UILabel *yinFuPriceL;
@property (weak, nonatomic) IBOutlet UILabel *zheKouPriceL;
@property (weak, nonatomic) IBOutlet UILabel *shiFuPriceL;
@property (weak, nonatomic) IBOutlet UIImageView *walletRightImgeV;
@property (weak, nonatomic) IBOutlet UIImageView *wechatRightImageV;
@property (weak, nonatomic) IBOutlet UIImageView *alipayRightImageV;
@property (nonatomic,strong)NSDictionary    *titleDic;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *descributeL;

/**
 *  支付方式
 */
@property (nonatomic,assign)PayCenterViewControllerPayKind      payCenterPayKind;

@end
NSString    *const      KTitile     = @"title";
NSString    *const      KDescribute = @"describute";
NSString    *const      KOrderType  = @"orderType";
NSString    *const      KOrderName  = @"orderName";


@implementation PayCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _payButton.layer.cornerRadius = 4;
    _payButton.layer.masksToBounds = YES;
    _manage = [GroupManage shareGroupManages];

    [self loadBaseData];

    if (_hasOrder) {
        [self getOrder:_order];
    }
    //如果从订单中心进入可以调用loadOrder 下面做了判断
    [self loadOrder];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8ff"];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _keyboardManager.enable = NO;
    _keyboardManager.shouldResignOnTouchOutside = NO;
    _keyboardManager.enableAutoToolbar = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayResult:) name:WECHAT_PAY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPayResult:) name:ALIPAY_PAY_NOTIFICATION object:nil];

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _keyboardManager.enable = YES;
    _keyboardManager.shouldResignOnTouchOutside = YES;
    _keyboardManager.enableAutoToolbar = YES;
    
}
- (void)setTitleDic:(NSDictionary *)titleDic
{
    _titleDic = titleDic;
    self.title = titleDic[KTitile];
    self.descributeL.text = titleDic[KDescribute];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 选择优惠券
- (IBAction)ChooseCoupon:(id)sender {
    ChooseFreeCouponVC *chooseCtrl = [[ChooseFreeCouponVC alloc] init];
    chooseCtrl.delegate = self;
    chooseCtrl.orderType = _titleDic[KOrderType];
    chooseCtrl.orderTotalPay =  [_manage.order.amountPayable intValue];
    [self.rt_navigationController pushViewController:chooseCtrl animated:YES];
}
- (CouponModel *)couponModel{
    if (!_couponModel) {
        _couponModel = [CouponModel new];
    }
    return _couponModel;
}
#pragma mark -- ChooseFreeDelegate
#pragma mark --使用优惠券时发送网络请求
- (void)selectedFreeWithModel:(CouponModel *)model
{
    self.couponModel = model;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model.couponId,@"couponId",[UtilTool getCustomId],@"customerId", _order.orderId,@"orderId",[UtilTool getTimeStamp],@"timestamp",nil];
    
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(useCoupon) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        _order.amountDiscount = responseObject[@"payInfo"][@"amountDiscount"];
        _order.amountPaid = responseObject[@"payInfo"][@"amountPaid"];
        _order.amountPayable = responseObject[@"payInfo"][@"amountPayable"];
        [self loadPriceShow];
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
        
}

#pragma mark -- 选择支付方式 0:钱包 1:微信 2:支付宝
- (IBAction)choosePayType:(id)sender {
    UIButton *temButton = (UIButton *)sender;
    self.payCenterPayKind = (NSInteger)temButton.tag;
    
}

#pragma mark -- 创建订单
- (void)createOrderWithURL:(NSString *)url dictionry:(NSDictionary *)dataDic
{
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(url) WithDic:dataDic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        OrderModel *order = [OrderModel shareObjectWithDic:responseObject[@"order"]];
        [self getOrder:order];
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        _payButton.userInteractionEnabled = NO;
        [_payButton setBackgroundColor:[UIColor grayColor]];

        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        _payButton.userInteractionEnabled = NO;
        [_payButton setBackgroundColor:[UIColor grayColor]];

    }];
    
}
- (void)getOrder:(OrderModel *)order
{
    _order = order;
    _manage.order = order;
    [self loadPriceShow];
}
- (void)loadPriceShow
{
    if (([_order.orderType integerValue] == 13|| [_order.orderType integerValue] == 14)&&_hasOrder == YES) {
        CGFloat  price = [self.order.amountPayable integerValue]/[self.order.monthNum integerValue];
        _price = [NSString stringWithFormat:@"%lf",price];
        _yinFuPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountPayable];
        _zheKouPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountDiscount];
        _shiFuPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountPaid];


    }else{
    _yinFuPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountPayable];
    _zheKouPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountDiscount];
    _shiFuPriceL.text = [NSString stringWithFormat:@"%@",_manage.order.amountPaid];
        
    }
    if (![UtilTool isBlankString:_order.couponId] && [UtilTool isBlankString:self.couponModel.couponId]) {
        self.couponModel.couponId = _order.couponId;
    }
    _originAmountPaid = _order.amountPaid;
    _originAmountDiscount = _order.amountDiscount;
    _originAmountPayable = _order.amountPayable;
}


- (void)setPayCenterPayKind:(PayCenterViewControllerPayKind)payCenterPayKind
{
    _payCenterPayKind = payCenterPayKind;
    switch (payCenterPayKind) {
        case PayCenterViewControllerPayKindWallet:
        {
            _walletRightImgeV.image = [UIImage imageNamed:@"selected"];
            _wechatRightImageV.image = [UIImage imageNamed:@"unselect"];
            _alipayRightImageV.image = [UIImage imageNamed:@"unselect"];
            
        }
            break;
        case PayCenterViewControllerPayKindWechat:
        {
            _walletRightImgeV.image = [UIImage imageNamed:@"unselect"];
            _wechatRightImageV.image = [UIImage imageNamed:@"selected"];
            _alipayRightImageV.image = [UIImage imageNamed:@"unselect"];
        }
            break;
        case PayCenterViewControllerPayKindAlipay:
        {
            _walletRightImgeV.image = [UIImage imageNamed:@"unselect"];
            _wechatRightImageV.image = [UIImage imageNamed:@"unselect"];
            _alipayRightImageV.image = [UIImage imageNamed:@"selected"];
        }
            break;
            
        default:
            break;
    }

    
}
- (IBAction)payButtonClick:(id)sender {
    
    MyLog(@"%ld",self.payCenterPayKind);
    
    if (_order == nil) {
        [_manage groupAlertShowWithTitle:@"订单获取失败"];
        return;
    }
    
    if (self.payCenterPayKind == PayCenterViewControllerPayKindWechat ||self.payCenterPayKind == PayCenterViewControllerPayKindAlipay) {
        if ([_order.amountPaid integerValue] == 0) {
            [_manage groupAlertShowWithTitle:@"订单获取失败"];
            return;
        }
    }
    
    switch (_orderKind) {
        case PayCenterViewControllerOrferTypeYuYue:
       
        case PayCenterViewControllerOrferTypeDaiBo:
            
        case PayCenterViewControllerOrferTypeLinTing:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [self recheckPayOrderWithDic:dic];
            
        }
            break;
            
        case PayCenterViewControllerOrferTypeYueZu:
            
        case PayCenterViewControllerOrferTypeChanQuan:
        {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys: _price,@"price",nil];
            [self recheckPayOrderWithDic:dic];

        }
            break;

            
        default:
            break;
    }
    
    
}
#pragma mark -- 调用repay检测优惠券是否可用
//支付方式 01:微信 00:支付宝 05:钱包
- (void)recheckPayOrderWithDic:(NSDictionary *)dic
{
    NSString *dataStr = nil;
    if ([_order.orderType integerValue] == 13 || [_order.orderType integerValue] == 14) {
          dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"%@\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",self.titleDic[KOrderName],_order.orderId,_price];
    }else{
        dataStr = [NSString stringWithFormat:@"{\"info\":{\"orderDescribute\":\"口袋停缴费\",\"orderName\":\"%@\",\"orderID\":\"%@\",\"orderPrice\":\"%@\"}}",self.titleDic[KOrderName],_order.orderId,_order.amountPaid];
    }
    
    NSString *payType = self.payCenterPayKind == PayCenterViewControllerPayKindWallet ? @"05" : self.payCenterPayKind == PayCenterViewControllerPayKindWechat ? @"01" : @"00";
    
    [dic setValue:self.couponModel.couponId     forKey:@"couponId"];
    [dic setValue:dataStr                   forKey:@"useInfo"];
    [dic setValue:_order.orderId            forKey:@"orderId"];
    [dic setValue:self.titleDic[KOrderType] forKey:@"orderType"];
    [dic setValue:payType                   forKey:@"payType"];
    [dic setValue:[UtilTool getTimeStamp]   forKey:@"timestamp"];
    [dic setValue:@"2.0.4"                  forKey:@"version"];

    [NetWorkEngine postRequestUse:(self) AddErrorObjectWithURL:APP_URL(reqpay) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self payOrder];
        
    } error:^(id responseObject) {
        if ([responseObject[@"errorNum"] isEqualToString:@"3"]) {
            
            _order.amountPaid = _originAmountPaid;
            _order.amountDiscount = _originAmountDiscount;
            _order.amountPayable = _originAmountPayable;
            _couponModel = nil;
            [self loadPriceShow];
            
            [UtilTool creatAlertController:self title:@"提示" describute:@"优惠券不可用，是否继续支付?" sureClick:^{
                
                [self payOrder];
                
            } cancelClick:^{
                //  如果不支付  调用 payFail

                [self payFail];

            }];
        }else
        {
            [_manage groupAlertShowWithTitle:responseObject[@"errorInfo"]];
        }
        
    } failure:^(NSString *fail) {
        
    }];
     
}

#pragma mark -- 支付订单
- (void)payOrder
{
    switch (self.payCenterPayKind) {
        case PayCenterViewControllerPayKindWallet:
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if ([[user objectForKey:@"pay_password"] integerValue] == 0) {
                [UtilTool creatAlertController:self title:@"提示" describute:@"为保护账号的安全，请您先设置交易密码" sureClick:^{
                    PassWordIsController *passWord = [[PassWordIsController alloc]init];
                    [self.rt_navigationController pushViewController:passWord animated:YES complete:nil];
                } cancelClick:^{
                    
                }];
               
            }else{
            PasswordView *passwordView = [PasswordView createPasswordViewWithPrice:_order.amountPaid];
            passwordView.cancelWalletPay = ^(PasswordView *walletView){
                [self payFail];
                
            };
            passwordView.passwordViewBlock = ^(PasswordView *passwordView,NSString *password){
                MyLog(@"%@",password);
                [self walletPayWith:passwordView password:password];
            };
                [passwordView passwordViewShow];
            }
        }
            break;
            
        case PayCenterViewControllerPayKindWechat:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_manage.order.orderId,ORDER_ID,_manage.order.amountPaid,ORDER_PRICE,_titleDic[KOrderName],ORDER_NAME,@(_orderKind),ORDER_TYPE, nil];
            
            [PayEngine payOrderWithType:PayEngineTypeWechat WithDic:dic];
            
        }
            break;
            
            
        case PayCenterViewControllerPayKindAlipay:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_manage.order.orderId,ORDER_ID,_manage.order.amountPaid,ORDER_PRICE,_titleDic[KOrderName],ORDER_NAME,@(_orderKind),ORDER_TYPE,ORDER_DESCRIBUTE,_titleDic[KOrderName], nil];
            [PayEngine payOrderWithType:PayEngineTypeAlipay WithDic:dic];
            
        }
            break;
            
            
        default:
            break;
    }
    

}
#pragma mark -- 钱包支付
- (void)walletPayWith:(PasswordView *)password password:(NSString *)passwordNum
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [password passwordViewHidden];
    });
     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_order.orderId,@"orderId",[passwordNum MD5] ,@"payPassword", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(walletPay) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       
        MyLog(@"%@",responseObject);
        [self PaySuccess];
        
    } error:^(NSString *error) {
        [self payFail];
        
    } failure:^(NSString *fail) {
        [self payFail];
    }];
    
}
#pragma mark -- 监听支付宝支付结果
- (void)alipayPayResult:(NSNotification *)notifi
{
    if ([notifi.object isEqualToString:@"success"]) {
        //        支付宝支付成功
        [self PaySuccess];
        
    }else
    {
        //        支付宝支付失败
        [self payFail];
    }
}
#pragma  mark -- 监听微信支付结果
- (void)wechatPayResult:(NSNotification *)notifi
{
    if ([notifi.object isEqualToString:@"success"]) {
        //        微信支付成功
        [self PaySuccess];
        
    }else
    {
        //        微信支付失败
        [self payFail];
    }
}

#pragma mark --PaySuccess
/**
 *  支付成功之后都掉用PaySuccess 在PaySuccess里面区别订单类型 以及调用paySuccessChangeOrderStatusWithDic修改订单状态
 */
- (void)PaySuccess
{
    if (self.orderKind == PayCenterViewControllerOrferTypeYuYue) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_order.orderId,@"orderId",self.titleDic[KOrderType],@"orderType", nil];
        if (![[NSString stringWithFormat:@"%@",_packageId] containsString:@"null"]) {
            [dic setValue:[NSString stringWithFormat:@"%@",_packageId] forKey:@"packageId"];
        }else
        {
            [dic setValue:[NSString stringWithFormat:@"%@",_appointmentDate] forKey:@"appointmentDate"];
        }
        
        [self paySuccessChangeOrderStatusPostWithDic:dic];
    }else if (self.orderKind == PayCenterViewControllerOrferTypeYueZu || self.orderKind == PayCenterViewControllerOrferTypeChanQuan ||self.orderKind == PayCenterViewControllerOrferTypeLinTing)
    {
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.order.orderId,self.order.orderType,SECRET_KEY] MD5];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(paid),self.order.orderId,self.order.orderType,summary];
        [self paySuccessChangeOrderStatusGetWithUrl:url];
    }else if (self.orderKind == PayCenterViewControllerOrferTypeDaiBo){
        NSString *summary = [[NSString stringWithFormat:@"%@%@%@",self.order.orderId,@"12",SECRET_KEY] MD5];
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(paid),self.order.orderId,@"12",summary];
        [self paySuccessChangeOrderStatusGetWithUrl:url];
    }
}
#pragma mark -- 支付成功 修改订单状态 get  通过paid
- (void)paySuccessChangeOrderStatusGetWithUrl:(NSString *)url
{
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.orderKind == PayCenterViewControllerOrferTypeDaiBo) {
            [_payButton setBackgroundColor:[UIColor grayColor]];
            [_payButton setTitle:@"已支付" forState:(UIControlStateNormal)];
            _payButton.userInteractionEnabled = NO;
            _manage.car = _manage.car;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PING_JIA_CHENG_GONG" object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KYCL_PAY_SUCCESS object:nil];
            TradeDetailVC *tradeVC = [[TradeDetailVC alloc] init];
            OrderModel *newOrder ;
            if (self.orderKind == PayCenterViewControllerOrferTypeYueZu || self.orderKind == PayCenterViewControllerOrferTypeChanQuan ||self.orderKind == PayCenterViewControllerOrferTypeLinTing)
            {
                
                if (self.orderKind == PayCenterViewControllerOrferTypeLinTing) {
                    tradeVC.style = TradeStylelinTing;
                    newOrder = [OrderModel shareObjectWithDic:responseObject[@"order"]];
                }else
                {
                    tradeVC.style = TradeStyleYueZu;
                    newOrder = [OrderModel shareObjectWithDic:responseObject[@"data"]];
                }
            }
            _manage.order = newOrder;
            tradeVC.order = newOrder;
            [self.rt_navigationController pushViewController:tradeVC animated:YES complete:^(BOOL finished) {
            }];
        }
        

    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}


#pragma mark -- 支付成功 修改订单状态 post  通过paidOrder
- (void)paySuccessChangeOrderStatusPostWithDic:(NSDictionary *)dic
{
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(paidOrder) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        _payButton.userInteractionEnabled = NO;
        [_payButton setTitle:@"支付成功" forState:(UIControlStateNormal)];
        [_payButton setBackgroundColor:[UIColor grayColor]];
        if (self.orderKind == PayCenterViewControllerOrferTypeYuYue) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KYUYUE_PAY_SUCCESS object:nil];
            TradeDetailVC *tradeVC = [[TradeDetailVC alloc] init];
            if (self.orderKind == PayCenterViewControllerOrferTypeYuYue) {
                tradeVC.style = TradeStyleLinTing;
            }else if (self.orderKind == PayCenterViewControllerOrferTypeYueZu || self.orderKind == PayCenterViewControllerOrferTypeChanQuan)
            {
                tradeVC.style = TradeStyleYueZu;
            }
            OrderModel *newOrder = [OrderModel shareObjectWithDic:responseObject[@"orderMap"]];
            _manage.order = newOrder;
            tradeVC.order = newOrder;
            [self.rt_navigationController pushViewController:tradeVC animated:YES complete:^(BOOL finished) {
            }];
        }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}

#pragma mark -- 支付失败  解绑优惠券
/**
 *  支付失败全都调用payFail 让订单和优惠券解绑
 */
- (void)payFail
{
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",_order.orderId,self.titleDic[KOrderType],SECRET_KEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(cancel),_order.orderId,self.titleDic[KOrderType],summary];
    [NetWorkEngine getRequestUse:(self) WithURL:url WithDic:nil needAlert:NO showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}
#pragma mark -- 请求订单
- (void)loadOrder
{
    NSMutableDictionary *dataDic;
    switch (_orderKind) {
        case PayCenterViewControllerOrferTypeYuYue:
        {
            self.titleDic = _titleArray[0];
            if(!_hasOrder){
                dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",_titleDic[KOrderType],@"orderType",[UtilTool getTimeStamp],@"timestamp",_manage.parking.parkingId,@"parkingId",_manage.car.carNumber,@"carNumber",_appointmentDate,@"appointmentDate",nil];
                if ([_packageId integerValue] > 0) {
                    [dataDic setValue:[NSString stringWithFormat:@"%@",_packageId] forKey:@"packageId"];
                }
                
                [self createOrderWithURL:orderc dictionry:dataDic];
            }
            
        }
            break;
            
        case PayCenterViewControllerOrferTypeLinTing:
        {
            self.titleDic = _titleArray[1];
            if(!_hasOrder){
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",_order.carNumber,@"carNumber",_titleDic[KOrderType],@"orderType",[UtilTool getTimeStamp],@"timestamp",_order.parkingId,@"parkingId",nil];
                [self createOrderWithURL:orderc dictionry:dataDic];
            }
            

        }
            break;
            
        case PayCenterViewControllerOrferTypeDaiBo:
        {
            
            self.titleDic = _titleArray[2];
            if(!_hasOrder){
                [_manage groupHubShow];
                [YuYueRequest reloadDaiBoDataWithParkingModel:_manage.parking completion:^(BOOL hasOrder, OrderModel *order, DaiBoInfoVStatus status,NSString *tenseTime) {
                    if (hasOrder) {
                        self.order = order;
                        [self getOrder:order];
                        [_manage groupHubHidden];
                    }else{
                        [_manage groupAlertShowWithTitle:@"订单异常"];
                        _payButton.userInteractionEnabled = NO;
                        [_payButton setBackgroundColor:[UIColor grayColor]];
                    }
                }];
            }
           
            
        }
            break;
            
        case PayCenterViewControllerOrferTypeYueZu:
        case PayCenterViewControllerOrferTypeChanQuan:
        {
            if (_orderKind == PayCenterViewControllerOrferTypeYueZu) {
                self.titleDic = _titleArray[3];
            }else
            {
                self.titleDic = _titleArray[4];
            }
            if (!_hasOrder) {
                _price = _order.price;
                dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_order.parkingId,@"parkingId",[UtilTool getCustomId],@"customerId",_order.carNumber,@"carNumber",self.titleDic[KOrderType],@"orderType",_order.beginDate,@"beginDate",_order.monthNum,@"monthNum",[UtilTool getTimeStamp],@"timestamp",_order.invoiceId,@"invoiceId",nil];
                
                [self createOrderWithURL:orderc dictionry:dataDic];
            }

            
        }
            break;
            
        default:
            break;
    }
}


- (void)loadBaseData
{
    _titleArray = @[
                    @{
                        KTitile     :   @"优惠停车支付",
                        KOrderType  :   @"10",
                        KOrderName  :   @"口袋停优惠停车支付",
                        KDescribute :   @"    若超出优惠时段,停车场人员会向您收取超出部分费用,请谅解."
                        },
                    @{
                        KTitile     :   @"停车缴费",
                        KOrderType  :   @"11",
                        KOrderName  :   @"口袋停临停支付",
                        KDescribute :   @"    请在完成支付后的15分钟之内离场,超出时间将产生新的费用,谢谢您的使用!"
                        },
                    @{
                        KTitile     :   @"代泊支付",
                        KOrderType  :   @"12",
                        KOrderName  :   @"口袋停代泊支付",
                        KDescribute :   @"    如在取车过程中遇到问题,可以联系您的车管家或拨打400-006-2637,谢谢！"
                        },
                    
                    @{
                        KTitile     :   @"月租支付",
                        KOrderType  :   @"13",
                        KOrderName  :   @"口袋停月租支付",
                        KDescribute :   @"    月租费用缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!"
                        },
                    @{
                        KTitile     :   @"产权支付",
                        KOrderType  :   @"14",
                        KOrderName  :   @"口袋停产权支付",
                        KDescribute :   @"    产权车位费缴纳后,系统到账时间内如遇出入问题,可向收费员出示付款凭证,如有其他问题,可致电400-006-2637,谢谢您的使用!"
                        },
                ];
}
@end



