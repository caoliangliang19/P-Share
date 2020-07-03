//
//  AppDelegate.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+JPush.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>
#import "QYSDK.h"
#import "WechatTool.h"
#import "QQTool.h"
#import "JPUSHService.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self setNavigationBarStyle];
    [self loadIQKeyboardManager];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self asyncLoadThirdParty];
    });
    [self setupUMeng];
    [self setupJPushWithOptions:launchOptions];
    return YES;
}

- (void)setNavigationBarStyle
{

    UINavigationBar *bar = [UINavigationBar appearance];
    bar.translucent = NO;
    [bar setShadowImage:[[UIImage alloc] init]];
    bar.barTintColor = KMAIN_COLOR;
    [bar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    bar.tintColor = [UIColor whiteColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

}

- (void)asyncLoadThirdParty
{
    [UtilTool isVisitor];
    //注册微信
    [WXApi registerApp:WECHAT_APPKEY withDescription:@"口袋停"];
    //注册七鱼云
    [[QYSDK sharedSDK] registerAppId:@"63da89e3c116e0812685e9a7e37ef05d "
                             appName:@"pshare"];
    
}

- (void)loadIQKeyboardManager
{
    //    初始化IQKeyboardManager
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.toolbarDoneBarButtonItemText =@"完成";
    manager.keyboardAppearance = UIKeyboardAppearanceDefault;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = YES;
    manager.toolbarTintColor = KMAIN_COLOR;
    [manager disableToolbarInViewControllerClass:[NSClassFromString(@"CarLifeVC") class]];
    [manager disableToolbarInViewControllerClass:[NSClassFromString(@"MapSearchViewController") class]];

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:WECHAT_APPKEY]) {
        WechatTool *wechatTool = [[WechatTool alloc] init];
        return [WXApi handleOpenURL:url delegate:wechatTool];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQ_APPKEY]]) {
        QQTool *qqTool = [[QQTool alloc] init];
        if ([TencentOAuth HandleOpenURL:url]) {
            return [TencentOAuth HandleOpenURL:url];
        }else
        {
            return [QQApiInterface handleOpenURL:url delegate:qqTool];
        }
    }else {
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:WECHAT_APPKEY]) {
        WechatTool *wechatTool = [[WechatTool alloc] init];
        return [WXApi handleOpenURL:url delegate:wechatTool];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQ_APPKEY]]) {
        QQTool *qqTool = [[QQTool alloc] init];
        if ([TencentOAuth HandleOpenURL:url]) {
            return [TencentOAuth HandleOpenURL:url];
        }else
        {
            return [QQApiInterface handleOpenURL:url delegate:qqTool];
        }
    }else if ([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    return YES;
    
}
// 如果app在前台运行，系统收到推送时会调用该方法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    
}
// 不管app是在前台运行还是在后台运行，系统收到推送时都会调用该方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    MyLog(@"iOS7及以上系统，收到通知:%@",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
    MyLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    MyLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "p-share.P_SHARE" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"P_SHARE" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"P_SHARE.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
