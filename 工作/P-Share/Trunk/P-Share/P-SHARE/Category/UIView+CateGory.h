//
//  UIView+CateGory.h
//  KouDaiYun
//
//  Created by fay on 16/8/17.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CateGory)
/**
 *  画一条线
 */
+ (nonnull UIView *)createLineViewWithColor:(nonnull UIColor *)color;
/**
 *  获取ViewCotroll
 */
- (nullable UIViewController *)viewController;
/**
 *  剪圆角
 */
- (void)clipsToRadius:(CGFloat)radius;

@end
