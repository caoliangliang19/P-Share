//
//  ResetPswViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ResetPswViewController.h"
#import "ConfirmPswViewController.h"

@interface ResetPswViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    int _getCodeCount;
    
    NSTimer *_buttonTimer;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation ResetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _getCodeCount = 60;
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
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
    
    [self stopButtonTitleRefreshForget];
}


//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.forgetBackView.layer.borderWidth = 0.5;
    self.forgetBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.forgetBackView.layer.cornerRadius = 4;
    self.forgetBackView.layer.masksToBounds = YES;
    
    self.makeSureBtn.layer.cornerRadius = 4;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.backgroundColor = NEWMAIN_COLOR;
    
    [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}



- (IBAction)getTextCodeBtnClick:(id)sender {
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        BEGIN_MBPROGRESSHUD;
        
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
                ALERT_VIEW(dic[@"errorInfo"]);
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
    [self.textCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.textCodeBtn.enabled = NO;
    self.textCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    [self.textCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.textCodeBtn.enabled = YES;
        [self.textCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

- (void)stopButtonTitleRefreshForget
{
    [_buttonTimer invalidate];
    _buttonTimer = nil;
    
    self.textCodeBtn.enabled = YES;
    [self.textCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
}

- (IBAction)makeSureBtnClick:(id)sender {
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
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.textCodeTextField.text,@"smsCode",self.phoneNumTextField.text,@"mobile",[MyUtil getTimeStamp],@"timestamp", nil];
            
            
            [RequestModel requestGetPhoneNumNewWithURL:verifySmsCode WithDic:paramDic Completion:^(NSDictionary *dict) {
                if ([dict[@"errorNum"] isEqualToString:@"0"])
                {
                        NSLog(@"%@",dict);
                        ConfirmPswViewController *confirmCtrl = [[ConfirmPswViewController alloc] init];
                        confirmCtrl.userPhoneNum = self.phoneNumTextField.text;
                        [self.navigationController pushViewController:confirmCtrl animated:YES];
                }else
                {
                    ALERT_VIEW(dict[@"errorInfo"]);
                    _alert = nil;
                }
                MyLog(@"%@",dict);
                END_MBPROGRESSHUD;
            } Fail:^(NSString *error) {
                ALERT_VIEW(error);
                _alert = nil;
                MyLog(@"%@",error);
                END_MBPROGRESSHUD;
            }];
    }else{
            ALERT_VIEW(@"请输入正确验证码");
            _alert = nil;
        }
    }else{
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    
    if (range.length == 0) {
        if (textField == self.phoneNumTextField) {
            
            if (self.phoneNumTextField.text.length == 10) {
                NSString *temStr = [self.phoneNumTextField.text stringByAppendingString:string];
                
                [self cleckPhoneNumber:temStr];

            }
            
            if (self.phoneNumTextField.text.length == 11) {
                
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
        if ([dic[@"errorNum"] isEqualToString:@"1"]) {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
        }
       
    } Fail:^(NSString *errror) {
        
    }];
}
@end






