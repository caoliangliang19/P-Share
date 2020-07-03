//
//  UIView+Extension.m
//  SinaWeibo
//
//  Created by chensir on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setK_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setK_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)K_x
{
    return self.frame.origin.x;
}

- (CGFloat)K_y
{
    return self.frame.origin.y;
}

- (void)setK_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)K_centerX
{
    return self.center.x;
}

- (void)setK_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)K_centerY
{
    return self.center.y;
}

- (void)setK_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setK_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)K_height
{
    return self.frame.size.height;
}

- (CGFloat)K_width
{
    return self.frame.size.width;
}

- (void)setK_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)K_size
{
    return self.frame.size;
}

- (void)setK_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)K_origin
{
    return self.frame.origin;
}

@end
