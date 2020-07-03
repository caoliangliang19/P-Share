//
//  AppDelegate.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderViewController.h"
static NSString *appKey = @"68d3b6ab608d1635d484267a";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) NSString *payResultType;

@property (nonatomic,copy) NSString *weiXinNotify_url;

@property (nonatomic,retain)NSTimer *timer;
@end

