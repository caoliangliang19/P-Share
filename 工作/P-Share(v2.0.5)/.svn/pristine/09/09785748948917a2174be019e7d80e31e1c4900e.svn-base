//
//  FayAnnotationView.m
//  GaoDeMap_fay
//
//  Created by fay on 16/6/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayAnnotationView.h"
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
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FayAnnotationView
@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;
- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {

        [self.portraitImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            
        }];
    
        [self setCalloutView];
        
    }
    else
    {
        [self.calloutView removeFromSuperview];
        [_calloutUpView removeFromSuperview];
        [_calloutDownView removeFromSuperview];
        [_numL removeFromSuperview];
        [_yuJiL removeFromSuperview];
        [_descributeL removeFromSuperview];
        _calloutDownView = nil;
        _calloutUpView = nil;
        _numL = nil;
        _yuJiL = nil;
        _descributeL = nil;
        self.calloutView = nil;
        
        [self.portraitImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kPortraitWidth, kPortraitHeight));
            
        }];
    }
    
    [super setSelected:selected animated:animated];
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
#pragma mark -- 设置资源点calloutView的样式
- (void)setCalloutViewStyleZiYuan
{
    if (_calloutDownView && _calloutUpView) {
        UILabel *zTopL = [self createLabelWithFont:12 textColor:[MyUtil colorWithHexString:@"aaaaaa"]];
        _zTopL = zTopL;
        zTopL.text = @"优惠时间";
        
        UILabel *zTimeL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"333333"]];
        _zTimeL = zTimeL;
        NSString *aTime = [NSString stringWithFormat:@"%@-%@",_parkModel.vipStartTime,_parkModel.vipStopTime];
        zTimeL.text = aTime;
        [_calloutUpView sd_addSubviews:@[zTopL,zTimeL]];
        
        UILabel *zYouhuiL = [self createLabelWithFont:12 textColor:[MyUtil colorWithHexString:@"aaaaaa"]];
        _zYouHuiL = zYouhuiL;
        zYouhuiL.text = @"优惠价格";
        
        UILabel *zPriceL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"333333"]];
        _zPriceL = zPriceL;
        NSString *aPrice =  [NSString stringWithFormat:@"%@",_parkModel.vipSharePrice];

        zPriceL.text = [NSString stringWithFormat:@"%@元",aPrice];
        
        NSAttributedString *attrStr = [MyUtil getLableText:zPriceL.text changeText:aPrice Color:NEWMAIN_COLOR font:13];
        zPriceL.attributedText = attrStr;
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        [_calloutDownView sd_addSubviews:@[zYouhuiL,zPriceL,btn]];
        [zTopL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(5);
        }];
        
        [zTimeL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(zTopL.mas_bottom).offset(2);
            make.leading.mas_equalTo(zTopL.mas_leading);
        }];
        
        [zYouhuiL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(5);
            
        }];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(zYouhuiL.mas_bottom).offset(5);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        [zPriceL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(btn.mas_left).offset(-5);
            make.centerY.mas_equalTo(btn.mas_centerY);
        }];
        [self.calloutView layoutIfNeeded];
        
    }
    
}

- (void)reSetCalloutView
{

    
    [_calloutUpView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_calloutViewStyle == CalloutViewStyleNervous) {
            make.height.mas_equalTo(26);
        }else
        {
            make.height.mas_equalTo(36);
        }
    }];
    
    [self.calloutView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (_calloutViewStyle == CalloutViewStyleNormal) {
            make.height.mas_equalTo(36);
        }else if (_calloutViewStyle == CalloutViewStyleNervous)
        {
            make.height.mas_equalTo(68);
            
        }else if (_calloutViewStyle == CalloutViewStylesZiYuan)
        {
            make.height.mas_equalTo(78);
            
        }
        
    }];
}

#pragma mark -- 设置大头针弹框
- (void)setCalloutView
{
    if (self.calloutView == nil)
    {
        self.calloutView = [[FayAnnotationView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToParkDetail:)];
        [self.calloutView addGestureRecognizer:tapGesture];
        self.calloutView.backgroundColor = [UIColor clearColor];
        UIImageView *bgImageV = [[UIImageView alloc] init];
        bgImageV.image = [[UIImage imageNamed:@"prompt_v2"] stretchableImageWithLeftCapWidth:100 topCapHeight:30];
//        bgImageV.image = [UIImage imageNamed:@"prompt_v2"];
        [self.calloutView addSubview:bgImageV];
        [bgImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        _calloutUpView = [UIView new];
        _calloutUpView.backgroundColor= [UIColor clearColor];
        CGFloat margin = 10.0f;
        CGFloat rightMargin = 5.0f;
        [self.calloutView addSubview:_calloutUpView];
        [_calloutUpView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-rightMargin);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(26);
        }];
        
        UIView *lineV= [UIView new];
        lineV.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
        [self.calloutView addSubview:lineV];
        [lineV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-rightMargin);
            make.top.mas_equalTo(_calloutUpView.mas_bottom).offset(0);
            make.height.mas_equalTo(1);
        }];
        
        _calloutDownView = [UIView new];
        _calloutDownView.backgroundColor = [UIColor clearColor];
        [self.calloutView addSubview:_calloutDownView];
        [_calloutDownView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-rightMargin);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
        }];
        
        
        [self addSubview:self.calloutView];
        [self.calloutView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.portraitImageView);
            make.left.mas_equalTo(self.portraitImageView.mas_right).offset(0);
            make.width.mas_equalTo(kCalloutWidth);
            make.height.mas_equalTo(68);
        }];
        
        
        
    }

}
- (void)setCalloutViewStyle:(CalloutViewStyle)calloutViewStyle
{
    _calloutViewStyle = calloutViewStyle;
    [self reSetCalloutView];
    if (calloutViewStyle == CalloutViewStyleNervous) {
        [self setCalloutViewStyleNervous];
    }else if (calloutViewStyle == CalloutViewStyleNormal){
        [self setCalloutViewStyleNormal];
    }else if (calloutViewStyle == CalloutViewStylesZiYuan){
        [self setCalloutViewStyleZiYuan];
    }
    
}
#pragma mark -- calloutView的tap事件
- (void)goToParkDetail:(UITapGestureRecognizer *)tapGesture
{
    if (self.goToParkDetail) {
        self.goToParkDetail();
    }
}
#pragma mark -- 设置导航时calloutView的样式
- (void)setCalloutViewStyleNormal
{
    if (_calloutDownView && _calloutUpView) {
        UILabel *priceL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"333333"]];
        _priceL = priceL;
        priceL.text = @"";
        
        
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        [_calloutUpView sd_addSubviews:@[priceL,btn]];

        [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_calloutUpView);
            make.left.mas_equalTo(5);
            make.width.mas_lessThanOrEqualTo(85);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceL.mas_centerY);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        [self.calloutView layoutIfNeeded];


    }
}

