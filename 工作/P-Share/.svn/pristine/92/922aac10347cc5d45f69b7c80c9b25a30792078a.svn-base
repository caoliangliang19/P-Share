//
//  QiYuTool.m
//  P-SHARE
//
//  Created by fay on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "QiYuTool.h"
#import "QYSDK.h"
@interface QiYuTool()
{
    QYSessionViewController *_sessionViewController;
}
@end
@implementation QiYuTool
- (void)goToCustomerServiceSessionVC:(UIViewController *)fromVC
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  [[NSUserDefaults standardUserDefaults] objectForKey:KCUSTOMER_NICKNAME];
    
    QYUserInfo *user = [[QYUserInfo alloc] init];
    user.userId = [UtilTool getCustomId];
    [[QYSDK sharedSDK] setUserInfo:user];
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    QYCustomUIConfig *custom = [[QYSDK sharedSDK] customUIConfig];
    
    sessionViewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onBack:)];
    
    NSString *imageString = [[NSUserDefaults standardUserDefaults]  objectForKey:KHEADIMG_URL];
    UIImageView *temImgV = [[UIImageView alloc] init];
    [temImgV sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHeaderImage"]];
    custom.customerHeadImage = temImgV.image;
    custom.serviceHeadImage = [UIImage imageNamed:@"logoPshare"];
    
#warning sessionVC.groupId
//    sessionVC.groupId = [[DataSource shareInstance].qiyuId intValue];

    sessionViewController.sessionTitle = @"口袋停客服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [fromVC.rt_navigationController pushViewController:sessionViewController animated:YES complete:nil];
    
}
- (void)onBack:(id)sender
{
    [self.rt_navigationController popViewControllerAnimated:YES];
    
}

@end
