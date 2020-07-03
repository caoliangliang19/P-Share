//
//  DriveImageView.m
//  P-Share
//
//  Created by 亮亮 on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DriveImageView.h"

@interface DriveImageView ()

@property (nonatomic,strong)UIViewController *controller;
@property (nonatomic,strong) UIView *bgView;
@end
@implementation DriveImageView
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        
        self.controller = controller;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-10, ((SCREEN_WIDTH-10)*4)/5);
        [self addImageName];
        
        [self.controller.view addSubview:self.bgView];
        [controller.view addSubview:self];
    }
    return self;
}
- (instancetype)initWithView:(UIView *)mainView{
    if (self = [super init]) {
        
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-10, ((SCREEN_WIDTH-10)*4)/5);
        [self addImageName];
        
        [mainView addSubview:self.bgView];
        [mainView addSubview:self];
    }
    
    return self;
}

- (void)addImageName{
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"driveProve"]];
    imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH-10,  ((SCREEN_WIDTH-10)*4)/5);
    [self addSubview:imageview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBgView)];
    [self.bgView addGestureRecognizer:tap];
}
- (void)onClickBgView{
    [self hide];
}
#pragma mark -
#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bgView;
}
- (void)show{
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
   
}
- (void)hide{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.6, 0.6);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.bgView) {
                [self.bgView removeFromSuperview];
                
            }
            [self removeFromSuperview];
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