#pragma mark -- 设置车位紧张时calloutView的样式
- (void)setCalloutViewStyleNervous
{
    if (_calloutDownView && _calloutUpView && !_numL) {
        
        UILabel *oneTimeL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"333333"]];
        _oneTimeL = oneTimeL;
//        oneTimeL.text = @"16:21";
        UILabel *numL = [self createLabelWithFont:10 textColor:[MyUtil colorWithHexString:@"333333"]];
        _numL = numL;
        numL.text = @"";
        [_calloutUpView sd_addSubviews:@[oneTimeL,numL]];
        
        UILabel *yuJiL = [self createLabelWithFont:10 textColor:[MyUtil colorWithHexString:@"aaaaaa"]];
        _yuJiL = yuJiL;
        yuJiL.text = @"预计";
        UILabel *twoTimeL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"333333"]];
        _twoTimeL = twoTimeL;
//        twoTimeL.text = @"17:21";
        UILabel *descributeL = [self createLabelWithFont:13 textColor:[MyUtil colorWithHexString:@"ff6160"]];
        _descributeL = descributeL;
        descributeL.text = @"";
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"arrow_v2"] forState:(UIControlStateNormal)];
        [_calloutDownView sd_addSubviews:@[yuJiL,twoTimeL,descributeL,btn]];;
        
        [oneTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_calloutUpView.mas_centerY);
            make.centerX.mas_equalTo(_calloutUpView.mas_centerX).offset(-30);
            make.width.mas_lessThanOrEqualTo(40);
        }];
        
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(oneTimeL.mas_centerY);
            make.width.mas_lessThanOrEqualTo(60);
            make.centerX.mas_lessThanOrEqualTo(_calloutUpView.mas_centerX).offset(20);
            
        }];
        
        
        [twoTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(yuJiL.mas_bottom).offset(2);
            make.centerX.mas_equalTo(_calloutDownView.mas_centerX).offset(-30);
            make.width.mas_lessThanOrEqualTo(40);
        }];
        
        [descributeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(twoTimeL.mas_centerY);
            make.width.mas_lessThanOrEqualTo(30);
            make.centerX.mas_lessThanOrEqualTo(_calloutUpView.mas_centerX).offset(20);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(twoTimeL.mas_centerY);
            make.left.mas_equalTo(descributeL.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        [yuJiL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_calloutDownView.mas_top).offset(3);
            make.leading.mas_equalTo(twoTimeL.mas_leading);
        }];
        [self.calloutView layoutIfNeeded];

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
        self.portraitImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.portraitImageView];
        
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor grayColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.nameLabel];
        
        [self.portraitImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kPortraitWidth, kPortraitHeight));
            
        }];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.portraitImageView);
            make.top.mas_equalTo(self.portraitImageView.mas_bottom).offset(0);
            make.width.mas_lessThanOrEqualTo(200);
            
        }];
        
        
    }
    
    return self;
}

#pragma mark -- 赋值
- (void)setParkModel:(ParkingModel *)parkModel
{
    _parkModel = parkModel;
    
    if (_isHomePark) {
        //家
        self.calloutViewStyle = CalloutViewStyleNervous;
        _oneTimeL.text = parkModel.nowTime;
        _twoTimeL.text = parkModel.nextTime;
        _numL.text = [NSString stringWithFormat:@"%@ 个",parkModel.parkingCanUse];
        NSAttributedString *attrStr = [MyUtil getLableText:_numL.text changeText:[NSString stringWithFormat:@"%@",parkModel.parkingCanUse] Color:NEWMAIN_COLOR font:13];
        _numL.attributedText = attrStr;
        if ([parkModel.statusInfo isEqualToString:@"空"]) {
            _descributeL.textColor = NEWMAIN_COLOR;
        }else
        {
            _descributeL.textColor = [MyUtil colorWithHexString:@"ff6160"];

        }
        _descributeL.text = parkModel.statusInfo;
    }else
    {
        if ([parkModel.isCooperate intValue]==1) {//导航
            self.calloutViewStyle = CalloutViewStyleNormal;
            _priceL.text = parkModel.parkingName;
            //        _timeL.text = parkModel.parkingAddress;
        }else{
            //资源
            self.calloutViewStyle = CalloutViewStylesZiYuan;
        }
    }
   
    
    
}


@end
