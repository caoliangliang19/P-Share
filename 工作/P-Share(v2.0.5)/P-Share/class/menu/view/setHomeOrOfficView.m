//
//  setHomeOrOfficView.m
//  P-Share
//
//  Created by fay on 16/5/3.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "setHomeOrOfficView.h"
@interface setHomeOrOfficView()
{
    UILabel *_titleL;
    
}
@property (nonatomic,strong)UIView *bgView;

@end

@implementation setHomeOrOfficView



- (void)setUpSubViewWithView:(UIView *)view
{
    [view addSubview:self.bgView];
    self.bgView.hidden = NO;
    [view addSubview:self];
    
//    self.frame = CGRectMake(10, 10, 100, 100);
    
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor yellowColor];
//    return;
    UILabel *titleL = [UILabel new];
    titleL.backgroundColor = [UIColor redColor];
    
    titleL.textAlignment = 1;
    titleL.textColor = [MyUtil colorWithHexString:@"414141"];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.text = @"设置停车场类型";
    [self addSubview:titleL];
    titleL.sd_layout
    .centerXEqualToView(self)
    .heightIs(18);
    [titleL setSingleLineAutoResizeWithMaxWidth:140];
    
    self.sd_layout
    .leftSpaceToView(view,100)
    .rightSpaceToView(view,100)
    .centerYEqualToView(view);
    
    [self setupAutoHeightWithBottomView:titleL bottomMargin:10];
    
}

#pragma mark - view显示
- (void)showInView:(UIView *)view{
    [self setUpSubViewWithView:view];
    [self updateLayout];

    return;
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
//        [self performSelector:@selector(MyClick) withObject:self afterDelay:0.2];
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            
        }
    }];
    
    
}

- (UIView *)bgView
{
    if (_bgView ==nil) {
        
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _bgView.hidden =YES;
        
    }
    
    return _bgView;

}

@end
