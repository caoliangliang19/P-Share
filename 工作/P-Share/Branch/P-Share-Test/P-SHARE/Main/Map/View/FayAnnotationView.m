//
//  FayAnnotationView.m
//  GaoDeMap_fay
//
//  Created by fay on 16/6/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayAnnotationView.h"
#import "UIView+Extension.h"
#import "TriangleView.h"
#define kWidth  20.f
#define kHeight 80.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  40.f
#define kPortraitHeight 40.f

#define kCalloutWidth   120.0
#define kCalloutHeight  68.0


@interface FayAnnotationView ()
{
    CGFloat _calloutHeight;
    UILabel *_detailL;
    UIView  *_calloutUpView;
    UIView  *_calloutDownView;
//    正常
    UILabel *_priceL;
    UILabel *_jinRiL;
    UILabel *_timeL;
//    紧张
    UILabel *_oneTimeL;
    UILabel *_numL;
    UILabel *_yuJiL;
    UILabel *_twoTimeL;
    UILabel *_descributeL;
    
//    资源
    UILabel *_zTopL;
    UILabel *_zTimeL;
    UILabel *_zYouHuiL;
    UILabel *_zPriceL;
    
}
@property (nonatomic, strong) UIImageView       *portraitImageView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic,strong)  UIView            *progressView;
@property (nonatomic,strong)  JQIndicatorView   *indicator;
@property (nonatomic,strong)  TriangleView      *triangleView;
@end

@implementation FayAnnotationView
@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;
- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    MyLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark -- Override
- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}
- (void)setNeedAnimation:(BOOL)needAnimation
{
    if (needAnimation) {
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}
- (void)setIsHomePark:(BOOL)isHomePark
{
    _isHomePark = isHomePark;
    if (isHomePark) {
        [self progressShow];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        
        MyLog(@"----------*select");
        self.portraitImageView.bounds = CGRectMake(0, 0, 60, 60);
    
        [self setCalloutView];
        
    }
    else
    {
        self.userInteractionEnabled = YES;

        MyLog(@"----------*unselect");

        [self clearUI];
        self.portraitImageView.bounds = CGRectMake(0, 0, kPortraitWidth, kPortraitHeight);

    }
    
    [super setSelected:selected animated:animated];
}
- (void)clearUI
{
    _calloutViewStyle = CalloutViewStyleDaoHang;

    [self progressHidden];
    [self.calloutView removeFromSuperview];
    [_calloutUpView removeFromSuperview];
    [_calloutDownView removeFromSuperview];
    [_numL removeFromSuperview];
    [_yuJiL removeFromSuperview];
    [_descributeL removeFromSuperview];
    [_progressView removeFromSuperview];
    [_indicator removeFromSuperview];
    [_triangleView removeFromSuperview];
    _triangleView = nil;
    _progressView = nil;
    _indicator = nil;
    _calloutDownView = nil;
    _calloutUpView = nil;
    _numL = nil;
    _yuJiL = nil;
    _descributeL = nil;
    self.calloutView = nil;
}
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    static NSString *ID = @"anno";
    FayAnnotationView *annotationView = (FayAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        // 传入循环利用标识来创建大头针控件
        annotationView = [[FayAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annotationView;
}

#pragma mark -- 设置大头针弹框
- (void)setCalloutView
{
    if (!self.calloutView)
    {
        self.calloutView = [[FayAnnotationView alloc] init];
        self.calloutView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.calloutView.layer.shadowOffset = CGSizeMake(1, 1);
        self.calloutView.layer.shadowOpacity = 0.9;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToParkDetail:)];
        [self.calloutView addGestureRecognizer:tapGesture];
        self.calloutView.layer.cornerRadius = 8;
        self.calloutView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.calloutView];
        self.triangleView = [[TriangleView alloc] init];
        [self.calloutView addSubview:self.triangleView];

        _calloutUpView = [UIView new];
        _calloutUpView.backgroundColor= [UIColor clearColor];

        [self.calloutView addSubview:_calloutUpView];
        _calloutDownView = [UIView new];
        _calloutDownView.backgroundColor = [UIColor clearColor];
        [self.calloutView addSubview:_calloutDownView];
        
        
    }

}
/**
 CalloutViewStyleDaoHang
 CalloutViewStyleDaiBo
 CalloutViewStyleLinTing
 */
