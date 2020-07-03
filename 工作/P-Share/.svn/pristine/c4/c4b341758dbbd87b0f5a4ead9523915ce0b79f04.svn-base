//
//  NoPackageCell.m
//  P-Share
//
//  Created by fay on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NoPackageCell.h"
@interface NoPackageCell ()
{
    UILabel *_descibuteL;
}
@end

@implementation NoPackageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UILabel *descibuteL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"959595"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:1];
    _descibuteL = descibuteL;
    descibuteL.textAlignment = 1;
    [self.contentView addSubview:descibuteL];
    [descibuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}
- (void)setDescribute:(NSString *)describute
{
    _describute = describute;
    _descibuteL.text = describute;
}
@end
