//
//  TextViewCell.m
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TextFieldCell.h"
@interface TextFieldCell()<UITextFieldDelegate>

@end
@implementation TextFieldCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView
{
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    
    [self.contentView addSubview:textField];
    _textField = textField;
    textField.font = [UIFont systemFontOfSize:13];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MyLog(@"textField.text    %@",textField.text);
    if (self.textFieldCellCallBackBlock) {
        self.textFieldCellCallBackBlock(textField);
    }
}
@end