- (void)setCalloutViewStyle:(CalloutViewStyle)calloutViewStyle
{
   
    [self progressHidden];
    _calloutViewStyle = calloutViewStyle;
    if (calloutViewStyle == CalloutViewStyleDaoHang) {
        [self setCalloutViewStyleDaoHang];
    }else if (calloutViewStyle == CalloutViewStyleDaiBo){
        [self setCalloutViewStyleDaiBo];
    }else if (calloutViewStyle == CalloutViewStyleLinTing){
        [self setCalloutViewStyleLinTing];
    }
    
}
#pragma mark -- calloutView的tap事件
- (void)goToParkDetail:(UITapGestureRecognizer *)tapGesture
{
    if (self.goToParkDetail) {
        self.goToParkDetail(_originalModel);
    }
}
#pragma mark -- 设置导航时calloutView的样式
- (void)setCalloutViewStyleDaoHang
{
    if (_calloutDownView && _calloutUpView) {
        
        UILabel *priceL = [UILabel new];
        priceL.font = [UIFont systemFontOfSize:13];
        priceL.textColor = [UIColor colorWithHexString:@"333333"];
        priceL.textAlignment = 0;
        _priceL = priceL;

        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        _calloutUpView.backgroundColor = [UIColor clearColor];
        [_calloutUpView addSubview:_priceL];
        [_calloutUpView addSubview:btn];
        
        self.calloutView.bounds = CGRectMake(0, 0, kCalloutWidth, 30);
        self.calloutView.center = CGPointMake(self.portraitImageView.K_width+40, self.portraitImageView.K_height/2+5);
  
        self.triangleView.center = CGPointMake(0, self.calloutView.K_height/2);
        self.triangleView.bounds = CGRectMake(0, 0, 15, 20);
        [self.triangleView createTriangleView];
        _calloutUpView.frame = CGRectMake(0, 0, kCalloutWidth, 30);
        _priceL.frame = CGRectMake(5, 5, _calloutUpView.K_width-15, 20);
        btn.bounds = CGRectMake(0, 0, 10, 10);
        btn.center = CGPointMake(_calloutUpView.K_width-10, _priceL.K_centerY);
        

        _priceL.text = _parkModel.parkingName;

    }
}
#pragma mark -- 设置临停时calloutView的样式
- (void)setCalloutViewStyleLinTing
{
    if (_calloutDownView && _calloutUpView) {
        UILabel *zTopL = [self createLabelWithFont:12 textColor:[UIColor colorWithHexString:@"aaaaaa"]];
        _zTopL = zTopL;
        zTopL.textAlignment = 0;
        zTopL.text = @"优惠时间";
        
        UILabel *zTimeL = [self createLabelWithFont:13 textColor:[UIColor colorWithHexString:@"333333"]];
        _zTimeL = zTimeL;
        NSString *aTime = [NSString stringWithFormat:@"%@-%@",_parkModel.vipStartTime,_parkModel.vipStopTime];
        zTimeL.textAlignment = 0;
        zTimeL.text = aTime;
        
        UIView *lineV= [UIView new];
        lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
     
        UILabel *zYouhuiL = [self createLabelWithFont:12 textColor:[UIColor colorWithHexString:@"aaaaaa"]];
        zYouhuiL.textAlignment = 0;

        _zYouHuiL = zYouhuiL;
        zYouhuiL.text = @"优惠价格";
        
        UILabel *zPriceL = [self createLabelWithFont:13 textColor:[UIColor colorWithHexString:@"333333"]];
        _zPriceL = zPriceL;
        zPriceL.textAlignment = 2;
        NSString *aPrice =  [NSString stringWithFormat:@"%@",_parkModel.vipSharePrice];
        zPriceL.text = [NSString stringWithFormat:@"%@元",aPrice];
        
        NSAttributedString *attrStr = [UtilTool getLableText:zPriceL.text changeText:aPrice Color:KMAIN_COLOR font:13];
        zPriceL.attributedText = attrStr;
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        
        [_calloutDownView addSubview:zTopL];
        [_calloutDownView addSubview:zTimeL];
        [_calloutDownView addSubview:lineV];
        [_calloutDownView addSubview:zYouhuiL];
        [_calloutDownView addSubview:zPriceL];
        [_calloutDownView addSubview:btn];

        self.calloutView.bounds = CGRectMake(0, 0, kCalloutWidth, 80);
        self.calloutView.center = CGPointMake(self.portraitImageView.K_width+40, self.portraitImageView.K_height/2+5);
        _calloutDownView.frame = CGRectMake(0, 0, self.calloutView.K_width, self.calloutView.K_height);
        zTopL.frame = CGRectMake(5, 5, _calloutDownView.K_width-10, 12);
        zTimeL.frame = CGRectMake(5, zTopL.K_y+zTopL.K_height+2, zTopL.K_width, 13);
        lineV.frame = CGRectMake(5, zTimeL.K_y+zTimeL.K_height+5, zTopL.K_width, 1);
        zYouhuiL.frame = CGRectMake(5, zTimeL.K_y+zTimeL.K_height + 10, zTopL.K_width, 12);
        btn.frame = CGRectMake(_calloutDownView.K_width-15, zYouhuiL.K_height+zYouhuiL.K_y+5, 10, 10);
        zPriceL.frame = CGRectMake(5, btn.K_y-1, _calloutDownView.K_width-25, 12);
        self.triangleView.center = CGPointMake(0, self.calloutView.K_height/2);
        self.triangleView.bounds = CGRectMake(0, 0, 15, 20);
        [self.triangleView createTriangleView];
    }
    
}

