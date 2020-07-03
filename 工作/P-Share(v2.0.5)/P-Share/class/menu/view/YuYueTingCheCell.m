//
//  YuYueTingCheCell.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "YuYueTingCheCell.h"

@implementation YuYueTingCheCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _mainL = [[UILabel alloc] init];
        _subL = [[UILabel alloc]init];
        
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    
    _mainL.font = [UIFont systemFontOfSize:15];
    _mainL.textColor = [MyUtil colorWithHexString:@"696969"];
    [self.contentView addSubview:_mainL];
    [_mainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(6);
//        make.width.lessThanOrEqualTo(100);
        make.width.mas_equalTo(100);
        
        
    }];
    
    _subL.font = [UIFont systemFontOfSize:17];
    _subL.textColor = [MyUtil colorWithHexString:@"333333"];
    [self.contentView addSubview:_subL];
    [_subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(-6);
//        make.width.lessThanOrEqualTo(SCREEN_WIDTH-120);
        make.width.mas_equalTo(200);

        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
