//
//  WeiXinPhoneController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/11.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "WeiXinPhoneController.h"
#import "RequestModel.h"

@interface WeiXinPhoneController ()
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    
     NSTimer *_buttonTimer;
    
    int _getCodeCount;
}
@end

@implementation WeiXinPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    _getCodeCount = 60;
    [self setUI];
    
}

- (void)setUI
{
    
    self.myLable.text = [NSString stringWithFormat:@"%@,请完善你的口袋停资料",self.userName];
    self.registBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.registBackView.layer.borderWidth = 0.5;
    self.registBackView.layer.cornerRadius = 4;
    self.registBackView.layer.masksToBounds = YES;
   
    [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark -
#pragma mark - 点击提交绑定手机号
- (IBAction)agreeBtnClick:(id)sender;{
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text])
    {
        if (self.passwordTextField.text.length >=6 && self.passwordTextField.text.length <=20)
        {
            if (self.textCodeTextField.text.length == 4)
            {
                BEGIN_MBPROGRESSHUD;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.openid],@"quickId",_type,@"quickType",self.phoneNumTextField.text,@"mobile",self.passwordTextField.text,@"password",self.textCodeTextField.text,@"smsCode", nil];

             [RequestModel requestWinXinRegistByOtherURL:dict code:nil Completion:^(NSDictionary *dic) {
                 [self updataUserInfoWithGet:dic];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setBool:YES forKey:had_Login];
                 [userDefaults setObject:dic[@"customer"][@"customerId"] forKey:customer_id];
                 [userDefaults setObject:dic[@"customer"][@"customerMobile"] forKey:customer_mobile];
                 [userDefaults setObject:dic[@"customer"][@"customerEmail"] forKey:customer_email];
                 [userDefaults setObject:dic[@"customer"][@"customerCity"] forKey:customer_region];
                 [userDefaults setBool:YES forKey:@"visitorBOOL"];
                 [userDefaults setObject:dic[@"customerJob"] forKey:customer_job];
                [userDefaults synchronize];
                [userDefaults setInteger:-1 forKey:customer_selectPark];
                 NewMapHomeVC *newHome = [[NewMapHomeVC alloc]init];
                 [self.navigationController pushViewController:newHome animated:YES];
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
        }
    }else
    {
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
        
    }
    
}
#pragma mark - 
#pragma mark - 保存数据
- (void)updataUserInfoWithGet:(NSDictionary *)dic
{
    BEGIN_MBPROGRESSHUD;

    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:customer_nickname,dic[@"customer"][@"customerId"],_userSex,customer_sex, nil];
    
    NSString *urlString = [SET_USER_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *requestModel = [RequestModel new];
    [requestModel getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        END_MBPROGRESSHUD;

    } error:^(NSString *error) {
        
        MyLog(@"%@",error);
        
        END_MBPROGRESSHUD;

    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);

        END_MBPROGRESSHUD;

    }];
    
}
#pragma mark -
#pragma mark - 获取验证码
- (IBAction)getTextCodeBtnClick:(id)sender{
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        BEGIN_MBPROGRESSHUD;   // 开启界面加载视图HUD
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,MD5_SECRETKEY] MD5];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,SUMMARY:Summary};
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
        RequestModel *requestModel = [RequestModel new];
        
        [requestModel getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"errorNum"] isEqualToString:@"0"])
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
            
        } error:^(NSString *error) {
            ALERT_VIEW(error);
            _alert = nil;
            END_MBPROGRESSHUD;
            
        } failure:^(NSString *fail) {
            ALERT_VIEW(fail);
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
        [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}
- (IBAction)backBtnClick:(id)sender;{
    [self.navigationController popViewControllerAnimated:YES];
}



//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_buttonTimer invalidate];
    _buttonTimer = nil;
}
#pragma mark -- 对字典进行排序
-(NSArray *)sortDicWithKeyArray:(NSArray *)keyArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [keyArray sortedArrayUsingDescriptors:descriptors];
    return resultArray;
    
}
@end
