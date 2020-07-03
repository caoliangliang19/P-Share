//
//  demoView.m
//  BezierPath_fay
//
//  Created by fay on 16/7/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TitleView.h"
#define SCREEN   [UIScreen mainScreen].bounds.size

@implementation TitleView

//  h:66 l:screen.width

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setLayerWithRect:frame];
    }
    
    return self;
    
}

- (void)setLayerWithRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 3;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    CGFloat smallWidth = 60;
    
    CGFloat smallHeight = 10;
    
    CGFloat corner = 8;
        
    //    起点
    [path moveToPoint:CGPointMake(0, height)];
    
    [path addLineToPoint:CGPointMake(0, corner + smallHeight)];
    
    [path addQuadCurveToPoint:CGPointMake(corner,  smallHeight) controlPoint:CGPointMake(0, smallHeight)];
    
    [path addLineToPoint:CGPointMake((width-smallWidth)/2, smallHeight)];
    
    [path addLineToPoint:CGPointMake((width-smallWidth)/2, smallHeight)];
    
    
    [path addLineToPoint:CGPointMake((width-smallWidth)/2+8, 0)];
    
    [path addLineToPoint:CGPointMake((width-smallWidth)/2+smallWidth - 8, 0)];
    
    [path addLineToPoint:CGPointMake((width-smallWidth)/2+smallWidth, smallHeight)];
    
    
    [path addLineToPoint:CGPointMake(width-corner, smallHeight)];
    
    [path addQuadCurveToPoint:CGPointMake(width,  corner + smallHeight) controlPoint:CGPointMake(width, smallHeight)];
    
    [path addLineToPoint:CGPointMake(width, height)];
    
    [path closePath];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//    shapeLayer.fillColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.center = CGPointMake(SCREEN_WIDTH/2-10, 10);
    imageV.bounds = CGRectMake(0, 0, 20, 15);
    imageV.image = [UIImage imageNamed:@"btnIco_v2"];
    [self addSubview:imageV];
}

@end
