//
//  ScanResultViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    MyLog(@"-----------%@----------",self.strScan);
    
    ALLOC_MBPROGRESSHUD;
    
    
    [self loadData];
}

- (void)loadData
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,@"vouchersname":self.strScan};
    
    NSString *urlString = [REXEIVEBYVOUCHERS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [RequestModel requestOrderPointWithUrl:urlString WithDic:paramDic Completion:^(NSDictionary *dic) {
        if ([dic[@"code"] isEqualToString:@"000000"])
        {
            
        }else{
            ALERT_VIEW(dic[@"msg"]);
            _alert = nil;
        }
        END_MBPROGRESSHUD;

    } Fail:^(NSString *errror) {
        END_MBPROGRESSHUD;
        ALERT_VIEW(errror);
        _alert = nil;

    }];
    
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
@end
