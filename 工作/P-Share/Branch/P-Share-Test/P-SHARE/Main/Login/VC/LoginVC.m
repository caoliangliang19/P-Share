//
//  LoginVC.m
//  P-SHARE
//
//  Created by fay on 16/9/1.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "LoginVC.h"
#import "WXApi.h"
#import "PhoneView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WechatTool.h"
#import "QQTool.h"


@interface LoginVC ()
{
    NSInteger       _getCodeCount;
    
    QQTool          *_qqTool;
    
    dispatch_source_t _timer;

    
    
}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *miMaT;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *QQView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QQViewCenterYLayout;
@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QQViewRightLayout;
@property (nonatomic,strong) GroupManage     *manage;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _getCodeCount = 60;
    _manage = [GroupManage shareGroupManages];
    //微信登录回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginCallBack:) name:WECHAT_LOGIN_NOTIFICATION object:nil];

    [self setUI];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        dispatch_cancel(_timer);
    }

}
- (void)setUI
{
    
    if (![WXApi isWXAppInstalled]) {
        _wechatView.hidden = YES;
        _QQViewCenterYLayout.priority = 1000;
        _QQViewRightLayout.priority = 750;
    }else{
        _wechatView.hidden = NO;
        _QQViewCenterYLayout.priority = 750;
        _QQViewRightLayout.priority = 1000;
    }
    
    UITapGestureRecognizer *wechatTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatLogin)];
    _wechatView.userInteractionEnabled = YES;
    [_wechatView addGestureRecognizer:wechatTapGes];
    UITapGestureRecognizer *QQTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQLogin)];
    _QQView.userInteractionEnabled = YES;
    [_QQView addGestureRecognizer:QQTapGes];
    self.title = @"快速登录";
    [self.mainView clipsToRadius:6.0f];
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.layer.borderColor = KLINE_COLOR.CGColor;
    [self.loginBtn clipsToRadius:4.0f];
    [_getSecurityCodeBtn clipsToRadius:4.0f];
    _getSecurityCodeBtn.layer.borderWidth = 1.0f;
    [self setGetCodeBtnColor:YES];
}
- (void)setGetCodeBtnColor:(BOOL)isGreen
{
    if (isGreen) {
        [_getSecurityCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        _getSecurityCodeBtn.userInteractionEnabled = YES;
        [_getSecurityCodeBtn setTitleColor:KMAIN_COLOR forState:(UIControlStateNormal)];
        _getSecurityCodeBtn.layer.borderColor = KMAIN_COLOR.CGColor;
    }else
    {
        _getSecurityCodeBtn.userInteractionEnabled = NO;
        [_getSecurityCodeBtn setTitleColor: [UIColor colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];
        _getSecurityCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
    }
    
}


#pragma mark --- 微信登录
- (void)wechatLogin{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"7200";
    [WXApi sendReq:req];
}
#pragma mark --- QQ登录
- (void)QQLogin{
    if (!_qqTool) {
        _qqTool = [QQTool new];
    }
    WS(ws)
    _qqTool.QQToolLoginCallBack = ^(NSDictionary *dic)
    {
        [ws requestUrlWith:dic];
    };
    
    [_qqTool QQLogin];
}

- (IBAction)getSecurityCode:(id)sender {
    
    BOOL result = [UtilTool isValidateTelNumber:self.phoneT.text];
    if (result) {
        MyLog(@"正确手机号");
        NSString *summary = [[NSString stringWithFormat:@"%@%@",self.phoneT.text,SECRET_KEY] MD5];
        
        NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(sendSmsCode),self.phoneT.text,summary];
        MyLog(@"%@",URL);

        
        [NetWorkEngine getRequestUse:(self) WithURL:URL WithDic:nil needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            MyLog(@"%@",responseObject);
            [self setGetCodeBtnColor:NO];
            
            NSTimeInterval period = 1.0; //设置时间间隔
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                
                BOOL result = [self refreashCountdown];
                //在这里执行事件
                if (result) {
                    dispatch_cancel(_timer);
                }
            });
            
            dispatch_resume(_timer);

            
            
        } error:^(NSString *error) {
            MyLog(@"%@",error);
            
        } failure:^(NSString *fail) {
            MyLog(@"%@",fail);
            
        }];


    }else
    {
        MyLog(@"请输入正确手机号");
    }
    
}

/**
 *  刷新倒计时
 *
 *  @return 是否停止刷新
 */
- (BOOL)refreashCountdown
{
    MyLog(@"%ld",_getCodeCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        _getSecurityCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount];
        [_getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount] forState:UIControlStateNormal];
        
    });
    if (_getCodeCount == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setGetCodeBtnColor:YES];
        });
        _getCodeCount = 60;
        return YES;
    }
    
    _getCodeCount--;
    return NO;
    
   
}

