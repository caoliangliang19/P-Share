//
//  AgainSetCodeController.m
//  P-Share
//
//  Created by 亮亮 on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//
#define CELLID1  @"ShangCell"
#define CELLID2  @"XiaCell"
#import "AgainSetCodeController.h"
#import "NewMonthlyRentAuthCodeCell.h"
#import "CodeTextCell.h"
#import "SuccessCell.h"

@interface AgainSetCodeController ()<UITableViewDataSource,UITableViewDelegate,NewMonthlyRentAuthCodeCellDeleaget,UIAlertViewDelegate>
{
    NSString *_codeString;
    NSString *_codeString1;
    
    int _getCodeCount;
    UITextField *_messageCode;
    NSString *_validateResult;
    UIButton *_button;
    
    NSTimer *_buttonTimer;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    UIAlertView *_alert;
}
@property (nonatomic,strong)UIButton *getTextCodeBtn;

@end

@implementation AgainSetCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
#pragma mark - 
#pragma mark -  更新UI
- (void)setUI{

    if (_titleStr.length > 1) {
        _titleL.text = _titleStr;

    }
    _getCodeCount = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [MyUtil colorWithHexString:@"eeeeee"];
    self.tableView.tableFooterView = [self createFootView];
}
#pragma mark -
#pragma mark -  创建确认支付按钮
- (UIView *)createFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, 33)];
    _button = [MyUtil createBtnFrame:CGRectMake(0, 0, SCREEN_WIDTH-28, 33) title:@"确认提交" bgImageName:nil target:self action:@selector(tureClick:)];
    if ([self.isBeginCode isEqualToString:@"YES"]) {
    _button.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    _button.userInteractionEnabled = NO;
        _button.hidden = YES;
    [_button setTitleColor:[MyUtil colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    }else{
        _button.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
        _button.userInteractionEnabled = YES;
        _button.hidden = NO;
        [_button setTitleColor:[MyUtil colorWithHexString:@"fcfcfc"] forState:UIControlStateNormal];
    }
   
    [view addSubview:_button];
    return view;
}
- (void)tureClick:(UIButton *)button{
    
    [self.view endEditing:YES];

    
    if (_codeString.length == 0 ||_codeString1.length == 0) {
        ALERT_VIEW(@"请输入密码");
        _alert = nil;
        return;
        
    }
    
    if (_codeString1.length != 6 || _codeString.length != 6){
        ALERT_VIEW(@"请输入6位密码");
        _alert = nil;
        return;
    }else if ([_codeString isEqualToString:_codeString1]) {
            
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefault objectForKey:customer_id];
        NSString *Summary = [[NSString stringWithFormat:@"%@%@%@",userId,[_codeString1 MD5],MD5_SECRETKEY] MD5];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",resetPayPassword,userId,[_codeString1 MD5],Summary];
        [RequestModel validateResetPayPasswordWithURL:urlStr WithDic:nil Completion:^(NSString *result) {
            
//            密码设置成功
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"1" forKey:pay_password];
            [user synchronize];
            
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            
        } Fail:^(NSString *error) {
             ALERT_VIEW(@"请输入正确验证码");
            _alert = nil;
        }];
    }else{
        ALERT_VIEW(@"两次密码不一致");
        _alert = nil;
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    [self performSelector:@selector(onTimer) withObject:self afterDelay:0.25];
}
- (void)onTimer{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   //支付成功之后返回4
   
    if ([self.isBeginCode isEqualToString:@"YES"]) {
        return  1;
    }else{
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if ([self.isBeginCode isEqualToString:@"YES"]) {
        if (section == 0) {
            return 1;
        }
        return 1;
    }else{
        return 1;
    }

   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if ([self.isBeginCode isEqualToString:@"YES"]) {
        if (indexPath.section == 0) {
            if (![_validateResult isEqualToString:@"验证通过"]) {
                NewMonthlyRentAuthCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID1];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"NewMonthlyRentAuthCodeCell" owner:nil options:nil] lastObject];
                }
                cell.delegate = self;
                cell.infoL.text = @"通过您注册的手机号码进行短信验证";
//                cell.getAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                _getTextCodeBtn = cell.getAuthCodeBtn;
                _messageCode = cell.authCode;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else
            {
                SuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuccessCell"];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"SuccessCell" owner:nil options:nil] lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }
        CodeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CodeTextCell" owner:nil options:nil] lastObject];
        }
        cell.myBlock = ^(NSArray *array){
            _codeString = array[0];
            _codeString1 = array[1];
            
        };
        cell.pass.userInteractionEnabled = NO;
        cell.pass1.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CodeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CodeTextCell" owner:nil options:nil] lastObject];
        }
        cell.myBlock = ^(NSArray *array){
            _codeString = array[0];
            _codeString1 = array[1];
            
        };
        cell.pass.userInteractionEnabled = YES;
        cell.pass1.userInteractionEnabled = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.isBeginCode isEqualToString:@"YES"]) {
        if (indexPath.section == 0) {
        if (![_validateResult isEqualToString:@"验证通过"]) {
             return 127;
        }else{
            return 79;
        }
       
    }
        return 130;
    }else{
        return 130;
    }
    

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
#pragma mark -
#pragma mark - NewMonthlyRentAuthCodeCellDeleaget代理方法，点击事件
- (void)getAuthCodeWith:(UIButton *)btn;{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:customer_mobile];
    NSString *Summary = [[NSString stringWithFormat:@"%@%@",phoneNume,MD5_SECRETKEY] MD5];
    NSDictionary *paramDic = @{MOBILE_CUSTOMER:phoneNume,SUMMARY:Summary};
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",GETREGISTER_CODE,paramDic[MOBILE_CUSTOMER],paramDic[SUMMARY]];
    
    
    [RequestModel requestGetPhoneNumWithURL:urlStr WithDic:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"errorNum"] isEqualToString:@"0"])
        {
            NewMonthlyRentAuthCodeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.infoL.text = [NSString stringWithFormat:@"已发送短信至您尾号%@的手机",[phoneNume substringFromIndex:7]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.infoL.text];
            [str addAttribute:NSForegroundColorAttributeName value:[MyUtil colorWithHexString:@"39d5b8"] range:NSMakeRange(9,4)];
            
            cell.infoL.attributedText = str;
            
            _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefresh) userInfo:nil repeats:YES];
            [_buttonTimer fire];
            
        }else
        {
            ALERT_VIEW(dic[@"errorInfo"]);
            _alert = nil;
            END_MBPROGRESSHUD;
        }
        END_MBPROGRESSHUD;
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD;
    }];
}
- (void)ButtonTitleRefresh
{
    [self.getTextCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.getTextCodeBtn.enabled = NO;
    self.getTextCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    self.getTextCodeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.getTextCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        self.getTextCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}
- (void)sureCommitAuthCode:(UIButton *)btn{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:customer_mobile];
//    NSString *userId = [userDefault objectForKey:customer_id];
    _getCodeCount = 60;
    
    if (_messageCode.text.length == 0) {
        ALERT_VIEW(@"请输入验证码");
        _alert = nil;
    }else if (_messageCode.text.length == 4){

        [_buttonTimer invalidate];
        _buttonTimer = nil;
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        self.getTextCodeBtn.layer.borderColor = [MyUtil colorWithHexString:@"39D5B8"].CGColor;
    
       
        NSString *Summary = [[NSString stringWithFormat:@"%@%@%@",phoneNume,_messageCode.text,MD5_SECRETKEY] MD5];
        
      
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",validatecode,phoneNume,_messageCode.text,Summary];
        
        [RequestModel validatePurseBaoCodeWithURL:urlStr WithDic:nil Completion:^(NSString *result) {
            
            if ([result isEqualToString:@"0"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"monthlyLoadDate" object:@"notification"];
                
                _validateResult = @"验证通过";
                self.isBeginCode = @"NO";
                
                [self.tableView reloadData];
                _button.backgroundColor = [MyUtil colorWithHexString:@"39d5b8"];
                _button.userInteractionEnabled = YES;
                _button.hidden = NO;
                [_button setTitleColor:[MyUtil colorWithHexString:@"fcfcfc"] forState:UIControlStateNormal];
                
            }else{
                
                _validateResult = @"验证失败";
                ALERT_VIEW(@"请输入正确验证码");
                _alert = nil;
                
            }
            
        } Fail:^(NSString *error) {
            ALERT_VIEW(error);
        }];
        
        
    }else {
        ALERT_VIEW(@"请输入正确验证码");
        _alert = nil;
        
    }
}




- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
