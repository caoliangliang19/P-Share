//
//  TextCell.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "OldTextCell.h"
#import "YuYueModel.h"

@interface OldTextCell ()
@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,assign)CGFloat contentLabelheight;

@end

@implementation OldTextCell


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
    infoLabel.textColor = [UIColor colorWithHexString:@"696969"];
    infoLabel.numberOfLines = 0;
    _infoLabel = infoLabel;
    [self.contentView addSubview:_infoLabel];
    __weak typeof(self)weakSelf = self;
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(20);
        make.right.mas_equalTo(weakSelf).offset(-20);
        make.top.mas_equalTo(weakSelf).offset(10);
        make.bottom.mas_equalTo(weakSelf).offset(-10);
        
    }];
    
}
- (void)setModel:(YuYueModel *)model
{
    _model = model;
    _infoLabel.text = model.sharePriceComment;
    
}




@end
