//
//  AdviceViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/8.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AdviceViewController.h"

@interface AdviceViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIAlertView *_alert;
}
@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.adviceTextView.layer.borderWidth = 0.5;
    self.adviceTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.adviceTextView.layer.cornerRadius = 4;
    self.adviceTextView.layer.masksToBounds = YES;
    
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.backgroundColor = NEWMAIN_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.adviceTextView resignFirstResponder];
}

//UITextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"非常感谢您的意见......"]) {
        textView.text = @"";
    }
    self.adviceTextView.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"非常感谢您的意见......";
        self.adviceTextView.textColor = [UIColor lightGrayColor];
    }
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

- (IBAction)submitBtnClick:(id)sender {
    [self.adviceTextView resignFirstResponder];
    
    if ([self.adviceTextView.text isEqualToString:@"非常感谢您的意见......"]) {
        ALERT_VIEW(@"请给出您合理的意见");
        return;
    }
    
    __block UIAlertView *tipAlert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //---------------------------网路----订单评价
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.adviceTextView.text,@"commitInfo",userId,@"customerId",@"2.0.2",@"version", nil];

    
    NSString *urlString = [COMMITAPP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    RequestModel *model = [RequestModel new];
    [model postRequestWithURL:urlString WithDic:paramDic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *dict = responseObject;
        if ([dict[@"errorNum"] isEqualToString:@"0"])
        {
            [tipAlert show];
            tipAlert = nil;
        }else{
            ALERT_VIEW(dict[@"errorInfo"]);
            _alert = nil;
        }
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
//    [model getRequestWithURL:urlString WithDic:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dict = responseObject;
//            
//            if ([dict[@"code"] isEqualToString:@"000000"])
//            {
//                [tipAlert show];
//                tipAlert = nil;
//            }else{
//                ALERT_VIEW(dict[@"msg"]);
//                _alert = nil;
//            }
//        }
//
//    } error:^(NSString *error) {
//        
//    } failure:^(NSString *fail) {
//        
//    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end








