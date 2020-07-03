//
//  FayCollectionViewIndex.m
//  FayCollectionAddIndex
//
//  Created by fay on 16/7/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayCollectionViewIndex.h"
#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

@interface FayCollectionViewIndex ()
{
    BOOL                _isLayedOut;
    CAShapeLayer        *_shapeLayer;
    CGFloat             _letterHeight;
    
}
@end

@implementation FayCollectionViewIndex

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}

- (void)setDelegate:(id<FayCollectionViewIndexDelegate>)delegate
{
    _delegate = delegate;
//    如果设置为YES 就是裁剪掉超出layer的部分  设置圆角时需要用到
    _isLayedOut = NO;
    [self layoutSubviews];
    
}

/*---setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
 宗上所诉，setNeedsDisplay方便绘图，而layoutSubViews方便出来数据。
 
 因为这两个方法都是异步执行的，所以一些元素还是直接绘制的好---*/


/*---使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形---*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
    if (!_isLayedOut) {
//        移除self.layer上面的子layer
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        /*--绘制边框线部分--*/
        _shapeLayer.frame = CGRectMake(CGPointZero.x, CGPointZero.y, self.layer.frame.size.width, self.layer.frame.size.height);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
        
        /*--绘制文字部分--*/
        _letterHeight = 16;
        CGFloat fontSize = 12;
        [self.titleIndexs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat originY = idx * _letterHeight;
            CATextLayer *ctl = [self textLayerWithSize:fontSize string:obj andFrame:CGRectMake(0, originY, self.frame.size.width, _letterHeight)];
            
            [self.layer addSublayer:ctl];
            
            [path moveToPoint:CGPointMake(0, originY)];
            [path addLineToPoint:CGPointMake(ctl.frame.size.width, originY)];
            
            
        }];
        [path moveToPoint:CGPointMake(0, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        
        [path moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
//        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.width)];
        
        _shapeLayer.path = path.CGPath;
        
        if (_isFrameLayer) {
            [self.layer addSublayer:_shapeLayer];
        }
        _isLayedOut = YES;
        
    }
    
}

- (CATextLayer *)textLayerWithSize:(CGFloat)size string:(NSString *)string andFrame:(CGRect)frame
{
    CATextLayer *ctl = [CATextLayer layer];
    [ctl setFont:@"ArialMT"];
    [ctl setFontSize:size];
    [ctl setFrame:frame];
    [ctl setAlignmentMode:kCAAlignmentCenter];
    [ctl setContentsScale:[UIScreen mainScreen].scale];
    [ctl setForegroundColor:RGB(168, 168, 168, 1).CGColor];
    [ctl setString:string];
    return ctl;
    
}

- (void)setup
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.strokeEnd = 1.0f;
    _shapeLayer = shapeLayer;
    self.layer.masksToBounds = NO;
}


//根据触摸事件的触摸点计算出是第几个section
- (void)sendEventToDelegate:(UIEvent *)event
{
//    获得touch时间
    UITouch *touch = [[event allTouches] anyObject];
//    获取手指触摸点
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger)floorf(point.y) / _letterHeight);
    
    if (indx < 0 || indx > self.titleIndexs.count - 1) {
        return;
    }
    
    [self.delegate collectionViewIndex:self didSelectionAtIndex:indx withTitle:self.titleIndexs[indx]];
    
}

#pragma mark --- touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    [self.delegate collectionViewIndexTouchesBegan:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.delegate collectionViewIndexTouchesEnd:self];
}


@end
