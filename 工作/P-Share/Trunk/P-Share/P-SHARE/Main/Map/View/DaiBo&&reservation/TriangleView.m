//
//  TriangleView.m
//  P-SHARE
//
//  Created by fay on 16/10/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
    
}
- (void)createTriangleView
{
    [self setLayerWithRect:self.frame];
    

}
- (void)setLayerWithRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    //    起点
    [path moveToPoint:CGPointMake(0, height/2)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, height)];
    [path closePath];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    //    shapeLayer.fillColor = [UIColor colorWithRed:0.52f green:0.76f blue:0.07f alpha:1.00f].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}


@end
