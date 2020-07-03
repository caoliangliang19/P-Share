//
//  BaseView.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init
{
    if (self == [super init]) {
        [self setUpSubView];
        
    }
    return self;
}
- (void)setUpSubView
{
    
}

- (UIActivityIndicatorView *)activityView
{
   
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];//指定进度轮的大小
        _activityView.color = KMAIN_COLOR;
        [self addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

    }
    return _activityView;
}
- (void)activityViewShow
{
    self.userInteractionEnabled = NO;
    [self.activityView startAnimating];

}
- (void)activityViewHidden
{
    self.userInteractionEnabled = YES;
    [self.activityView stopAnimating];

}

@end
