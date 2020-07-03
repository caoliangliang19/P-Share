//
//  NoDataView.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"noOrderImage"];
    [self addSubview:imageView];
    
    UIButton *currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentBtn.backgroundColor = [UIColor clearColor];
    [currentBtn setTitle:@"先去首页看看吧" forState:(UIControlStateNormal)];
    [currentBtn setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:(UIControlStateNormal)];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    currentBtn.layer.cornerRadius = 4;
    currentBtn.clipsToBounds = YES;
    currentBtn.layer.borderColor = [UIColor colorWithHexString:@"39d5b8"].CGColor;
    currentBtn.layer.borderWidth = 1;
    [currentBtn addTarget:self action:@selector(goInFirstPage) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:currentBtn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(50);
        make.width.mas_equalTo(168);
        make.height.mas_equalTo(144);
    }];
    [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(170);
    }];
}
- (void)showView{
    self.hidden = NO;
}
- (void)hideView{
    self.hidden = YES;
}
- (void)goInFirstPage{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *tab = (UITabBarController *)window.rootViewController;
    tab.selectedIndex = 0;
    [self.viewController.rt_navigationController popToRootViewControllerAnimated:YES complete:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
