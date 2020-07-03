//
//  YuYueChooseTimeCell.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueChooseTimeCell.h"
#import "ChooseTimeView.h"
#define TimeViewWH          106
#define TimeViewSpace       10
@implementation YuYueChooseTimeCell
{
    UIScrollView *_scrollView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpView];
    }
    return self;
    
}

- (void)setUpView
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"请选择停车时间";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.contentView addSubview:line];
    __weak typeof(self)weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf).offset(12);
        make.width.mas_lessThanOrEqualTo(300);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
    }];
    CGFloat totalWidth = TimeViewWH * 7 + TimeViewSpace * 6;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(totalWidth, 0);
    scrollView.bounces = NO;
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(10);
        make.right.mas_equalTo(weakSelf).offset(-10);
        make.top.mas_equalTo(line.mas_bottom).offset(0);
        make.height.mas_equalTo(106);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(scrollView.mas_bottom).offset(5);
        make.height.mas_equalTo(6);
    }];
    
}

- (void)setTimeArrar:(NSArray *)timeArrar
{
    if (!_timeArrar) {
        _timeArrar = timeArrar;
        NSMutableArray *viewArray = [NSMutableArray array];
        for (int i = 0; i<timeArrar.count; i++) {
            ChooseTimeView *chooseTimeView = [ChooseTimeView new];
            chooseTimeView.userInteractionEnabled = YES;
            chooseTimeView.backgroundColor = [UIColor whiteColor];
            chooseTimeView.frame = CGRectMake((TimeViewWH + TimeViewSpace)* i , 0, TimeViewWH, TimeViewWH);
            chooseTimeView.style = ChooseTimeViewStyleUnSelect;
            if (i==0) {
                chooseTimeView.style = ChooseTimeViewStyleSelect;
                _currentTimeView = chooseTimeView;
            }
            
            chooseTimeView.model = [timeArrar objectAtIndex:i];
            
            [_scrollView addSubview:chooseTimeView];
           
            
            chooseTimeView.changeStyleBlock = ^(ChooseTimeView *timeView)
            {
                if (_currentTimeView.style == ChooseTimeViewStyleUnSelect)
                {
                    _currentTimeView.style = ChooseTimeViewStyleSelect;
                    
                }else
                {
                    _currentTimeView.style = ChooseTimeViewStyleUnSelect;
                }
                
                if (timeView.style == ChooseTimeViewStyleUnSelect)
                {
                    timeView.style = ChooseTimeViewStyleSelect;
                    
                }else
                {
                    timeView.style = ChooseTimeViewStyleUnSelect;
                }
                
                _currentTimeView = timeView;
                
                if (self.chooseTimeView) {
                    self.chooseTimeView(_currentTimeView);
                }

            };
            
            [viewArray addObject:chooseTimeView];
        }
    }    
}


@end
