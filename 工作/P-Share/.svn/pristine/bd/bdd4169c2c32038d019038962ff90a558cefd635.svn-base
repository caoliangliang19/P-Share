//
//  TimeView.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TimeView.h"
#import "YuYueTimeModel.h"
@interface TimeView()
{
    UILabel     *_upLable;
    UILabel     *_bottomL;
}
@end
@implementation TimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    self.layer.cornerRadius = 2.5f;
    self.layer.masksToBounds = YES;
    UILabel *upLable = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:1];
    _upLable = upLable;
    [self addSubview:upLable];
    [upLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self).offset(-10);
    }];
    
    UILabel *bottomL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] textAlignment:1 numberOfLine:1];
    _bottomL = bottomL;
    [self addSubview:bottomL];
    [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(10);
    }];
    
    
}
- (void)setTimeViewStyle:(TimeViewStyle)timeViewStyle
{
    _timeViewStyle = timeViewStyle;
    if (timeViewStyle == TimeViewStyleUnSelect) {
        self.backgroundColor = [UIColor colorWithHexString:@"393c45"];
    }else{
        self.backgroundColor = KMAIN_COLOR;
    }
}
- (void)setModel:(YuYueTimeModel *)model
{
    _model = model;
    _bottomL.text = model.date;
    _upLable.text = model.week;
    
}

@end
