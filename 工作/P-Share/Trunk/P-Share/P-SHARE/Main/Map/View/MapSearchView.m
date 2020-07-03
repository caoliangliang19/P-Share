//
//  MapSearchView.m
//  P-Share
//
//  Created by fay on 16/6/13.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "MapSearchView.h"
@interface MapSearchView()
{
    UILabel     *_titleL;
    UIButton    *_searchBtn;
    UIView      *_lineV;
    UIView      *_topView;
}
@end

@implementation MapSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.cornerRadius = 21;
        [self setUpSubViews];
        
    }
    
    return self;
}
- (void)setUpSubViews
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
//
//    UIButton *headBtn = [UIButton new];
//    headBtn.layer.cornerRadius = 14;
//    headBtn.layer.masksToBounds = YES;    
//    [headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
//    _headBtn = headBtn;
//    [self addSubview:headBtn];
//    
//    UIView *lineV = [UIView new];
//    lineV.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
//    _lineV = lineV;
//    [self addSubview:lineV];
    
    UILabel *titleL = [UILabel new];
    _titleL = titleL;
    titleL.font = [UIFont boldSystemFontOfSize:15];
    titleL.textColor = [UIColor colorWithHexString:@"333333"];
    titleL.textAlignment = 1;
    titleL.userInteractionEnabled = YES;

    [self addSubview:titleL];
    
    UIButton *searchBtn = [UIButton new];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchGray_v2"] forState:(UIControlStateNormal)];
    _searchBtn = searchBtn;
    [searchBtn addTarget:self action:@selector(searchBthClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:searchBtn];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor clearColor];
    _topView = topView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBthClick)];
    [topView addGestureRecognizer:tapGesture];
    [self addSubview:topView];
    
    [self addLayout];
    
}

- (void)addLayout
{
//    CGFloat rowMargin = 6.0f;
//    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(rowMargin);
//        make.centerY.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//    
//    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_headBtn);
//        make.left.mas_equalTo(_headBtn.mas_right).offset(rowMargin);
//        make.top.mas_equalTo(self).offset(rowMargin);
//        make.width.mas_equalTo(1);
//        make.bottom.mas_equalTo(self).offset(-rowMargin);
//    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
    }];
    
   
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleL.text = title;
}

- (void)headBtnClick
{
    if (self.goToUserCenter) {
        self.goToUserCenter();
    }
    
}

- (void)searchBthClick
{
    if (self.gotoSearchVC) {
        self.gotoSearchVC();
    }
}
@end
