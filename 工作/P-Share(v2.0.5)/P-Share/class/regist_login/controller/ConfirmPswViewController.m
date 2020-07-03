//
//  ConfirmPswViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ConfirmPswViewController.h"
#import "LoginViewController.h"
#import "NewMapHomeVC.h"

#import "NSString+Encrypt.h"
@interface ConfirmPswViewController ()
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation ConfirmPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_passwordOneTextfield resignFirstResponder];
    [_passwordTwoTextField resignFirstResponder];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_passwordOneTextfield becomeFirstResponder];
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordOneTextfield resignFirstResponder];
    [_passwordTwoTextField resignFirstResponder];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.confirmBackView.layer.borderWidth = 0.5;
    self.confirmBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.confirmBackView.layer.cornerRadius = 4;
    self.confirmBackView.layer.masksToBounds = YES;
    
    self.makeSureBtn.layer.cornerRadius = 4;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.backgroundColor = NEWMAIN_COLOR;
    
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

- (IBAction)makeSureBtnClick:(id)sender {
    NSString *password = [NSString stringWithFormat:@"%@",self.passwordOneTextfield.text];
    NSString *password1 = [NSString stringWithFormat:@"%@",self.passwordTwoTextField.text];
    if (password.length == 0||password1.length==0) {
        ALERT_VIEW(@"请输入密码");
        return;
    }
    
    if (self.passwordOneTextfield.text.length >=6 && self.passwordOneTextfield.text.length <=20) {
        if ([self.passwordOneTextfield.text isEqualToString:self.passwordTwoTextField.text]) {
            BEGIN_MBPROGRESSHUD;
          

            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userPhoneNum,@"mobile",self.passwordOneTextfield.text,@"password",[MyUtil getTimeStamp],@"timestamp", nil];
            
            
            [RequestModel requestGetPhoneNumNewWithURL:resetPwd WithDic:paramDic Completion:^(NSDictionary *dict) {
                if ([dict[@"errorNum"] isEqualToString:@"0"]) {
                    [RequestModel requestGetPhoneNumNewWithURL:customlogin WithDic:paramDic Completion:^(NSDictionary *dict) {
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
                            [userDefaults setObject:dict[@"payPassword"] forKey:pay_password];
                            
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
                            
                            NewMapHomeVC *homeCtrl = [[NewMapHomeVC alloc] init];
                            [self.navigationController pushViewController:homeCtrl animated:NO];

                            
//                            NewHomeViewController *homeCtrl = [[NewHomeViewController alloc] init];
//                            [self.navigationController pushViewController:homeCtrl animated:NO];
                        }else{
                            ALERT_VIEW(dict[@"errorInfo"]);
                            _alert = nil;
                        }
                        END_MBPROGRESSHUD;
                        
                    } Fail:^(NSString *error) {
                        ALERT_VIEW(@"登陆失败");
                        _alert = nil;
                        MyLog(@"%@",error);
                        END_MBPROGRESSHUD;
                    }];
                }else{
                    ALERT_VIEW(@"errorInfo");
                    _alert = nil;
                }
            } Fail:^(NSString *error) {
                ALERT_VIEW(@"登陆失败");
                _alert = nil;
                MyLog(@"%@",error);
                END_MBPROGRESSHUD;
            }];
            
        }else{
            ALERT_VIEW(@"两次密码不一致");
        }
    }else{
        ALERT_VIEW(@"请输入6-20位密码");
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (range.length == 0) {
        if (textField == self.passwordOneTextfield) {
            if (self.passwordOneTextfield.text.length == 11) {
                return NO;
            }
            
        }
        
        if (self.passwordTwoTextField == textField) {
            if (self.passwordTwoTextField.text.length == 11) {
                return NO;
            }
        }
    }
    return YES;
}




- (void)dealloc
{
    _alert = nil;
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
