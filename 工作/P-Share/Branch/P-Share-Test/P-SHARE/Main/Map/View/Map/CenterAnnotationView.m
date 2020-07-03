//
//  CenterAnnotationView.m
//  P-SHARE
//
//  Created by fay on 2016/12/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CenterAnnotationView.h"
#import "CustomCalloutView.h"
#define kCalloutWidth   190.0
#define kCalloutHeight  60.0

#define kHoriMargin 2.f
#define kVertMargin 2.f

#define kWidth  44.f
#define kHeight 71.f

#define kPortraitWidth  40.f
#define kPortraitHeight 67.f
@interface CenterAnnotationView()
@property (nonatomic, strong) UIImageView *portraitImageView;

@end
@implementation CenterAnnotationView
@synthesize annotationImage = _annotationImage;
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize calloutView;

- (void)setAnnotationImage:(UIImage *)annotationImage{
    _annotationImage = annotationImage;
    self.portraitImageView.image = annotationImage;
}
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView{
    static NSString *indentifier = @"CenterAnnotationView";
    CenterAnnotationView *annotationView = (CenterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:indentifier];
    if (!annotationView) {
        annotationView = [[CenterAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:indentifier];
    }
    return annotationView;
}

- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:NO];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        // show Callout
//        [self showCalloutView];
        
    }else{
        // hidden Callout
//        [self hiddenCalloutView];
    }
    [super setSelected:selected animated:animated];

}

- (void)setNeedBeat:(BOOL)needBeat{
    _needBeat = needBeat;
    [self.superview bringSubviewToFront:self];
    
    if (needBeat) {
        [UIView animateWithDuration:0.4 animations:^{
            self.layer.transform = CATransform3DMakeTranslation(0, -12, 0);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.layer.transform = CATransform3DIdentity;
            }];
        }];
    }
   
}
- (void)hiddenCalloutView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.calloutView.hidden = YES;
    }completion:^(BOOL finished) {
        [self.calloutView removeFromSuperview];
        self.calloutView = nil;
        self.calloutShow = NO;

    }];

}
- (void)showCalloutView{
    if (self.calloutView == nil) {
        /* Construct custom callout. */
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        
        self.calloutView.transform = CGAffineTransformMakeScale(0.6, 0.8);
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kCalloutWidth, 20)];
        title.textColor = [UIColor darkGrayColor];
        title.textAlignment = 1;
        title.font = [UIFont systemFontOfSize:13];
        title.backgroundColor = [UIColor clearColor];
        title.text = self.title;
        [self.calloutView addSubview:title];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, kCalloutWidth-16, 20)];
        subTitle.textAlignment = 1;
        subTitle.font = [UIFont systemFontOfSize:11];
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.textColor = [UIColor darkGrayColor];
        subTitle.text = self.subTitle;
        [self.calloutView addSubview:subTitle];
    }
    [self addSubview:self.calloutView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:1/0.25 options:0 animations:^{
        self.calloutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        self.calloutView.transform = CGAffineTransformIdentity;
        self.calloutShow = YES;
    }];
    
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected) {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}
#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        self.annotation = annotation;
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        [self addSubview:self.portraitImageView];
        
    }
    return self;
}


@end
