//
//  GoinAlertView.m
//  P-Share
//
//  Created by 亮亮 on 16/6/30.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "GoinAlertView.h"
#import "AgreementViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

typedef void (^turnBtn)();
typedef void (^cancleBtn)();

@interface GoinAlertView ()<TencentSessionDelegate,UITextFieldDelegate>
{
    UIAlertView *_alert;
    NSTimer *_buttonTimer;
    NSInteger _getCodeCount;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    
    TencentOAuth *tencentOAuth;
}
@property (copy , nonatomic)turnBtn tureBlock;
@property (copy , nonatomic)cancleBtn cancleBlock;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy)NSString *openId;

@end
@implementation GoinAlertView

- (instancetype)initWithController:(UIViewController *)viewController;{
    
    self = [super init];
    
    if (self) {
        
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"GoinAlertView" owner:nil options:nil]lastObject];
        
        // 初始化设置
        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 281, 400);
        
        [viewController.view addSubview:self.bgView];
        
        [viewController.view addSubview:self];
        self.viewController = viewController;
//        ALLOC_MBPROGRESSHUD_VIEW
    }
    
    return self;
    
}
- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;{
    self.tureBlock = tureBlock;
    self.cancleBlock = cancleBlock;
}
#pragma mark -
#pragma mark - 加载时图
- (void)awakeFromNib{

    _getCodeCount = 60;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.loginView.layer.borderWidth = 1;
    self.loginView.layer.borderColor = [MyUtil colorWithHexString:@"e0e0e0"].CGColor;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;
    self.phoneNumTextField.delegate = self;
    self.codeTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:tap];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}
- (void)onClick{
    [self endEditing:YES];
}
#pragma mark -
#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _bgView.hidden =YES;
        
    }
    
    return _bgView;
    
}
#pragma mark -
#pragma mark - view显示
- (void)show{
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bgView.hidden =NO;
        
        self.bgView.userInteractionEnabled =NO;
        
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        
        
    } completion:^(BOOL finished) {
        
        
        self.hidden = NO;
        self.bgView.userInteractionEnabled =YES;
        
    }];
    
    
}
#pragma mark -
#pragma mark - view消失
- (void)hide{
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self performSelector:@selector(MyClick) withObject:self afterDelay:0.2];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
    
    
}
- (void)MyClick{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}
#pragma mark -
#pragma mark - 1取消按钮 2获取验证码 3登录 4口袋停用户协议 5微信 6QQ
- (IBAction)logInAlertView:(UIButton *)sender;{
    switch (sender.tag) {
        case 1:
        {
            [self hide];
        }
            break;
        case 2:
        {
            [self getCode];
        }
            break;
        case 3:
        {
            [self goInNumber];
        }
            break;
        case 4:
        {
            AgreementViewController *agreeCtrl = [[AgreementViewController alloc] init];
            [self.viewController.navigationController pushViewController:agreeCtrl animated:YES];
        }
            break;
        case 5:
        {
            SendAuthReq* req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
            req.state = @"7200" ;
            [WXApi sendReq:req];
        }
            break;
        case 6:
        {
            //    注册QQ
            tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1105233032"andDelegate:self];
            NSArray  *permissions= [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil];
            
            [tencentOAuth authorize:permissions inSafari:NO];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark - 获取验证码
- (void)getCode{
    if (self.phoneNumTextField.text.length == 0) {
        ALERT_VIEW(@"请输入手机号");
        _alert = nil;
        return;
    } else if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        
       BEGIN_MBPROGRESSHUD
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,MD5_SECRETKEY] MD5];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,SUMMARY:Summary};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
        
        [RequestModel requestGetPhoneNumWithURL:urlStr WithDic:nil Completion:^(NSDictionary *dic) {
            if ([dic[@"errorNum"] isEqualToString:@"0"])
            {
                self.codeBtn.userInteractionEnabled = NO;
                [self setGetCodeBtnColor:NO];
                _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefreshForget) userInfo:nil repeats:YES];
                [_buttonTimer fire];
            }
            else
            {
                ALERT_VIEW(@"获取验证码失败");
                _alert = nil;
                
            }
           END_MBPROGRESSHUD
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
           END_MBPROGRESSHUD
        }];
    }else{
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
        END_MBPROGRESSHUD
    }
}
- (void)setGetCodeBtnColor:(BOOL)isGreen
{
    if (isGreen) {
        [self.codeBtn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        self.codeBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    }else
    {
        [self.codeBtn setTitleColor: [MyUtil colorWithHexString:@"aaaaaa"] forState:(UIControlStateNormal)];
        
        self.codeBtn.layer.borderColor = [MyUtil colorWithHexString:@"aaaaaa"].CGColor;
    }
    
}
- (void)ButtonTitleRefreshForget
{
    self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)_getCodeCount];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        self.codeBtn.userInteractionEnabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setGetCodeBtnColor:YES];
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}
#pragma mark -
#pragma mark - 正常登录
- (void)goInNumber{
    NSString *phoneNum =[NSString stringWithFormat:@"%@",self.phoneNumTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.codeTextField.text];
    
    if (phoneNum.length != 11) {
        ALERT_VIEW(@"请输入正确手机号");
        return;
    }else if (password.length != 4){
        ALERT_VIEW(@"请输入正确验证码");
        return;
    }
    
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNumTextField.text,@"mobile",password,@"code",@"2.0.1",@"version", nil];
    
    BEGIN_MBPROGRESSHUD
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
            if (self.tureBlock) {
                self.tureBlock();
            }
          
        }else{
            ALERT_VIEW(dict[@"errorInfo"]);
            _alert = nil;
        }
       
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD
    }];
}
#pragma mark -
#pragma mark - 微信登录
- (void)tongzhi:(NSNotification *)text{
    
    [self getAccess_token:text.userInfo[@"code"]];
}
- (void)getAccess_token:(NSString *)code{
    
     BEGIN_MBPROGRESSHUD
    [self performSelector:@selector(getTimer) withObject:self afterDelay:10];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx7248073ee8171c2b",@"f6167b2ca139d51ba8653d8a7cc28888",code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 
                [self refreshAcressToken:dic[@"refresh_token"]];
            }
        });
    });
}
- (void)refreshAcressToken:(NSString *)string{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx7248073ee8171c2b&grant_type=refresh_token&refresh_token=%@",string];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *access_token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                [self getUserInfo:access_token opedID:openid];
                
            }
        });
        
    });
}
- (void)getUserInfo:(NSString *)accessToken opedID:(NSString *)openid{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic[@"openid"]) {
                    [self requestUrl:dic];
                }else{
                }
            }
        });
        
    });
}
- (void)requestUrl:(NSDictionary *)openid{
    
    [RequestModel requestWeiXinFirstGoinWithURL:openid[@"openid"] Type:@"01"  Completion:^(NSDictionary *dic) {
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
            //            NewHomeViewController *newHome = [[NewHomeViewController alloc]init];
            //            [self.navigationController pushViewController:newHome animated:NO];
            
//            NewMapHomeVC *new = [[NewMapHomeVC alloc] init];
//            [self.navigationController pushViewController:new animated:NO];
            
        }else
        {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
            
        }
        
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
         END_MBPROGRESSHUD
    
    }];
}
- (void)getTimer{
    END_MBPROGRESSHUD
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
    [self performSelector:@selector(getTimer) withObject:self afterDelay:10];
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
            [userDefaults setObject:openid[@"figureurl_2"] forKey:customer_head];
            [userDefaults setObject:self.openId forKey:loginopenId];
            [userDefaults synchronize];
           
            
        }else
        {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
            
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
