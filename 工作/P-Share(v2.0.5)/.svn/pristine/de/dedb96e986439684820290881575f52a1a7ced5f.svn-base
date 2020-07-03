//
//  LoginViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ResetPswViewController.h"
#import "WeiXinPhoneController.h"
#import "AgreementViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>

#import "NSString+Encrypt.h"

#import "WXApi.h"


@interface LoginViewController ()<UITextFieldDelegate,TencentSessionDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    BOOL _first;
    
    int _getCodeCount;
    
    NSTimer *_buttonTimer;
    
    TencentOAuth *tencentOAuth;
    
}

@property (nonatomic,copy)NSString *openId;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

- (void)setUI
{
    
    if (![WXApi isWXAppInstalled]) {
        self.weixinView.hidden = YES;
        self.rightLayOut.priority = 750;
        self.centerLayOut.priority = 1000;
        
    }else{
        self.weixinView.hidden = NO;
        self.rightLayOut.priority = 1000;
        self.centerLayOut.priority = 750;
    }
    _getCodeCount = 60;
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39d5b8"].CGColor;
    self.getCodeBtn.layer.cornerRadius = 5;
    self.getCodeBtn.clipsToBounds = YES;
    self.view.backgroundColor = BACKGROUND_COLOR;
    _kuaiJieDengLuView.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.loginBackView.layer.borderWidth = 0.5;
    self.loginBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginBackView.layer.cornerRadius = 4;
    self.loginBackView.layer.masksToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = NEWMAIN_COLOR;
}
//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    return YES;
}
//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
#pragma mark -
#pragma mark - 微信微博通知回调
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //微信登录回调通知
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _first = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (IBAction)loginBtnClick:(id)sender {
    NSString *phoneNum =[NSString stringWithFormat:@"%@",self.phoneNumTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
    
    if (phoneNum.length != 11) {
        ALERT_VIEW(@"请输入正确手机号");
        return;
    }else if (password.length != 4){
        ALERT_VIEW(@"请输入正确验证码");
        return;
    }
    
    BEGIN_MBPROGRESSHUD;
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumTextField.text,@"mobile",password,@"code",@"2.0.1",@"version",@"iOS",@"regPhone", nil];
    
    
    [RequestModel requestGetPhoneNumNewWithURL:loginByVerifyCode WithDic:paramDic Completion:^(NSDictionary *dict) {
        if ([dict[@"errorNum"] isEqualToString:@"0"]) {
            //存储用户信息的字典
            NSDictionary *infoDict = dict[@"customer"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSArray *carNumArrar = [NSArray array];
            [userDefaults setObject:carNumArrar forKey:customer_carNumArray];
            [userDefaults setObject:@"10" forKey:loginType];
            [userDefaults setBool:YES forKey:had_Login];
            [userDefaults setObject:infoDict[@"customerId"] forKey:customer_id];
            [userDefaults setObject:infoDict[@"customerMobile"] forKey:customer_mobile];
            [userDefaults setObject:infoDict[@"customerEmail"] forKey:customer_email];
            [userDefaults setObject:infoDict[@"customerCity"] forKey:customer_region];
            [userDefaults setObject:infoDict[@"customerJob"] forKey:customer_job];
            [userDefaults setObject:infoDict[@"customerNickname"] forKey:customer_nickname];
            [userDefaults setObject:infoDict[@"payPassword"] forKey:pay_password];
            
            [userDefaults setBool:YES forKey:@"visitorBOOL"];
            
            NSNumber *num = infoDict[@"customer_sex"];
            [userDefaults setObject:num forKey:customer_sex];
            [userDefaults setObject:infoDict[@"customer_job"] forKey:customer_job];
            if ([infoDict[@"customer_head"] length] > 5) {
                NSString *imageString = [infoDict[@"customer_head"] substringToIndex:[infoDict[@"customer_head"] length]-1];
                [userDefaults setObject:imageString forKey:customer_head];
            }
            [userDefaults synchronize];
            MyLog(@"%@",infoDict[@"customer_sex"]);
            
            self.tabBarController.selectedIndex = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccess object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
           
        }else{
            
            ALERT_VIEW(dict[@"errorInfo"]);
            _alert = nil;
        }
        END_MBPROGRESSHUD;
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD;
    }];

   
  
    
   
}

- (void)dealloc
{
    _alert = nil;
    
}

- (IBAction)forgetPswBtnClick:(id)sender {
    AgreementViewController *agreeCtrl = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreeCtrl animated:YES];
    
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 
#pragma mark - 微信登录
- (void)tongzhi:(NSNotification *)text{
    
    [self getAccess_token:text.userInfo[@"code"]];
}
- (void)getAccess_token:(NSString *)code{

    BEGIN_MBPROGRESSHUD
//    [self performSelector:@selector(getTimer) withObject:self afterDelay:10];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx7248073ee8171c2b",@"f6167b2ca139d51ba8653d8a7cc28888",code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                END_MBPROGRESSHUD
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [self refreshAcressToken:dic[@"refresh_token"]];
            }else{
                END_MBPROGRESSHUD
            }
        });
    });
}
- (void)refreshAcressToken:(NSString *)string{
   NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx7248073ee8171c2b&grant_type=refresh_token&refresh_token=%@",string];
    BEGIN_MBPROGRESSHUD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                END_MBPROGRESSHUD
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *access_token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                 [self getUserInfo:access_token opedID:openid];
                
            }else{
               END_MBPROGRESSHUD
            }
        });
        
    });
}
- (void)getUserInfo:(NSString *)accessToken opedID:(NSString *)openid{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    BEGIN_MBPROGRESSHUD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                END_MBPROGRESSHUD
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic[@"openid"]) {
                    [self requestUrl:dic];
                     
                }else{
                
                }
            }else{
                END_MBPROGRESSHUD
            }
        });
        
    });
}
- (void)requestUrl:(NSDictionary *)openid{
    BEGIN_MBPROGRESSHUD
    [RequestModel requestWeiXinFirstGoinWithURL:openid[@"openid"] Type:@"01"  Completion:^(NSDictionary *dic) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"01" forKey:loginType];
        [userDefaults setObject:openid[@"openid"] forKey:loginopenId];
        [userDefaults synchronize];
        
        END_MBPROGRESSHUD
       if ([dic[@"errorNum"] isEqualToString:@"0"]) {
           
           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               [userDefaults setObject:dic[@"customer"][@"customerId"] forKey:customer_id];
               [userDefaults setObject:dic[@"customer"][@"customerMobile"] forKey:customer_mobile];
               [userDefaults setObject:dic[@"customer"][@"customerEmail"] forKey:customer_email];
               [userDefaults setObject:dic[@"customer"][@"customerCity"] forKey:customer_region];
               [userDefaults setObject:dic[@"customer"][@"customerJob"] forKey:customer_job];
               [userDefaults setObject:dic[@"customer"][@"customerNickname"] forKey:customer_nickname];
               [userDefaults setObject:dic[@"customer"][@"customerSex"] forKey:customer_sex];
               [userDefaults setObject:dic[@"customer"][@"customerHead"] forKey:customer_head];
               [userDefaults setObject:dic[@"customer"][@"payPassword"] forKey:pay_password];
               [userDefaults setObject:@"01" forKey:loginType];
               [userDefaults setBool:YES forKey:had_Login];
               [userDefaults setInteger:-1 forKey:customer_selectPark];
               [userDefaults setObject:openid[@"nickname"] forKey:customer_nickname];
               [userDefaults setBool:YES forKey:@"visitorBOOL"];
               NSNumber *num = openid[@"sex"];
               [userDefaults setObject:num forKey:customer_sex];
               [userDefaults setObject:openid[@"headimgurl"] forKey:customer_head];
               [userDefaults setObject:openid[@"openid"] forKey:loginopenId];
               [userDefaults synchronize];
           
                self.tabBarController.selectedIndex = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccess object:nil];
           
                [self.navigationController popViewControllerAnimated:YES];
           
           
       }else if([dic[@"errorNum"] isEqualToString:@"1"])
       {
//           __weak typeof(self)ws = self;
           phoneView *phoneV = [[phoneView alloc]init];
           __weak typeof (phoneView *)weakPhoneV = phoneV;
           weakPhoneV.infoL.text = [NSString stringWithFormat:@"%@,为了更好的为您服务,使用本功能前请先绑定手机",openid[@"nickname"]];
           phoneV.nextVC = ^(){
               
               [weakPhoneV hide];

               NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
               [userDefaults setObject:openid[@"nickname"] forKey:customer_nickname];
               [userDefaults setBool:YES forKey:@"visitorBOOL"];
               NSNumber *num = openid[@"sex"];
               [userDefaults setObject:num forKey:customer_sex];
               [userDefaults setObject:openid[@"headimgurl"] forKey:customer_head];
               [userDefaults setObject:openid[@"openid"] forKey:loginopenId];
               [userDefaults synchronize];
//               
              
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                   self.tabBarController.selectedIndex = 0;
                   [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccess object:nil];
                   
                   [self.navigationController popViewControllerAnimated:YES];               });

           };
           [phoneV show];
           
       }
    
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        
        END_MBPROGRESSHUD
    }];
}

