//
//  fayBaseProgress.m
//  farProgressView
//
//  Created by fay on 16/8/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayBaseProgress.h"
#import "UIView+Extension.h"
#import "PopView.h"
#import "TagLabel.h"


@interface FayBaseProgress ()
{
    UIView    *_bgView;
    CGFloat   _spaceY;
    PopView   *_popView;

}
@end
@implementation FayBaseProgress


- (instancetype)initWithFrame:(CGRect)frame LineHeight:(CGFloat)lineHeight Progress:(CGFloat)progress space:(CGFloat)spaceY ProgressValue:(CGFloat)value FayBaseProgressStyle:(FayBaseProgressStyle)fayBaseProgressStyle
{
    if (self == [super initWithFrame:frame]) {
        _value = value;
        _progress = progress;
        _lineHeight = lineHeight;
        _fayBaseProgressStyle = fayBaseProgressStyle;
        _imageSize = 30.0f;
        _spaceY = spaceY;
        [self loadProgreeLayer];
    }
    return self;

}
- (void)loadProgreeLayer
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIView *bgView = [UIView new];
    _bgView = bgView;
    [self addSubview:bgView];
    if(_fayBaseProgressStyle == FayBaseProgressStyleTop)
    {
        [path moveToPoint:CGPointMake(0, _lineHeight/2)];
        [path addLineToPoint:CGPointMake(self.K_width, _lineHeight/2)];
        bgView.frame = CGRectMake(0, _lineHeight/2, self.K_width, _lineHeight);
    }else
    {
        [path moveToPoint:CGPointMake(0, _lineHeight/2)];
        [path addLineToPoint:CGPointMake(self.K_width, _lineHeight/2)];
        bgView.frame = CGRectMake(0,  24, self.K_width, _lineHeight);
    }
//    bgView.backgroundColor = [UIColor redColor];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.strokeColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    bgLayer.lineCap = kCALineCapRound;
    bgLayer.path = path.CGPath;
    bgLayer.lineWidth = self.lineHeight;
    bgLayer.lineCap = kCALineCapRound;
    bgLayer.lineJoin = kCALineCapRound;
    bgLayer.strokeEnd = 1;
    bgLayer.strokeStart = 0;
    [bgView.layer addSublayer:bgLayer];
        
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"FECB3E"].CGColor;
    layer.lineWidth = self.lineHeight;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineCapRound;
    layer.lineWidth = 10.0f;
   
    layer.path = path.CGPath;
    layer.strokeStart = 0;
    layer.strokeEnd = 0;
    [bgView.layer addSublayer:layer];
    if (_fayBaseProgressStyle == FayBaseProgressStyleTop) {
        _popView = [[PopView alloc] initWithFrame:CGRectMake(-10,_bgView.frame.origin.y + _bgView.frame.size.height + _spaceY, 45, 20)];
        _popView.popViewPosition = PopViewPositionTop;
    }else
    {
        _popView = [[PopView alloc] initWithFrame:CGRectMake(-10, _bgView.frame.origin.y - 15 - _spaceY, 45, 20)];
        
        _popView.popViewPosition = PopViewPositionBottom;
    }
    [self addSubview:_popView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        POPSpringAnimation *anBasic = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        anBasic.toValue = @(self.progress);
        anBasic.beginTime = 0.5f;
        [layer pop_addAnimation:anBasic forKey:@"baseAnimation"];

        CGFloat spaceX = self.progress * (self.K_width - 10);
        POPBasicAnimation *anBasic1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anBasic1.toValue = @(spaceX);
        anBasic1.beginTime = 0.5f;
        [_popView pop_addAnimation:anBasic1 forKey:@"position"];
        [_popView.numL animationFromnum:0 toNum:_value duration:0.5f];
    });
}

- (void)setImageArray:(NSArray *)imageArray
{
    NSAssert(imageArray.count > 1, @"imageArray count > 1");
    CGFloat spaceX = self.K_width / (imageArray.count - 1);
    NSArray *carArray = @[@"银卡",@"金卡",@"铂金卡",@"钻石卡"];
    NSArray *timeArr = @[@"16.02.06",@"16.02.06",@"",@""];

    _imageArray = imageArray;
    for (int i=0; i<imageArray.count; i++) {
        NSString *imageName = _imageArray[i];
       

        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:imageName];
//        CGFloat margin = i == 0 ? 0 : _imageSize/2;
        imageV.center = CGPointMake(spaceX * i  , _bgView.K_centerY);
        imageV.bounds = CGRectMake(0, 0, _imageSize, _imageSize);
        [self addSubview:imageV];
        
        if (_fayBaseProgressStyle == FayBaseProgressStyleBottom) {
            UILabel *carL = [UtilTool createLabelFrame:CGRectZero title:carArray[i] textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:1];
            UILabel *TimeL = [UtilTool createLabelFrame:CGRectZero title:timeArr[i] textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:1];
            [self addSubview:carL];
            [self addSubview:TimeL];
            carL.center = CGPointMake(imageV.K_centerX, imageV.K_centerY + 20);
            carL.bounds = CGRectMake(0, 0, 60, 20);
            TimeL.center = CGPointMake(imageV.K_centerX, imageV.K_centerY + 37);
            TimeL.bounds = CGRectMake(0, 0, 60, 20);

        }
    }
}
@end