#pragma mark -- 设置代泊的样式
- (void)setCalloutViewStyleDaiBo
{
    if (_calloutDownView && !_numL) {
        
        UILabel *oneTimeL = [self createLabelWithFont:13 textColor:[UIColor colorWithHexString:@"333333"]];
        oneTimeL.textAlignment = 0;
        _oneTimeL = oneTimeL;
        
        UILabel *numL = [self createLabelWithFont:10 textColor:[UIColor colorWithHexString:@"333333"]];
        _numL = numL;
        numL.text = @"";
        
        UIView *lineV= [UIView new];
        lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        
        UILabel *yuJiL = [self createLabelWithFont:10 textColor:[UIColor colorWithHexString:@"aaaaaa"]];
        yuJiL.textAlignment = 0;
        _yuJiL = yuJiL;
        yuJiL.text = @"预计";
        
        UILabel *twoTimeL = [self createLabelWithFont:13 textColor:[UIColor colorWithHexString:@"333333"]];
        twoTimeL.textAlignment = 0;

        _twoTimeL = twoTimeL;
        UILabel *descributeL = [self createLabelWithFont:13 textColor:[UIColor colorWithHexString:@"ff6160"]];
        _descributeL = descributeL;
        _descributeL.textAlignment = 2;
        descributeL.text = @"";
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        
        [_calloutDownView addSubview:yuJiL];
        [_calloutDownView addSubview:twoTimeL];
        [_calloutDownView addSubview:descributeL];
        [_calloutDownView addSubview:btn];
        [_calloutDownView addSubview:lineV];
        [_calloutDownView addSubview:oneTimeL];
        [_calloutDownView addSubview:numL];
       
        _oneTimeL.text = _parkModel.nowTime;
        
        _twoTimeL.text = _parkModel.nextTime;
        _numL.text = [NSString stringWithFormat:@"%ld 个",_parkModel.parkingCanUse];
        NSAttributedString *attrStr = [UtilTool getLableText:_numL.text changeText:[NSString stringWithFormat:@"%ld",_parkModel.parkingCanUse] Color:KMAIN_COLOR font:13];
        _numL.attributedText = attrStr;
        if ([_parkModel.statusInfo isEqualToString:@"空"]) {
            _descributeL.textColor = KMAIN_COLOR;
        }else
        {
            _descributeL.textColor = [UIColor colorWithHexString:@"ff6160"];
            
        }        
        _descributeL.text = _parkModel.statusInfo;
        
        self.calloutView.bounds = CGRectMake(0, 0, kCalloutWidth, 65);
        self.calloutView.center = CGPointMake(self.portraitImageView.K_width+40, self.portraitImageView.K_height/2+5);
        _calloutDownView.frame = CGRectMake(0, 0, self.calloutView.K_width, self.calloutView.K_height);
        oneTimeL.frame = CGRectMake(5, 5, _calloutDownView.K_width/2, 13);
        numL.frame = CGRectMake(_calloutDownView.K_width/2+5, 5, _calloutDownView.K_width/2-10, 13);
        lineV.frame = CGRectMake(5, oneTimeL.K_y+oneTimeL.K_height+5, _calloutDownView.K_width-10, 1);
        yuJiL.frame = CGRectMake(5, lineV.K_y+lineV.K_height+5, _calloutDownView.K_width-10, 10);
        twoTimeL.frame = CGRectMake(5, yuJiL.K_y+yuJiL.K_height+5,  _calloutDownView.K_width/2, 13);
        btn.frame = CGRectMake(_calloutDownView.K_width-15, twoTimeL.K_y+1, 10, 10);
        descributeL.frame = CGRectMake(_calloutDownView.K_width/2+5, twoTimeL.K_y,  _calloutDownView.K_width/2-10 - 15, 13);
        self.triangleView.center = CGPointMake(0, self.calloutView.K_height/2);
        self.triangleView.bounds = CGRectMake(0, 0, 15, 20);
        [self.triangleView createTriangleView];
        
    }
}

