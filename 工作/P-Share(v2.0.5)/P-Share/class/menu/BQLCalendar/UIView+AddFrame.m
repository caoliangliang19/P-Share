//
//  UIView+AddFrame.m
//  P-Share
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "UIView+AddFrame.h"

@implementation UIView (AddFrame)
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setAddLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)Addtop {
    return self.frame.origin.y;
}

- (void)setAddTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)Addright {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setAddRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)Addbottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setAddBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)Addwidth {
    return self.frame.size.width;
}

- (void)setAddWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)Addheight {
    return self.frame.size.height;
}

- (void)setAddHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)AddcenterX {
    return self.center.x;
}

- (void)setAddCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)AddcenterY {
    return self.center.y;
}

- (void)setAddCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)Addorigin {
    return self.frame.origin;
}

- (void)setAddOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)Addsize {
    return self.frame.size;
}

- (void)setAddSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
