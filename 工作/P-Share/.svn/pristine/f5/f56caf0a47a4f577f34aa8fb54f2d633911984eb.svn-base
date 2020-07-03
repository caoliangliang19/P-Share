//
//  UIView+CateGory.m
//  KouDaiYun
//
//  Created by fay on 16/8/17.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "UIView+CateGory.h"

@implementation UIView (CateGory)
+ (nonnull UIView *)createLineViewWithColor:(nonnull UIColor *)color
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = color;
    return lineView;
}

- (nullable UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}
- (void)clipsToRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
