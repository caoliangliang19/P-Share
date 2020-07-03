//
//  phoneView.m
//  P-Share
//
//  Created by fay on 16/3/31.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "PhoneView.h"


@interface PhoneView()<UITextFieldDelegate>
{
    NSTimer     *_buttonTimer;
    int         _getCodeCount;
    GroupManage *_manage;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getTextCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation PhoneView
- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] lastObject];
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 280, 210);
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _manage = [GroupManage shareGroupManages];
    }
    return self;
}

- (void)setUserNickName:(NSString *)userNickName
{
    _userNickName = userNickName;
    _infoL.text = [NSString stringWithFormat:@"%@,为了更好的为您服务,使用本功能前请先绑定手机",userNickName];

    
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _backgroundView;
}
#pragma mark -
#pragma mark - view显示
- (void)show{
    [self.viewController.view addSubview:self.backgroundView];

    [self.viewController.view bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.66 initialSpringVelocity:1/0.66 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
#pragma mark -
#pragma mark - view消失
- (void)hide{
    if (_buttonTimer) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
    }
    
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _getCodeCount = 60;
    self.phoneNumTextField.delegate = self;
    self.textCodeTextField.delegate = self;
    self.mainView.layer.borderWidth = 1;
    self.mainView.layer.borderColor = [UIColor colorWithHexString:@"E1E1E1"].CGColor;
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    NSString *phoneNum =[NSString stringWithFormat:@"%@",self.phoneNumTextField.text];
    NSString *textCode = [NSString stringWithFormat:@"%@",self.textCodeTextField.text];
    if (phoneNum.length == 0&&textCode.length == 0) {
        [_manage groupAlertShowWithTitle:@"请输入手机号"];

        return;
    }
    if (!(phoneNum.length == 0)&&textCode.length == 0) {
        [_manage groupAlertShowWithTitle:@"请输入验证码"];

        return;
    }
    if (phoneNum.length == 0&&!(textCode.length == 0)) {
        [_manage groupAlertShowWithTitle:@"请输入手机号"];

        return;
    }
    if ([UtilTool isValidateTelNumber:self.phoneNumTextField.text])
    {
        if ([UtilTool isValidateSecurityCode:self.textCodeTextField.text])
        {
            _manage = [GroupManage shareGroupManages];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_manage.openid,@"quickId",_manage.loginType,@"quickType",self.phoneNumTextField.text,@"mobile",self.textCodeTextField.text,@"smsCode",@"ios",@"regPhone",@"2.0.1",@"version", nil];
            [self hide];
            if (self.nextBlock) {
                self.nextBlock(dict);
            }
            
        }else
        {
            [_manage groupAlertShowWithTitle:@"请输入正确验证码"];
        }
      
    }else
    {
        [_manage groupAlertShowWithTitle:@"请输入正确手机号"];
    }
}
- (IBAction)getYanZhengBtnClick:(UIButton *)sender {
    if ([UtilTool isValidateTelNumber:self.phoneNumTextField.text]) {
        sender.userInteractionEnabled = NO;
        
        NSString *Summary = [[NSString stringWithFormat:@"%@%@",self.phoneNumTextField.text,SECRET_KEY] MD5];
        
        NSDictionary *paramDic = @{@"customer_mobile":self.phoneNumTextField.text,@"summary":Summary};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",APP_URL(sendSmsCode),paramDic[@"customer_mobile"],paramDic[@"summary"]];
        [NetWorkEngine getRequestUse:(self) WithURL:urlStr WithDic:nil needAlert:YES showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            
            _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefreshForget) userInfo:nil repeats:YES];
            [_buttonTimer fire];
            
            
        } error:^(NSString *error) {
            MyLog(@"%@",error);
            sender.userInteractionEnabled = YES;

            
        } failure:^(NSString *fail) {
            MyLog(@"%@",fail);
            sender.userInteractionEnabled = YES;

        }];
    }else{
        [_manage groupAlertShowWithTitle:@"请输入正确手机号"];

        MyLog(@"请输入正确手机号");
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
        [self.getTextCodeBtn setTitleColor:KMAIN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self hide];
}


@end
