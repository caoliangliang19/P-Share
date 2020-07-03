//
//  UIView+fayAdd.m
//  P-Share
//
//  Created by fay on 16/8/2.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "UIView+fayAdd.h"

@implementation UIView (fayAdd)

@end
@implementation UIView (FindViewController)

- (nullable UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}

@end
