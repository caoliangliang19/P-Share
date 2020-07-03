//
//  OrderCell.m
//  P-Share
//
//  Created by 亮亮 on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "AllOrderCell.h"

@implementation AllOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancleBtn.layer.cornerRadius = 3;
    self.otherBtn.layer.cornerRadius = 3;
    self.cancleBtn.clipsToBounds = YES;
    self.otherBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(UIButton *)myBtn;{
    if ([self.delegate respondsToSelector:@selector(clickBtn:row:)]) {
        [self.delegate clickBtn:myBtn.tag row:self.row];
    }
}
@end
