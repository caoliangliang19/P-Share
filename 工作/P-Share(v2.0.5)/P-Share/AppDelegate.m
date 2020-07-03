//
//  AppDelegate.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstNavController.h"
#import "FirstViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WeiboSDK.h"
#import "JPUSHService.h"
#import <AVFoundation/AVFoundation.h>
#import <Bugly/CrashReporter.h>


#import <TencentOpenAPI/TencentOAuth.h>
#import "QYSDK.h"


@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setUpNavBar];
    
    [[QYSDK sharedSDK] registerAppId:@"63da89e3c116e0812685e9a7e37ef05d "
                             appName:@"pshare"];
//    友盟统计相关
//#if DEBUG
//    [MobClick setLogEnabled:YES];

//#else
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setCrashReportEnabled:NO];
    //    [MobClick beginEvent:@"CollectListID"];
    [MobClick startSession:nil];
    [MobClick startWithAppkey:@"56aecf9de0f55a5cf0002dcd" reportPolicy:BATCH  channelId:nil];
    [MobClick setLogEnabled:NO];
//#endif
    
    
    
    //    初始化bugly
    [[CrashReporter sharedInstance] installWithAppId:@"900018387"];
    //    [[CrashReporter sharedInstance]enableLog:YES];
    //设置状态栏字体为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //注册微信
    [WXApi registerApp:@"wx7248073ee8171c2b" withDescription:@"口袋停"];
    //注册微博
//    [WeiboSDK registerApp:@"685997871"];
        [WeiboSDK registerApp:@"3781504378"];


    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    FirstViewController *firstVC = [[FirstViewController alloc] init];
    
    self.window.rootViewController = firstVC;
    [self.window makeKeyAndVisible];
   
    
    // Required----推送相关
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    
    return YES;
}

- (void)setUpNavBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = NEWMAIN_COLOR;

    bar.tintColor = [UIColor whiteColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
}

- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

//推送相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    NSString *info = userInfo[@"aps"][@"alert"];
//    
//    MyLog(@"推送内容：＊＊＊＊%@",info);
//    
//    NSString *key = userInfo[@"VC"];
//    
//    MyLog(@"key:***%@",key);
    
}



//微信支付回调
-(void) onResp:(BaseResp*)resp
{
    MyLog(@"%d",resp.errCode);
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        MyLog(@"分享成功");
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
                MyLog(@"---微信--支付成功");
                NSNotification *notification = [NSNotification notificationWithName:self.payResultType object:@"success"];
                if (notification) {
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                
                break;
            }
            default:{
                MyLog(@"---微信--支付失败");
                NSNotification *notification = [NSNotification notificationWithName:self.payResultType object:@"fail"];
                if (notification) {
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                
                         
                break;
            }
        }
    }
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
//                        [self getAccess_token:dic[@"code"]];
        }
    }
}

//微博分享回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    MyLog(@"weobo1");
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    MyLog(@"%@",response);
//
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if ((int)response.statusCode == 0) {
            NSDictionary *dic = @{@"userID":[(WBAuthorizeResponse *)response userID],
                                  @"accessToken" :[(WBAuthorizeResponse *)response accessToken]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SinaLogin" object:dic];
        }
    }
}

//支付宝支付回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    
    [WXApi handleOpenURL:url delegate:self];

    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        [WeiboSDK handleOpenURL:url delegate:self];
    }else
    {
        [TencentOAuth HandleOpenURL:url];

    }

    return YES;
}

#pragma mark --QQ登录相关
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
//    通知webView刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webView" object:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    MyLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

 
@end








