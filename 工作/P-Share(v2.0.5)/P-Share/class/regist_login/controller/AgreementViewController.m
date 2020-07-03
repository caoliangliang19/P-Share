//
//  AgreementViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/10/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backView.backgroundColor = NEWMAIN_COLOR;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement.txt" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.myWebView.scalesPageToFit = YES;
    
    [self.myWebView loadData:data MIMEType:@"text/plain" textEncodingName:@"UTF-8" baseURL:nil];
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