- (UILabel *)createLabelWithFont:(CGFloat)font textColor:(UIColor *)color
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = 1;
    return label;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
//- (void)setAnnotation:(MAAnnotation *)annotation
//{
//    [super setAnnotation:annotation];
//    
//    self.image = [UIImage imageNamed:annotation.icon];
//}
#pragma mark -- 设置大头针
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
         
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] init];
        self.portraitImageView.center = CGPointMake(self.K_width/2.0, self.K_height/2.0);
        self.portraitImageView.bounds = CGRectMake(0, 0, kPortraitWidth, kPortraitHeight);
        self.portraitImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.portraitImageView];
    
    }
    
    return self;
}

#pragma mark -- 赋值
- (void)setParkModel:(Parking *)parkModel
{

    if (!self.isSelected) {
        return;
    }
    _parkModel = parkModel;
    
    if (_isHomePark) {
        //家或者代泊
        if (self.calloutViewStyle != CalloutViewStyleDaiBo) {
            MyLog(@"warn0 ************%d********************** warn",self.calloutViewStyle);

            self.calloutViewStyle = CalloutViewStyleDaiBo;

        }else
        {
            [self setSelected:NO animated:YES];
            MyLog(@"warn1 ********************************** warn");

        }
    }else
    {
        if (parkModel.isCooperate==1) {//导航
            self.calloutViewStyle = CalloutViewStyleDaoHang;
        }else{            //临停
            self.calloutViewStyle = CalloutViewStyleLinTing;
        }
    }
    
}
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [UIView new];
        _progressView.layer.cornerRadius = 8;
        _progressView.backgroundColor = [UIColor whiteColor];
        [self.calloutView addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, kCalloutWidth, 30);
        _indicator = [[JQIndicatorView alloc] initWithType:3 tintColor:KMAIN_COLOR];
        _indicator.center = CGPointMake(kCalloutWidth/2, _progressView.bounds.size.height/2);
        _indicator.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [_progressView addSubview:self.indicator];
    }
    return _progressView;
    
}
- (void)progressShow
{
    self.progressView.hidden = NO;
    [self.indicator startAnimating];
    if (_progressView) {
        self.calloutView.center = CGPointMake(self.portraitImageView.K_width+38, self.portraitImageView.K_height/2+5);

        self.calloutView.bounds = CGRectMake(0, 0, kCalloutWidth, 30);
        
    }
    

}
- (void)progressHidden
{
    [self.indicator stopAnimating];
    self.progressView.hidden = YES;
}



@end
