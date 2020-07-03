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
    if ([self isKindOfClass:[UINavigationController class]]  || [self isKindOfClass:[UITabBarController class]] || [self isKindOfClass:NSClassFromString(@"UIInputWindowController")]||[self isKindOfClass:[RTRootNavigationController class]]||[self isKindOfClass:NSClassFromString(@"MainViewController")]||[self isKindOfClass:NSClassFromString(@"RTContainerNavigationController")]||[self isKindOfClass:NSClassFromString(@"RTContainerController")]||[self isKindOfClass:NSClassFromString(@"ViewController")]) {
        
    }else
    {
        if ([self isKindOfClass:NSClassFromString(@"QYSessionViewController")]) {
            [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
            
        }
        [MobClick beginLogPageView:NSStringFromClass(self.class)];
    }
    MyLog(@"%@  -->fay_viewWillAppear",NSStringFromClass(self.class));

    [self fay_viewWillAppear:YES];
    
}
- (void)fay_viewDidDisappear:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]]  || [self isKindOfClass:[UITabBarController class]] || [self isKindOfClass:NSClassFromString(@"UIInputWindowController")]||[self isKindOfClass:[RTRootNavigationController class]]||[self isKindOfClass:NSClassFromString(@"MainViewController")]||[self isKindOfClass:NSClassFromString(@"RTContainerNavigationController")]||[self isKindOfClass:NSClassFromString(@"RTContainerController")]||[self isKindOfClass:NSClassFromString(@"ViewController")]) {
        
    }else
    {
        if ([self isKindOfClass:NSClassFromString(@"QYSessionViewController")]) {
            [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
            [IQKeyboardManager sharedManager].enable = YES;
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        }
       
        [MobClick endLogPageView:NSStringFromClass(self.class)];
        MyLog(@"%@  -->fay_viewDidDisappear",NSStringFromClass(self.class));
    }
  
    [self fay_viewDidDisappear:YES];

}


- (void)addTask:(NSURLSessionDataTask *)task
{
    NSMutableDictionary *taskQueue = [self taskQueue];
    [taskQueue setObject:task forKey:@(task.taskIdentifier)];
}
- (void)removeTask:(NSURLSessionDataTask *)task
{
    if ([self hasRequestQueue]) {
        NSMutableDictionary *taskQueue = [self taskQueue];
        [taskQueue removeObjectForKey:@(task.taskIdentifier)];
    }
}
- (NSMutableDictionary *)taskQueue
{
    NSMutableDictionary *taskQueue = objc_getAssociatedObject(self, @selector(addTask:));
    if (!taskQueue) {
        taskQueue =@{}.mutableCopy;
        objc_setAssociatedObject(self, @selector(addTask:), taskQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskQueue;

}
- (BOOL)hasRequestQueue
{
    NSMutableDictionary *taskQueue = [self taskQueue];
    if (taskQueue.allValues.count > 0) {
        return YES;
    }
    return NO;
}
- (void)cancelRequest
{
    if ([self hasRequestQueue]) {
        NSMutableDictionary *taskQueue = [self taskQueue];
        [taskQueue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLSessionDataTask *task = (NSURLSessionDataTask *)obj;
            if (task.state != NSURLSessionTaskStateCompleted ) {
                [task cancel];
                MyLog(@"取消了一个请求");
            }
        }];
        [taskQueue removeAllObjects];
    }
}
@end
