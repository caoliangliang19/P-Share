//
//  ImageViewAddProgress.m
//  P-SHARE
//
//  Created by fay on 2016/11/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ImageViewAddProgress.h"
@interface ImageViewAddProgress()
{
    CGFloat _circleRadius;
    
}
@property (nonatomic,strong)CAShapeLayer *circleLayer;
@end
@implementation ImageViewAddProgress
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self config];

}
- (instancetype)init
{
    if (self == [super init]) {
        [self config];
    }
    return self;
    
}

- (void)config{
    [self layoutIfNeeded];
    if (!_circleLayer) {
        _circleRadius = 20.0;
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.lineWidth = 4;
        _circleLayer.lineJoin = kCALineJoinRound;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.strokeColor = KMAIN_COLOR.CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeStart = 0;
        _circleLayer.strokeEnd = 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self circleFrame]];
        _circleLayer.path = path.CGPath;
        [self.layer addSublayer:_circleLayer];
        self.backgroundColor = [UIColor whiteColor];
    }
   
}

- (CGRect)circleFrame{
    CGRect rect = CGRectMake(0, 0, 2*_circleRadius, 2*_circleRadius);
    rect.origin.x = CGRectGetMidX(_circleLayer.bounds) - CGRectGetMidX(rect);
    rect.origin.y = CGRectGetMidY(_circleLayer.bounds) - CGRectGetMidY(rect);
//    rect.size.width = 2*_circleRadius;
//    rect.size.height = 2*_circleRadius;
    return rect;
}
- (void)setLoadProgerss:(CGFloat)loadProgerss
{
    [self config];
    MyLog(@"loadProgerss  %lf",loadProgerss);
    _loadProgerss = loadProgerss;
    [UIView animateWithDuration:0.4 animations:^{
        _circleLayer.strokeEnd = loadProgerss;

    }completion:^(BOOL finished) {
        if (loadProgerss >= 1) {
            [_circleLayer removeFromSuperlayer];
        }
    }];

    
}
@end
