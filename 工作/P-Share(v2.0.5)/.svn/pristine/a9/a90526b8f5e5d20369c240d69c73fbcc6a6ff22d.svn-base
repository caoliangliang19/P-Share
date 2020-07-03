//
//  RegistViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "AgreementViewController.h"
#import "NSString+Encrypt.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    int _getCodeCount;
    
    NSTimer *_buttonTimer;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    _getCodeCount = 60;
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
    [_duiHuanMaT resignFirstResponder];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_phoneNumTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_buttonTimer invalidate];
    _buttonTimer = nil;
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
    [_duiHuanMaT resignFirstResponder];

}


- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    self.registBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.registBackView.layer.borderWidth = 0.5;
    self.registBackView.layer.cornerRadius = 4;
    self.registBackView.layer.masksToBounds = YES;
    self.registBtn.layer.cornerRadius = 4;
    self.registBtn.layer.masksToBounds = YES;
    self.registBtn.backgroundColor = NEWMAIN_COLOR;
    
    [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (IBAction)agreeBtnClick:(id)sender {
    AgreementViewController *agreeCtrl = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreeCtrl animated:YES];
}
#pragma mark -
#pragma mark - 获取验证码
- (IBAction)getTextCodeBtnClick:(id)sender {
    
    
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
        [self.getTextCodeBtn setTitleColor:NEWMAIN_COLOR forState:UIControlStateNormal];

        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

//- (void)stopButtonTitleRefreshForget
//{
//    [_buttonTimer invalidate];
//    _buttonTimer = nil;
//    
//    self.getTextCodeBtn.enabled = YES;
//    [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
//}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 对字典进行排序
-(NSArray *)sortDicWithKeyArray:(NSArray *)keyArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [keyArray sortedArrayUsingDescriptors:descriptors];
    return resultArray;
    
}
#pragma mark - 
#pragma mark - 点击注册
- (IBAction)registBtnClick:(id)sender {
    NSString *phoneNum =[NSString stringWithFormat:@"%@",self.phoneNumTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
    NSString *textCode = [NSString stringWithFormat:@"%@",self.textCodeTextField.text];
    
    if(phoneNum.length == 0){
        ALERT_VIEW(@"请输入手机号");
        _alert = nil;
        
        return;
    }else if (![MyUtil isMobileNumber:phoneNum]) {
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
        return;
    }

    if (password.length == 0) {
        ALERT_VIEW(@"请输入密码");
        _alert = nil;
        return;
    }else  if (password.length<6||password.length>20) {
        ALERT_VIEW(@"请输入6-20密码");
        _alert = nil;
        return;
    }
   
    if (textCode.length == 0) {
        ALERT_VIEW(@"请输入验证码");
        _alert = nil;

        return;
    }else if(textCode.length != 4){
        ALERT_VIEW(@"请输入正确验证码");
        _alert = nil;
        return;
    }
    BEGIN_MBPROGRESSHUD;
    
    //               获取时间戳
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate:currentDate];
    
    //                NSString *password = self.passwordTextField.text;
    
//    NSDictionary *tempDic = @{smsCode:self.textCodeTextField.text,MOBILE_CUSTOMER:self.phoneNumTextField.text,PASSWORD_CUSTOMER:password,TIMESTAMP:dateString,@"reg_phone":@"ios",@"redeemCode":self.duiHuanMaT.text};
    
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:self.textCodeTextField.text,smsCode,self.phoneNumTextField.text,MOBILE_CUSTOMER,password,PASSWORD_CUSTOMER,dateString,TIMESTAMP,@"ios",@"reg_phone",self.duiHuanMaT.text,@"redeemCode", nil];
    
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSArray *sortArray = [self sortDicWithKeyArray:[tempDic allKeys]];
    for (int i = 0;i<sortArray.count; i++) {
        [tempStr appendString:tempDic[sortArray[i]]];
        
    }
    [tempStr appendString:MD5_SECRETKEY];
    
    NSString *summaryStr = [tempStr md5];
    
   
    NSDictionary *paramDic  = [NSDictionary dictionaryWithObjectsAndKeys:self.textCodeTextField.text,smsCode,self.phoneNumTextField.text,MOBILE_CUSTOMER,password,PASSWORD_CUSTOMER,dateString,TIMESTAMP,@"ios",@"reg_phone",summaryStr,SUMMARY,self.duiHuanMaT.text,@"redeemCode", nil];
    
    //                实现注册
    
    [RequestModel requestRegisterWithURL:USER_REGIST WithDic:paramDic Completion:^(NSDictionary *dict) {
        if ([dict[@"errorNum"] isEqualToString:@"0"])
        {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"10" forKey:loginType];
            [userDefaults setBool:YES forKey:had_Login];
            [userDefaults setObject:self.phoneNumTextField.text forKey:customer_mobile];
            [userDefaults setObject:@"0" forKey:pay_password];
            
            [userDefaults setObject:dict[@"customerId"] forKey:customer_id];
            [userDefaults setObject:dict[@"identity"] forKey:identity];
            
            [userDefaults setBool:YES forKey:@"visitorBOOL"];
            
            [userDefaults setObject:@"1" forKey:had_Login];
            
            
            [userDefaults setInteger:-1 forKey:customer_selectPark];
            
            [userDefaults synchronize];
            
            NewMapHomeVC *newHomeVC = [[NewMapHomeVC alloc] init];
            [self.navigationController pushViewController:newHomeVC animated:YES];
            
//            NewHomeViewController *newHomeVC = [[NewHomeViewController alloc] init];
//            [self.navigationController pushViewController:newHomeVC animated:YES];
            
        }else
        {
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

- (IBAction)haveRegistBtnClick:(id)sender {
    LoginViewController *loginCtrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (range.length == 0) {
      
        if (textField == self.phoneNumTextField) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,string];
            if (str.length == 11) {
                [self cleckPhoneNumber:str];
            }
            
            if (self.phoneNumTextField.text.length == 11) {
                
                return NO;
            }
            
        }
        if (self.passwordTextField == textField) {
            if (self.passwordTextField.text.length == 20) {
                return NO;
            }
        }
        if (self.textCodeTextField == textField) {
            if (self.textCodeTextField.text.length == 4) {
                return NO;
            }
        }
    }
    return YES;
}
- (void)cleckPhoneNumber:(NSString *)str{
    [RequestModel requestGetPhoneCodeWithUrl:str WithDic:nil Completion:^(NSDictionary *dic) {
        if ([dic[@"errorNum"] isEqualToString:@"0"]) {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
        }
    } Fail:^(NSString *errror) {
        
    }];
}
@end



