//
//  AppDelegate+UMeng.m
//  P-SHARE
//
//  Created by fay on 16/9/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AppDelegate+UMeng.h"

@implementation AppDelegate (UMeng)
-(void)setupUMeng{
    
    //友盟
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    //因为友盟注册应用没有添加bundleID的字段，所以这里添加判断，以免别的项目也进行操作
    if ([bundleID isEqualToString:@"com.boxiang.kodaiting"]) {
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        [MobClick setCrashReportEnabled:YES];
        UMConfigInstance.appKey = @"56aecf9de0f55a5cf0002dcd";
        UMConfigInstance.ePolicy = REALTIME;
        UMConfigInstance.channelId = @"App Store";
        [MobClick startWithConfigure:UMConfigInstance];
        
    
#if DEBUG
        
        [MobClick setLogEnabled:YES];
#else
        
        [MobClick setLogEnabled:NO];
#endif
    }
    
    
    
    
 }

@end
