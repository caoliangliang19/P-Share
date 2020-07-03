//
//  ActivityHeadview.m
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ActivityHeadview.h"
@interface ActivityHeadview()
{
    UILabel     *_titleL;
    UIButton    *_btn;
    UIImageView *_imgV;
    
}
@end

@implementation ActivityHeadview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [self setupSubView];
    }
    
    return self;
}

- (void)setupSubView
{
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [mainView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = KMAIN_COLOR;
    [mainView addSubview:greenView];
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mainView.mas_centerY);
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(6, 22));
    }];
    
    _titleL = [UILabel new];
    _titleL.text = @"";
    _titleL.font = [UIFont systemFontOfSize:15];
    _titleL.textColor = [UIColor colorWithHexString:@"333333"];
    [mainView addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mainView.mas_centerY);
        make.left.mas_equalTo(greenView.mas_right).offset(8);
    }];
    
    UIImageView *imgV = [UIImageView new];
    _imgV = imgV;
    imgV.image = [UIImage imageNamed:@"listRight"];
    [mainView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(mainView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(7, 12));
        
    }];
    
    UIButton *btn = [UIButton new];
    _btn = btn;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    [btn setTitle:@"更多" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onClick) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mainView.mas_centerY);
        make.right.mas_equalTo(imgV.mas_left).offset(-6);
        make.width.mas_equalTo(120);
        
    }];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(0);
    }];
}
- (void)onClick{
    if (self.moreBlock) {
        self.moreBlock(self.index);
    }
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleL.text = title;
    
}
- (void)setStyle:(ActivityHeadviewStyle)style
{
    _style = style;
    if (style == ActivityHeadviewStyleOne) {
        _btn.hidden = NO;
        _imgV.hidden = NO;
    }else
    {
        _btn.hidden = YES;
        _imgV.hidden = YES;
    }
}
@end
