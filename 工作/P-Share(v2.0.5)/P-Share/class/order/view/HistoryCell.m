//
//  HistoryCell.m
//  linTingJieMianDemo
//
//  Created by fay on 16/2/15.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {

    _carNum1.hidden = YES;
    _carNum2.hidden = YES;
    _carNum3.hidden = YES;
    _historyL.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labTapGesture:)];
    _infoL.userInteractionEnabled = YES;
    [_infoL addGestureRecognizer:tapGesture];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_infoL.text];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"“个人中心”"].location, [[noteStr string] rangeOfString:@"“个人中心”"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:NEWMAIN_COLOR range:redRange];
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:@"“车辆管理”"].location, [[noteStr string] rangeOfString:@"“车辆管理”"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:NEWMAIN_COLOR range:redRangeTwo];
    [_infoL setAttributedText:noteStr];
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchOrder)]) {
        
        [_delegate searchOrder];
        
    }
}

- (void)labTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToCarMasterVC)]) {
        [self.delegate goToCarMasterVC];
        
    }
}
- (IBAction)carNumBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBtnClickWithButton:)]) {
        
        [_delegate searchBtnClickWithButton:sender];
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
