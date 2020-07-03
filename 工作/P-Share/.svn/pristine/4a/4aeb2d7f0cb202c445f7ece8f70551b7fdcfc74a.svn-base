//
//  RTRootNavigationController+Swizzling.m
//  P-SHARE
//
//  Created by 亮亮 on 16/12/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RTRootNavigationController+Swizzling.h"
#import "UIViewController+Swizzling.h"

@implementation RTRootNavigationController (Swizzling)
+ (void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // Pop
        SEL originalPopSelector = @selector(popViewControllerAnimated:);
        SEL swizzledPopSelector = @selector(fay_popViewControllerAnimated:);
        
        Method originalPopMethod = class_getInstanceMethod(class, originalPopSelector);
        Method swizzledPopMethod = class_getInstanceMethod(class, swizzledPopSelector);
        BOOL didAddPopMethod = class_addMethod(class, originalPopSelector, method_getImplementation(swizzledPopMethod), method_getTypeEncoding(swizzledPopMethod));
        
        
        if (didAddPopMethod) {
            class_replaceMethod(class, swizzledPopSelector, method_getImplementation(originalPopMethod), method_getTypeEncoding(originalPopMethod));
        }else
        {
            method_exchangeImplementations(originalPopMethod, swizzledPopMethod);
        }
        // push
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

- (UIViewController *)fay_popViewControllerAnimated:(BOOL)animated{
    
    UIViewController *currentVC = [self fay_popViewControllerAnimated:animated];
    
    [currentVC cancelRequest];
    
    return currentVC;
}
- (void)fay_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    [self fay_pushViewController:viewController animated:YES];
    
}

@end
