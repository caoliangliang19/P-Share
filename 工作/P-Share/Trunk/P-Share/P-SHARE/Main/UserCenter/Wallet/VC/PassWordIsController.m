//
//  PassWordIsController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/10/20.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PassWordIsController.h"
#import "FayTextField.h"
#import "NumberKeyBoard.h"


@interface PassWordIsController ()<UITextFieldDelegate,NumberKeyBoardDelegate>
{
    UIView *_superView;
    UILabel *_textLable;
    UITextField *_codeField;
    UIButton *_codeButton;
    UIButton *_tureButton;
    UIView *_lineView;
    
    UIView *_passWordView;
    FayTextField    *_faytextField;
    FayTextField    *_faytextField1;
    NSMutableString *_temNumStr;
    NSMutableString *_temNumStr1;
    UIButton *_tureBtn;
    BOOL _istextField;
    NSTimer *_buttonTimer;
    NSInteger _getCodeCount;
    
}
@end

@implementation PassWordIsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"pay_password"] integerValue] == 0) {
        self.title = @"设置支付密码";
        [self createPassWordView];
    }else{
        self.title = @"重置支付密码";
        [self createView];
    }
    
    
    
    
}
- (void)createPassWordView{
    
    _passWordView = [[UIView alloc]init];
    _passWordView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:_passWordView];
    
    UILabel *lable = [UtilTool createLabelFrame:CGRectZero title:@"输入密码" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter numberOfLine:0];
    [_passWordView addSubview:lable];
    
    UILabel *lable1 = [UtilTool createLabelFrame:CGRectZero title:@"重置密码" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter numberOfLine:0];
    [_passWordView addSubview:lable1];
    
    FayTextField *faytextField = [[FayTextField alloc] init];
    _faytextField = faytextField;
    faytextField.delegate = self;
    NumberKeyBoard *numberKeyBoard = [NumberKeyBoard createNumberKeyBoard];
    numberKeyBoard.delegate = self;
    faytextField.inputView = numberKeyBoard;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [faytextField becomeFirstResponder];
        
    });
    faytextField.backgroundColor = [UIColor whiteColor];
    faytextField.textColor = [UIColor whiteColor];
    faytextField.tintColor = [UIColor whiteColor];
   [_passWordView addSubview:faytextField];
    faytextField.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
    
    FayTextField *faytextField1 = [[FayTextField alloc] init];
    _faytextField1 = faytextField1;
    faytextField1.delegate = self;
    faytextField1.inputView = numberKeyBoard;

    faytextField1.backgroundColor = [UIColor whiteColor];
    faytextField1.textColor = [UIColor whiteColor];
    faytextField1.tintColor = [UIColor whiteColor];
    [_passWordView addSubview:faytextField1];
    
    _tureBtn = [UtilTool createBtnFrame:CGRectZero title:@"确认提交" bgColor:[UIColor colorWithHexString:@"39d5b8"] textColor:[UIColor whiteColor] textFont:15 target:self action:@selector(onTureClick)];
    _tureBtn.layer.cornerRadius = 4;
    [_passWordView addSubview:_tureBtn];
    
    
    [_passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(140);
    }];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable.mas_bottom).offset(10);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
   
    [faytextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
       
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(187);
        make.left.mas_equalTo(lable.mas_right).offset(10);
    }];
    [faytextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(faytextField.mas_bottom).offset(10);
        
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(187);
        make.left.mas_equalTo(lable1.mas_right).offset(10);
    }];
    [_tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(faytextField1.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    [faytextField1 layoutIfNeeded];
    [faytextField1 setUpSubView];
    [faytextField layoutIfNeeded];
    [faytextField setUpSubView];
    [faytextField frame:@"faytextField"];
    [faytextField1 frame:@"faytextField1"];
    MyLog(@"%@",NSStringFromCGRect(faytextField.bounds));
    
}
- (void)onTureClick{
    [self.view endEditing:YES];
    NSLog(@"=====%@",_temNumStr);
    NSLog(@"111111==%@",_temNumStr1);
    if (_temNumStr.length == 0 ||_temNumStr1.length == 0) {
        
        return;
        
    }
    
    if (_temNumStr.length != 6 || _temNumStr1.length != 6){
       
        return;
    }else if ([_temNumStr isEqualToString:_temNumStr1]) {
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@%@",[UtilTool getCustomId],[_temNumStr MD5],SECRET_KEY] MD5];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(resetPayPassword),[UtilTool getCustomId],[_temNumStr MD5],Summary];
        [NetWorkEngine getRequestUse:(self) WithURL:urlStr WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:@"1" forKey:@"pay_password"];
                [user synchronize];
                [UtilTool creatAlertController:self title:@"提示" describute:@"设置成功" sureClick:^{
                    [self.rt_navigationController popViewControllerAnimated:YES];
                } cancelClick:^{
                    
                }];
            }
        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
        
    }
    
}
- (void)createView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    _superView = [[UIView alloc]init];
    _superView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_superView];
    
    _textLable = [UtilTool createLabelFrame:CGRectZero title:@"通过办理车位手续时预留的手机号码进行短信验证" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentCenter numberOfLine:0];
    [_superView addSubview:_textLable];
    
    _codeField = [[UITextField alloc]init];
    _codeField.borderStyle = UITextBorderStyleNone;
    _codeField.textColor = [UIColor colorWithHexString:@"333333"];
    _codeField.tintColor = [UIColor colorWithHexString:@"39d5b8"];
    _codeField.textAlignment = NSTextAlignmentCenter;
    _codeField.placeholder = @"请输入短信验证码";
    [_superView addSubview:_codeField];
    
    _codeButton = [UtilTool createBtnFrame:CGRectZero title:@"获取验证码" bgColor:[UIColor whiteColor] textColor:[UIColor colorWithHexString:@"39d5b8"] textFont:12 target:self action:@selector(codeClick)];
    _codeButton.layer.cornerRadius = 4;
    _codeButton.clipsToBounds = YES;
    _codeButton.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
    _codeButton.layer.borderWidth = 1;
    [_superView addSubview:_codeButton];
    
    _tureButton = [UtilTool createBtnFrame:CGRectZero title:@"提交" bgColor:[UIColor colorWithHexString:@"39d5b8"] textColor:[UIColor whiteColor] textFont:15 target:self action:@selector(onTureClick1)];
    _tureButton.layer.cornerRadius = 5;
    _tureButton.clipsToBounds = YES;
    [_superView addSubview:_tureButton];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [_superView addSubview:_lineView];
    
    [_superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(126);
    }];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.centerX.mas_equalTo(_superView);
        make.height.mas_equalTo(21);
    }];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_superView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(170);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_superView);
        make.top.mas_equalTo(80);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(1);
    }];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_codeField.mas_centerY);
        make.left.mas_equalTo(_codeField.mas_right).offset(0);
        make.right.mas_equalTo(_superView.mas_right).offset(-8);
        make.height.mas_equalTo(25);
        
    }];
    
    [_tureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_superView);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(144);
    }];
    
    
}
- (void)onTureClick1{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:KCUSTOMER_MOBILE];
    
    [_codeField resignFirstResponder];
    if (_codeField.text.length == 4){
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        _codeButton.enabled = YES;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        _codeButton.layer.borderColor = [UIColor colorWithHexString:@"39D5B8"].CGColor;
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@%@",phoneNume,_codeField.text,SECRET_KEY] MD5];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",APP_URL(validatecode),phoneNume,_codeField.text,Summary];
        [NetWorkEngine getRequestUse:(self) WithURL:urlStr WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = responseObject;
            if ([dic[@"errorNum"] isEqualToString:@"0"])
            {
                
                _superView.hidden = YES;
                [self createPassWordView];
            }
        } error:^(NSString *error) {
            
        } failure:^(NSString *fail) {
            
        }];
    }else{
        
    }
    
    
}
#pragma mark -
#pragma mark - 发送验证码
- (void)codeClick{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:KCUSTOMER_MOBILE];
    NSString *Summary = [[NSString stringWithFormat:@"%@%@",phoneNume,SECRET_KEY] MD5];
    NSDictionary *paramDic = @{KCUSTOMER_MOBILE:phoneNume,@"summary":Summary};
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(sendSmsCode),paramDic[KCUSTOMER_MOBILE],paramDic[@"summary"]];
    _getCodeCount = 60;
    [NetWorkEngine getRequestUse:(self) WithURL:urlStr WithDic:nil needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"errorNum"] isEqualToString:@"0"])
        {
           
            _textLable.text = [NSString stringWithFormat:@"已发送短信至您尾号%@的手机",[phoneNume substringFromIndex:7]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_textLable.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"39d5b8"] range:NSMakeRange(9,4)];
            
            _textLable.attributedText = str;
            
            _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefresh) userInfo:nil repeats:YES];
            [_buttonTimer fire];
            
        }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}
