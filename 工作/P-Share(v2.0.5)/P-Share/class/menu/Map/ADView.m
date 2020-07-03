//
//  ADView.m
//  P-Share
//
//  Created by fay on 16/5/21.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ADView.h"

@implementation ADView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpView];
        
    }
    return self;
    
}
- (void)setUpView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    adImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewTap)];
    [adImageView addGestureRecognizer:tapGesture];
    adImageView.layer.cornerRadius = 4;
    adImageView.layer.masksToBounds = YES;
    _adImageView = adImageView;
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close_s"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelADView) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self sd_addSubviews:@[bgView,adImageView,cancelBtn]];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat margin = 37.5;
    [adImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView).offset(-20);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(adImageView.mas_width).multipliedBy(1.33);
    }];
    
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(adImageView);
        make.top.mas_equalTo(adImageView.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self layoutIfNeeded];
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    _adImageView.image = _image;

}

- (void)ImageViewTap
{
    if (self.ImageTapBlock) {
        self.ImageTapBlock();
    }
}
- (void)cancelADView
{
    [self removeFromSuperview];
}
@end