#pragma mark -
#pragma mark -- TencentSessionDelegate QQ登录
//登陆完成调用
- (void)tencentDidLogin
{
    
    if (tencentOAuth.accessToken && tencentOAuth.accessToken.length != 0 )
    {
        //  记录登录用户的OpenID、Token以及过期时间
       
        
        self.openId = tencentOAuth.openId;
        [tencentOAuth getUserInfo];

    }
    else
    {
        MyLog(@"登录不成功没有获取accesstoken");

    }
}
#pragma mark --- QQ登录获取用户信息
-(void)getUserInfoResponse:(APIResponse *)response
{
    
    MyLog(@"respons:%@",response.jsonResponse);
    if (self.openId) {
         [self qqLoginInfor:response.jsonResponse];
    }
   
    
}

- (void)qqLoginInfor:(NSDictionary *)openid;{
    
    BEGIN_MBPROGRESSHUD
//    [self performSelector:@selector(getTimer) withObject:self afterDelay:10];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"04" forKey:loginType];
    [userDefaults setObject:self.openId forKey:loginopenId];
    [userDefaults synchronize];
    [RequestModel requestWeiXinFirstGoinWithURL:self.openId Type:@"04"  Completion:^(NSDictionary *dic) {
       
        END_MBPROGRESSHUD
        if ([dic[@"errorNum"] isEqualToString:@"0"]) {
           
           
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic[@"customer"][@"customerId"] forKey:customer_id];
                [userDefaults setObject:dic[@"customer"][@"customerMobile"] forKey:customer_mobile];
                [userDefaults setObject:dic[@"customer"][@"customerEmail"] forKey:customer_email];
                [userDefaults setObject:dic[@"customer"][@"customerCity"] forKey:customer_region];
                [userDefaults setObject:dic[@"customer"][@"customerJob"] forKey:customer_job];
                [userDefaults setObject:dic[@"customer"][@"customerNickname"] forKey:customer_nickname];
                [userDefaults setObject:dic[@"customer"][@"customerSex"] forKey:customer_sex];
                [userDefaults setObject:dic[@"customer"][@"customerHead"] forKey:customer_head];
                [userDefaults setObject:dic[@"customer"][@"payPassword"] forKey:pay_password];
                
                [userDefaults setObject:@"04" forKey:loginType];
                [userDefaults setBool:YES forKey:had_Login];
                [userDefaults setInteger:-1 forKey:customer_selectPark];
                [userDefaults setObject:openid[@"nickname"] forKey:customer_nickname];
                [userDefaults setBool:YES forKey:@"visitorBOOL"];
                NSNumber *sex = nil;
                if ( [openid[@"gender"] isEqualToString:@"男"]) {
                    sex = [NSNumber numberWithInt:1];
                }else if([openid[@"gender"] isEqualToString:@"女"]){
                    sex = [NSNumber numberWithInt:2];
                    
                }
                
                [userDefaults setObject:sex forKey:customer_sex];
                [userDefaults setObject:openid[@"figureurl_qq_2"] forKey:customer_head];
               
                [userDefaults setObject:self.openId forKey:loginopenId];
                [userDefaults synchronize];
            
            
            
                self.tabBarController.selectedIndex = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccess object:nil];
            
                [self.navigationController popViewControllerAnimated:YES];

            
            
            
            
            

        }else if([dic[@"errorNum"] isEqualToString:@"1"]){
//            __weak typeof(self)ws = self;
            phoneView *phoneV = [[phoneView alloc]init];
            __weak typeof (phoneView *)weakPhoneV = phoneV;
            weakPhoneV.infoL.text = [NSString stringWithFormat:@"%@,为了更好的为您服务,使用本功能前请先绑定手机",openid[@"nickname"]];
            phoneV.nextVC = ^(){
                [weakPhoneV hide];

//                NewMapHomeVC *new = [[NewMapHomeVC alloc] init];
//                [self.navigationController pushViewController:new animated:YES];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:openid[@"nickname"] forKey:customer_nickname];
                [userDefaults setBool:YES forKey:@"visitorBOOL"];
                NSNumber *sex = nil;
                if ( [openid[@"gender"] isEqualToString:@"男"]) {
                    sex = [NSNumber numberWithInt:1];
                }else if([openid[@"gender"] isEqualToString:@"女"]){
                    sex = [NSNumber numberWithInt:2];
                    
                }
                [userDefaults setObject:sex forKey:customer_sex];
                [userDefaults setObject:openid[@"figureurl_qq_2"] forKey:customer_head];
                [userDefaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                    self.tabBarController.selectedIndex = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:KLoginSuccess object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });

            };
            [phoneV show];
            
        }
    
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD
    }];
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    MyLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        MyLog(@"用户取消登录");

    }else{
       MyLog(@"登录失败");
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    MyLog(@"tencentDidNotNetWork");
}