- (IBAction)login:(id)sender {
    MyLog(@"点击登录");
    
    if ([UtilTool isValidateTelNumber:_phoneT.text]) {
        if ([UtilTool isValidateSecurityCode:_miMaT.text]) {
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneT.text,@"mobile",_miMaT.text,@"code",@"2.0.1",@"version",@"iOS",@"regPhone",@"iOS",@"lastLoginSys",[UtilTool getAppVersion],@"appVersion",[UtilTool getPhoneType],@"lastLoginMachine", nil];
            
            [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(loginByVerifyCode) WithDic:paramDic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                
                dispatch_cancel(_timer);

                [self saveUserInfomationWithDic:responseObject[@"customer"]];
                
                
                MyLog(@"%@",responseObject);
                
            } error:^(NSString *error) {
                MyLog(@"%@",error);


            } failure:^(NSString *fail) {
                MyLog(@"%@",fail);

            }];
            
            
        }else
        {
            [_manage groupAlertShowWithTitle:@"请输入正确验证码"];
            
            MyLog(@"请输入正确验证码");
        }
        
    }else
    {
        [_manage groupAlertShowWithTitle:@"请正确输入手机号"];

        MyLog(@"请正确输入手机号");
    }
    

}

#pragma mark -- 保存用户信息
- (void)saveUserInfomationWithDic:(NSDictionary *)dic
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic[@"customerId"] forKey:KCUSTOMER_ID];
    [userDefault setObject:dic[@"customerMobile"] forKey:KCUSTOMER_MOBILE];
    [userDefault setObject:dic[@"customerHead"] forKey:KHEADIMG_URL];
    [userDefault setObject:dic[@"customerNickname"] forKey:KCUSTOMER_NICKNAME];
    [userDefault setObject:dic[@"customerSex"] forKey:@"customerSex"];
    [userDefault setObject:dic[@"customerEmail"] forKey:@"customerEmail"];
    [userDefault setObject:dic[@"customerRegion"] forKey:@"customerRegion"];
    [userDefault setObject:dic[@"customerJob"] forKey:@"customerJob"];
    [userDefault setObject:dic[@"customerCardId"] forKey:@"customerCardId"];
    [userDefault setObject:dic[@"payPassword"] forKey:@"pay_password"];


    User *user = [User shareObjectWithDic:dic];
    WZLSERIALIZE_ARCHIVE(user, @"user", [UtilTool createFilePathWith:@"user"]);
    _manage.user = user;
    [userDefault synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];

    
    self.tabBarController.selectedIndex = 0;
    [self.rt_navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)showProtocol:(id)sender {
    MyLog(@"查看口袋停协议");
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement.txt" ofType:nil];
    WebInfoModel *webModel      = [WebInfoModel new];
    webModel.urlType            = URLTypeNetLocalData;
    webModel.shareType          = WebInfoModelTypeNoShare;
    webModel.title              = @"口袋停协议";
    webModel.url                = filePath;
    webModel.imagePath          = @"";
    webModel.descibute          = @"";
    WebViewController *webView  = [[WebViewController alloc] init];
    webView.webModel            = webModel;
    [self.rt_navigationController pushViewController:webView animated:YES];

}


#pragma mark -- 微信登录回调
- (void)wechatLoginCallBack:(NSNotification *)notification
{
    WechatTool *wechatTool  = [WechatTool new];
    [wechatTool getAccess_token:notification.userInfo[@"code"]];
    WS(ws)
    wechatTool.WechatToolSuccessBlock = ^(NSDictionary *dic){
        ws.manage.loginType = @"01";
        ws.manage.openid = dic[@"openid"];
        ws.manage.nickname = dic[@"nickname"];
        ws.manage.headimgurl = dic[@"headimgurl"];
        [ws requestUrlWith:dic];
    };
    wechatTool.WechatToolFailBlock = ^(NSString *error){
        
    };
    
    
}
/**
 *  type:01 微信 02微博 04 QQ
 */
- (void)requestUrlWith:(NSDictionary *)openDic{
    //    type:01 微信 02微博 04 QQ
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_manage.openid,@"quickId",_manage.loginType,@"quickType",@"2.0.1",@"version",@"iOS",@"lastLoginSys",app_Version,@"appVersion",[UtilTool getPhoneType],@"lastLoginMachine", nil];
    
    WS(ws)
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(loginByOtherV2) WithDic:dict needEncryption:YES needAlert:NO showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        MyLog(@"%@",responseObject);
        [self saveUserInfomationWithDic:responseObject[@"customer"]];
        
    } error:^(NSString *error) {
        
//        第三方用户没有绑定手机号 提示绑定手机号
        PhoneView *phoneV = [[PhoneView alloc] init];
        phoneV.userNickName = openDic[@"nickname"];
        [self.view addSubview:phoneV];
        [phoneV show];
        
        phoneV.nextBlock = ^(NSDictionary *dataDic){
            [ws bindingPhoneNum:dataDic];
        };
        
        
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
}

#pragma  mark -- 第三方帐号与手机号绑定
- (void)bindingPhoneNum:(NSDictionary *)dataDic
{
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(bondByOtherV2) WithDic:dataDic needEncryption:YES needAlert:YES showHud:YES  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        MyLog(@"%@",responseObject);
        
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:responseObject[@"customer"][@"customerId"] forKey:KCUSTOMER_ID];
        [userDefault synchronize];
        
        [self saveThirdPartInfomation];
        
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        
    }];
    
}
#pragma mark -- 保存第三方用户昵称和头像
- (void)saveThirdPartInfomation
{
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.4",@"version",_manage.nickname,@"customerNickname",_manage.headimgurl,@"customerHead", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(updateCustomerInfo) WithDic:dict needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self saveUserInfomationWithDic:responseObject[@"data"]];
        
        MyLog(@"%@",responseObject);
        
    } error:^(NSString *error) {
        MyLog(@"%@",error);

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

    }];
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