- (void)ButtonTitleRefresh
{
    [_codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _codeButton.enabled = NO;
    _codeButton.titleLabel.text = [NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount];
   _codeButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    [_codeButton setTitle:[NSString stringWithFormat:@"重新获取(%ld)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        _codeButton.enabled = YES;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        _codeButton.layer.borderColor = [UIColor colorWithHexString:@"39D5B8"].CGColor;
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- NumberKeyBoardDelegate
- (void)numberKeyBoardChange:(NSString *)number
{
    if (_istextField == NO) {
    if (!_temNumStr) {
        _temNumStr = [NSMutableString string];
    }
    if (![UtilTool isBlankString:number]) {
        if (_temNumStr.length < 6) {
            [_temNumStr appendString:number];
        }

    }else
    {
        if (_temNumStr.length > 0) {
            [_temNumStr deleteCharactersInRange:NSMakeRange(_temNumStr.length-1, 1)];
        }
    }
    _faytextField.text = _temNumStr;
    }else{
        if (!_temNumStr1) {
            _temNumStr1 = [NSMutableString string];
        }
        if (![UtilTool isBlankString:number]) {
            if (_temNumStr1.length < 6) {
                [_temNumStr1 appendString:number];
            }
           
        }else
        {
            if (_temNumStr1.length > 0) {
                [_temNumStr1 deleteCharactersInRange:NSMakeRange(_temNumStr1.length-1, 1)];
            }
        }
        _faytextField1.text = _temNumStr1;
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _faytextField) {
        _istextField = NO;
        _faytextField.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
        _faytextField1.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        
    }else{
        _istextField = YES;
        _faytextField.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        _faytextField1.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
    }
    _faytextField.text = _temNumStr;
    _faytextField1.text = _temNumStr1;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _faytextField.text = _temNumStr;
    _faytextField1.text = _temNumStr1;
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
