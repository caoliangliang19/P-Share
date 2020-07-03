//
//  ChangeInfoVC.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ChangeInfoVC.h"

@interface ChangeInfoVC ()

@end

@implementation ChangeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createNavigation];
}
- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor colorWithHexString:@"333333"];
    self.leftTitle = lable;
    [view addSubview:lable];
    
    UITextField *textfield = [[UITextField alloc]init];
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.font = [UIFont systemFontOfSize:15];
    self.serveField = textfield;
    [view addSubview:textfield];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(76);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(lable.mas_right).offset(40);
    }];
}

- (void)createNavigation{
    if (_state == CLLPushControllStateName) {
        self.leftTitle.text = @"昵称";
        self.serveField.placeholder = @"请输入昵称";
        self.title = @"昵称";
    }else if (_state == CLLPushControllStateCardID){
        self.leftTitle.text = @"身份证号";
        self.serveField.placeholder = @"请输入身份证号";
        self.title = @"身份证号";
    }
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    button.backgroundColor = [UIColor clearColor];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 0);
    [button setTitle:@"保存" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onRightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
- (void)setState:(CLLPushControllState)state{
    _state = state;
}
- (void)onRightClick{
    NSMutableDictionary *dict = nil;
    if (_state == CLLPushControllStateName) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.4",@"version",self.serveField.text,@"customerNickname", nil];
    }else if (_state == CLLPushControllStateCardID){
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.4",@"version",self.serveField.text,@"customerCardId", nil];
    }
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(updateCustomerInfo) WithDic:dict needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (_state == CLLPushControllStateName) {
                    [userDefaults setObject:dict[@"customerNickname"] forKey:@"customerNickname"];
        }else if (_state == CLLPushControllStateCardID){
                    [userDefaults setObject:dict[@"customerCardId"] forKey:@"customerCardId"];
        }
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomInfo" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    //上传信息
//#define updateCustomerInfo      YUFABU_TEST(@"other/customer/updateCustomerInfo")
//    [RequestModel requestDaiBoOrder:updateCustomerInfo WithType:@"UserInfo" WithDic:dict Completion:^(NSArray *dataArray) {
//        NSDictionary *dict = dataArray[0];
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        if (_state == CLLPushControllStateName) {
//            [userDefaults setObject:dict[@"customerNickname"] forKey:customer_nickname];
//        }else if (_state == CLLPushControllStateCardID){
//            [userDefaults setObject:dict[@"customerRegion"] forKey:customer_region];
//        }
//        [userDefaults synchronize];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomInfo" object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    } Fail:^(NSString *error) {
//        
//    }];
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

@end
