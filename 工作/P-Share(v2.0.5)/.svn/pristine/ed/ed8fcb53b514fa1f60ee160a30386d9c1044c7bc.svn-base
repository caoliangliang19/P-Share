//
//  TableViewCell.m
//  linTingJieMianDemo
//
//  Created by fay on 16/2/15.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTapGesture:)];
    _infoL.userInteractionEnabled = YES;
    [_infoL addGestureRecognizer:tapGesture];
        
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_infoL.text];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"《口袋停停车缴费协议》"].location, [[noteStr string] rangeOfString:@"《口袋停停车缴费协议》"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:NEWMAIN_COLOR range:redRange];
    
    [_infoL setAttributedText:noteStr];
}

- (void)labTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToWebViewVC)]) {
        [self.delegate goToWebViewVC];
        
    }
}
- (IBAction)payBtnClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payOrderWithBtn:)]) {
        [self.delegate payOrderWithBtn:sender];
        
    }
}
- (IBAction)agreeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeBtnClickDelegate:)]) {
        [self.delegate agreeBtnClickDelegate:sender];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
