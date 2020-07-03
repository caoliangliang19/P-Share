//
//  UIViewController+Swizzling.m
//  P-Share
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzling)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalAppearSelector = @selector(viewWillAppear:);
        SEL swizzledAppearSelector = @selector(fay_viewWillAppear:);
        Method originalAppearMethod = class_getInstanceMethod(class, originalAppearSelector);
        Method swizzledAppearMethod = class_getInstanceMethod(class, swizzledAppearSelector);
        BOOL didAddAppearMethod = class_addMethod(class, originalAppearSelector, method_getImplementation(swizzledAppearMethod), method_getTypeEncoding(swizzledAppearMethod));
        
        
        if (didAddAppearMethod) {
            class_replaceMethod(class, swizzledAppearSelector, method_getImplementation(originalAppearMethod), method_getTypeEncoding(originalAppearMethod));
        }else
        {
            method_exchangeImplementations(originalAppearMethod, swizzledAppearMethod);
        }

        
        
        SEL originalDidDisappearSelector = @selector(viewDidDisappear:);
        SEL swizzledDidDisappearSelector = @selector(fay_viewDidDisappear:);
        
        Method originalDidDisappearMethod = class_getInstanceMethod(class, originalDidDisappearSelector);
        Method swizzledDidDisappearMethod = class_getInstanceMethod(class, swizzledDidDisappearSelector);
        
       
        BOOL didAddDidDisappearMethod = class_addMethod(class, originalDidDisappearSelector, method_getImplementation(swizzledDidDisappearMethod), method_getTypeEncoding(swizzledAppearMethod));
        
        
        if (didAddDidDisappearMethod) {
            class_replaceMethod(class, swizzledDidDisappearSelector, method_getImplementation(originalDidDisappearMethod), method_getTypeEncoding(originalDidDisappearMethod));
        }else
        {
            method_exchangeImplementations(originalDidDisappearMethod, swizzledDidDisappearMethod);
        }

        
        
    });
}
- (void)fay_viewWillAppear:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]]  || [self isKindOfClass:[UITabBarController class]] || [self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        
        
    }else
    {
        [MobClick beginLogPageView:NSStringFromClass(self.class)];
        MyLog(@"%@  -->fay_viewWillAppear",NSStringFromClass(self.class));
    }
    [self fay_viewWillAppear:YES];
    
}
- (void)fay_viewDidDisappear:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]]  || [self isKindOfClass:[UITabBarController class]] ||[self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        
        
    }else
    {
        [MobClick endLogPageView:NSStringFromClass(self.class)];
        MyLog(@"%@  -->fay_viewDidDisappear",NSStringFromClass(self.class));
    }
  
    [self fay_viewDidDisappear:YES];

}
@end
