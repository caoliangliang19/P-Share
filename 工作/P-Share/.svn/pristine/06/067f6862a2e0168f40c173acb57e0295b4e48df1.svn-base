//
//  ADView.m
//  P-SHARE
//
//  Created by fay on 16/9/26.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ADView.h"
@interface ADView()
{
    UIButton *_cancelBtn;
    
}
@property (nonatomic,strong)UIImageView *adImageView;
@end
@implementation ADView


- (void)setUpSubView
{

    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.backgroundColor = KMAIN_COLOR;
    adImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    adImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewTap)];
    [adImageView addGestureRecognizer:tapGesture];
    adImageView.layer.cornerRadius = 4;
    adImageView.layer.masksToBounds = YES;
    _adImageView = adImageView;
    
    UIButton *cancelBtn = [UIButton new];
    _cancelBtn = cancelBtn;
    _cancelBtn.hidden = YES;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close_s"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelADView) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self addSubview:bgView];
    [self addSubview:adImageView];
    [self addSubview:cancelBtn];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat margin = 37.5;
    
    [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView).offset(-20);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(adImageView.mas_width).multipliedBy(1.33);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(adImageView);
        make.top.mas_equalTo(adImageView.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self animationShow];
}
- (void)animationShow
{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _adImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        _cancelBtn.hidden = NO;
    }];
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    _adImageView.image = _image;
    
}

- (void)ImageViewTap
{
    [self cancelADView];
    if (self.ImageTapBlock) {
        self.ImageTapBlock();
    }
}
- (void)cancelADView
{
    [self removeFromSuperview];
}


@end
