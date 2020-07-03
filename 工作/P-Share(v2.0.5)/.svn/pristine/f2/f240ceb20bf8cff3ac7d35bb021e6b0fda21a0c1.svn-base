//
//  UINavigationController+Swizzling.m
//  P-Share
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "UINavigationController+Swizzling.h"
#import "UserViewController.h"
#import "CarLifeVC.h"
@implementation UINavigationController (Swizzling)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalPushSelector = @selector(pushViewController:animated:);
        SEL swizzledPushSelector = @selector(fay_pushViewController:animated:);
        Method originalPushMethod = class_getInstanceMethod(class, originalPushSelector);
        Method swizzledPushMethod = class_getInstanceMethod(class, swizzledPushSelector);
        BOOL didAddPushMethod = class_addMethod(class, originalPushSelector, method_getImplementation(swizzledPushMethod), method_getTypeEncoding(swizzledPushMethod));
        
        
        if (didAddPushMethod) {
            class_replaceMethod(class, swizzledPushSelector, method_getImplementation(originalPushMethod), method_getTypeEncoding(originalPushMethod));
        }else
        {
            method_exchangeImplementations(originalPushMethod, swizzledPushMethod);
        }

    });
}
- (void)fay_pushViewController:(UIViewController *)toVC animated:(BOOL)animated
{
    if ([toVC isKindOfClass:[NewMapHomeVC class]] ||[toVC isKindOfClass:[CarLifeVC class]] ||[toVC isKindOfClass:[UserViewController class]]) {
        
    }else
    {
        toVC.hidesBottomBarWhenPushed = YES;

    }
    [self fay_pushViewController:toVC animated:YES];
}
@end
