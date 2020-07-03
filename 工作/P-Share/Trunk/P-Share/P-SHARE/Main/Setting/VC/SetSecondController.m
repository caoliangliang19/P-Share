//
//  SetSecondController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "SetSecondController.h"
#import "LoginVC.h"

@interface SetSecondController ()<UITextViewDelegate>
{
    UITextView *_adviceView;
    UIButton *_tureBtn;
    
    UIImageView *_logoImageView;
    UILabel *_editionL;
    UILabel *subtitleL;
    
     NSInteger _i;
}
@end

@implementation SetSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)setState:(CLLSetControllerState)state{
    _state = state;
}
- (void)createUI{
    if (_state == CLLSetControllerStateAdvice) {
        self.title = @"意见反馈";
        [self createAdviceUI];
    }else if (_state == CLLSetControllerStateWe){
        self.title = @"关于我们";
        [self createWeUI];
    }else{
        _i = 0;
        self.navigationController.navigationBar.hidden = YES;
        [self createHelpView];
    }
}
#pragma mark - 意见反馈
- (void)createAdviceUI{
    _adviceView = [[UITextView alloc]init];
    _adviceView.text = @"非常感谢您的意见......";
    _adviceView.textColor = [UIColor lightGrayColor];
    _adviceView.font = [UIFont systemFontOfSize:14];
    _adviceView.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    _adviceView.layer.borderWidth = 1.0f;
    _adviceView.layer.cornerRadius = 5;
    _adviceView.delegate = self;
    _adviceView.clipsToBounds = YES;
    [self.view addSubview:_adviceView];

    _tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tureBtn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [_tureBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [_tureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _tureBtn.layer.cornerRadius = 5;
    _tureBtn.clipsToBounds = YES;
    [_tureBtn addTarget:self action:@selector(onTureClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_tureBtn];
    
    [_adviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(150);
    }];
    [_tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_adviceView.mas_bottom).offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(43);
    }];
}
- (void)onTureClick{
    [_adviceView resignFirstResponder];
    
    if ([_adviceView.text isEqualToString:@"非常感谢您的意见......"]) {
//        ALERT_VIEW(@"请给出您合理的意见");
        [self createAlertController:@"请给出您合理的意见"];
        return;
    }
    if ([UtilTool isBlankString:_adviceView.text] == YES) {
//        ALERT_VIEW(@"输入文字不能为空");
         [self createAlertController:@"输入文字不能为空"];
        return;
    }
    __block UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:@"customerId"];
    if([UtilTool isBlankString:userId] == YES){
//        LoginVC *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
//        [self.rt_navigationController pushViewController:login animated:YES complete:nil];

        return;
    }
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:_adviceView.text,@"commitInfo",userId,@"customerId",@"2.0.2",@"version", nil];
    NSString *urlString = [APP_URL(CommitApp) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWorkEngine postRequestUse:(self) WithURL:urlString WithDic:paramDic needEncryption:YES needAlert:NO showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"errorNum"] isEqualToString:@"0"])
        {
            [tipAlert show];
            tipAlert = nil;
        }else{

        }
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_adviceView resignFirstResponder];
}

//UITextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"非常感谢您的意见......"]) {
        textView.text = @"";
    }
    _adviceView.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"非常感谢您的意见......";
        _adviceView.textColor = [UIColor lightGrayColor];
    }
}
#pragma mark - 关于我们
- (void)createWeUI{
    _logoImageView = [[UIImageView alloc]init];
    _logoImageView.image = [UIImage imageNamed:@"IconLogo"];
    [self.view addSubview:_logoImageView];
    
    _editionL = [[UILabel alloc]init];
    _editionL.textAlignment = NSTextAlignmentCenter;
    _editionL.font = [UIFont systemFontOfSize:17];
    _editionL.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    _editionL.text = [NSString stringWithFormat:@"版本:%@",currentVersion];
    [self.view addSubview:_editionL];
    
    subtitleL = [[UILabel alloc]init];
    subtitleL.textAlignment = NSTextAlignmentCenter;
    subtitleL.font = [UIFont systemFontOfSize:15];
    subtitleL.numberOfLines = 0;
    subtitleL.text = @"我们致力于帮助千万用户解决找停车位难的问题,客服联系方式：400-006-2637";
    subtitleL.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    [self.view addSubview:subtitleL];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.height.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view);
    }];
    [_editionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.view);
    }];
    [subtitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_editionL.mas_bottom).offset(60);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}
#pragma mark - 帮助说明
- (void)createHelpView{
    _logoImageView = [[UIImageView alloc]init];
    _logoImageView.userInteractionEnabled = YES;
    _logoImageView.image = [UIImage imageNamed:@"p1"];
    [self.view addSubview:_logoImageView];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTap)];
    [_logoImageView addGestureRecognizer:tap];
    
}
- (void)onClickTap{
    _i++;
    if (_i==1) {
        _logoImageView.image = [UIImage imageNamed:@"p2"];
    }else if (_i == 2){
        _logoImageView.image = [UIImage imageNamed:@"p3"];
    }else if (_i == 3){
        _logoImageView.image = [UIImage imageNamed:@"p4"];
    }else if (_i == 4){
        _logoImageView.image = [UIImage imageNamed:@"p5"];
    }else if (_i == 5){
        _logoImageView.image = [UIImage imageNamed:@"p6"];
    }else if (_i == 6){
        _logoImageView.image = [UIImage imageNamed:@"p7"];
    }else{
        self.navigationController.navigationBar.hidden = NO;
        [self.rt_navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIAlertController *)createAlertController:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
    
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