#pragma mark -
#pragma mark -- 点击微博登录
- (IBAction)threeGoinClick:(id)sender {
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"7200" ;
    [WXApi sendReq:req];
}
#pragma mark -
#pragma mark -- 点击QQ登录
- (IBAction)QQLogin:(UIButton *)sender {
    
    //    注册QQ
    tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1105233032"andDelegate:self];
    NSArray  *permissions= [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil];
    
    [tencentOAuth authorize:permissions inSafari:NO];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
   
    if (range.length == 0) {
        if (textField == self.phoneNumTextField) {
        if (self.phoneNumTextField.text.length == 11) {
            return NO;
        }
        
    }
    if (self.passwordTextField == textField) {
        if (self.passwordTextField.text.length == 20) {
            return NO;
        }
    }
    }
    return YES;
}
#pragma mark - 如果10秒还没有进入，让加载消失
- (void)getTimer{
    END_MBPROGRESSHUD
}
- (IBAction)getCodeBtnClick:(id)sender{
    if (self.phoneNumTextField.text.length == 0) {
        ALERT_VIEW(@"请输入手机号");
        _alert = nil;
        return;
    } else if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        
        BEGIN_MBPROGRESSHUD;   // 开启界面加载视图HUD
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,MD5_SECRETKEY] md5];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,SUMMARY:Summary};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
        
        [RequestModel requestGetPhoneNumWithURL:urlStr WithDic:nil Completion:^(NSDictionary *dic) {
            if ([dic[@"errorNum"] isEqualToString:@"0"])
            {
                _getCodeBtn.userInteractionEnabled = NO;
                [self setGetCodeBtnColor:NO];
                _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefreshForget) userInfo:nil repeats:YES];
                [_buttonTimer fire];
            }
            else
            {
                ALERT_VIEW(@"获取验证码失败");
                _alert = nil;
                
            }
            END_MBPROGRESSHUD;
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
            END_MBPROGRESSHUD;
        }];
    }else{
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
}

- (void)setGetCodeBtnColor:(BOOL)isGreen
{
    if (isGreen) {
        [_getCodeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        _getCodeBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    }else
    {
        [_getCodeBtn setTitleColor: [MyUtil colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];

        _getCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"aaaaaa"].CGColor;
    }
    
}
- (void)ButtonTitleRefreshForget
{
    self.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setGetCodeBtnColor:YES];
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}
@end
