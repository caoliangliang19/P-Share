//
//  AppDelegate+JPush.m
//  P-SHARE
//
//  Created by fay on 16/9/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate()<JPUSHRegisterDelegate>
@end
@implementation AppDelegate (JPush)
-(void)setupJPushWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        
        [JPUSHService registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge |
                                                          UNAuthorizationOptionSound |
                                                          UNAuthorizationOptionAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            MyLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            MyLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
