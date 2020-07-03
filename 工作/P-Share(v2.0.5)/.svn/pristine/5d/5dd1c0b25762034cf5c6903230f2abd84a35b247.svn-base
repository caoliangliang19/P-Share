//
//  TextCell.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TextCell.h"
#import "YuYueModel.h"

@interface TextCell ()
@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,assign)CGFloat contentLabelheight;

@end

@implementation TextCell


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
    UILabel *infoLabel = [UILabel new];
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.textColor = [MyUtil colorWithHexString:@"696969"];
    infoLabel.numberOfLines = 0;
    _infoLabel = infoLabel;
    [self.contentView addSubview:_infoLabel];
    __weak typeof(self)weakSelf = self;
    
    [infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(20);
        make.right.mas_equalTo(weakSelf).offset(-20);
        make.top.mas_equalTo(weakSelf).offset(10);
//        make.bottom.mas_equalTo(weakSelf).offset(-20);
        
    }];
    
}
- (void)setModel:(YuYueModel *)model
{
    _model = model;
    _infoLabel.text = model.sharePriceComment;
    
}

- (CGFloat)rowHeightWithCellModel:(YuYueModel *)model
{
    _model = model;
    
    __weak typeof(self)weakSelf = self;
//    设置label高度
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.contentLabelheight);
        
    }];
    
    [self layoutIfNeeded];
    
    CGFloat h = CGRectGetMaxY(self.infoLabel.frame);
    
    return h;
    
}

- (CGFloat)contentLabelheight
{
    if (!_contentLabelheight) {
        
        CGFloat h = [MyUtil getStringHeightWithString:_model.sharePriceComment Font:14 MaxWitdth:SCREEN_WIDTH-40];
        
        _contentLabelheight = h + 20;
    }
    
    return _contentLabelheight;
    
    
    
}

@end
