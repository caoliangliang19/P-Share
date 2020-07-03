//
//  phoneView.m
//  P-Share
//
//  Created by fay on 16/3/31.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "phoneView.h"


@interface phoneView ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    
    NSTimer *_buttonTimer;
    
    int _getCodeCount;
    
    
}

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation phoneView
- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"phoneView" owner:nil options:nil] lastObject];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
       
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 280, 210);
        [window addSubview:self.backgroundView];
        [window addSubview:self];
    }
    return self;
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}
#pragma mark -
#pragma mark - view显示
- (void)show{
    
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundView.hidden =NO;
        
        self.backgroundView.userInteractionEnabled =NO;
        
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        
        
    } completion:^(BOOL finished) {
        
        
        self.hidden = NO;
        self.backgroundView.userInteractionEnabled =YES;
        
    }];
    
    
}
#pragma mark -
#pragma mark - view消失
- (void)hide{
    
    [UIView animateWithDuration:.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
     
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self MyClick];
        });
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
    
    
}
- (void)MyClick{
    if (self.backgroundView)
    {
        [self.backgroundView removeFromSuperview];
    }
    [self removeFromSuperview];
}
- (void)awakeFromNib
{
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    _getCodeCount = 60;
    self.phoneNumTextField.delegate = self;
    self.textCodeTextField.delegate = self;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [MyUtil colorWithHexString:@"E1E1E1"].CGColor;
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
   
    [self layoutSubviews];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    _name = CUSTOMERMOBILE(customer_nickname);
//    _infoL.text = [NSString stringWithFormat:@"%@,为了更好的为您服务,使用本功能前请先绑定手机",_name];

}

- (IBAction)commitBtnClick:(UIButton *)sender {
    NSString *phoneNum =[NSString stringWithFormat:@"%@",self.phoneNumTextField.text];
    NSString *textCode = [NSString stringWithFormat:@"%@",self.textCodeTextField.text];
    if (phoneNum.length == 0&&textCode.length == 0) {
        ALERT_VIEW(@"请输入手机号");
        return;
    }
    if (!(phoneNum.length == 0)&&textCode.length == 0) {
        ALERT_VIEW(@"请输入验证码");
        return;
    }
    if (phoneNum.length == 0&&!(textCode.length == 0)) {
        ALERT_VIEW(@"请输入手机号");
        return;
    }
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text])
    {
       if (self.textCodeTextField.text.length == 4)
            {
                BEGIN_MBPROGRESSHUD;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:CUSTOMERMOBILE(loginopenId),@"quickId",CUSTOMERMOBILE(loginType),@"quickType",self.phoneNumTextField.text,@"mobile",self.textCodeTextField.text,@"smsCode",@"ios",@"regPhone",@"2.0.1",@"version", nil];
                
                [RequestModel requestWinXinRegistByOtherURL:dict code:nil Completion:^(NSDictionary *dic) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setBool:YES forKey:had_Login];
                    [userDefaults setObject:dic[@"customer"][@"customerId"] forKey:customer_id];
                    [userDefaults setObject:dic[@"customer"][@"customerMobile"] forKey:customer_mobile];
                    [userDefaults setObject:dic[@"customer"][@"payPassword"] forKey:pay_password];

                    [userDefaults setObject:dic[@"customer"][@"customerEmail"] forKey:customer_email];
                    [userDefaults setObject:dic[@"customer"][@"customerCity"] forKey:customer_region];
                    [userDefaults setBool:YES forKey:@"visitorBOOL"];
                    [userDefaults setObject:dic[@"customerJob"] forKey:customer_job];
                    [userDefaults setInteger:-1 forKey:customer_selectPark];
                    [userDefaults synchronize];
                  
                    
                    if (self.nextVC) {
                        self.nextVC();
                        
                        
                    }
                    END_MBPROGRESSHUD;
                } Fail:^(NSString *error) {
                    
                    ALERT_VIEW(error);
                    _alert = nil;
                    
                    END_MBPROGRESSHUD;
                }];
                
                
            }else
            {
                ALERT_VIEW(@"请输入正确验证码");
                _alert = nil;
                
            }
    }else
    {
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
        
    }

}
- (IBAction)getYanZhengBtnClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,MD5_SECRETKEY] MD5];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,SUMMARY:Summary};
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
        
        [RequestModel requestGetPhoneNumWithURL:urlStr WithDic:nil Completion:^(NSDictionary *dic) {
            if ([dic[@"errorNum"] isEqualToString:@"0"])
            {

                _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefreshForget) userInfo:nil repeats:YES];
                [_buttonTimer fire];
            }
            else
            {
                sender.userInteractionEnabled = YES;

                ALERT_VIEW(@"获取验证码失败");
                _alert = nil;
                
            }
        } Fail:^(NSString *error) {
            sender.userInteractionEnabled = YES;

            ALERT_VIEW(error);
            _alert = nil;
        }];
    }else{
        sender.userInteractionEnabled = YES;

        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
    

   
}

- (void)ButtonTitleRefreshForget
{
    [self.getTextCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.getTextCodeBtn.enabled = NO;
    self.getTextCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    [self.getTextCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.phoneNumTextField) {
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
    }else{
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-100);
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self endEditing:YES];
    return YES;
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self hide];
}


@end
