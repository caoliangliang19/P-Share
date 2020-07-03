//
//  OtherStopAlert.m
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DaiBoSuccessView.h"
@interface DaiBoSuccessView ()

@property (nonatomic,strong) UIView *bgView;

@end
@implementation DaiBoSuccessView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"DaiBoSuccessView" owner:nil options:nil]lastObject];
        
        // 初始化设置
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bounds = CGRectMake(0, 0, 281, 272);
        [window addSubview:self.bgView];
        [window addSubview:self];
    }
    
    return self;
    
}
#pragma mark -
#pragma mark - Block方法
- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;{
    self.tureBlock = tureBlock;
    self.cancleBlock = cancleBlock;
}
#pragma mark -
#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (_bgView ==nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.hidden =YES;
    }
    return _bgView;
}

#pragma mark -
#pragma mark - view显示
- (void)show{
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden =NO;
        self.bgView.userInteractionEnabled =NO;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.hidden = NO;
        self.bgView.userInteractionEnabled =YES;
    }];
}
#pragma mark -
#pragma mark - view消失
- (void)hide{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self performSelector:@selector(MyClick) withObject:self afterDelay:0.2];
    } completion:^(BOOL finished) {
    }];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
}
- (IBAction)cancleBtn:(id)sender {
    [self hide];
}

- (IBAction)backToHeadView:(UIButton *)sender {
    [self hide];
    if(self.cancleBlock){
        self.cancleBlock();
    }
}

- (IBAction)lookUpOrder:(UIButton *)sender {
    [self hide];
    if (self.tureBlock) {
        self.tureBlock();
    }
}
- (void)MyClick{
    if (self.bgView){
        [self.bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}


@end
