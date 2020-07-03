//
//  PingZhengCell.m
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "PingZhengCell.h"

@implementation PingZhengCell

- (void)awakeFromNib {

//    _bgView.layer.borderWidth = 1;
//    _bgView.layer.backgroundColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    
}
- (IBAction)pingZhengBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickPingBtn:tableView:)]) {
        [self.delegate clickPingBtn:self.index tableView:self.tableViewType];
    }
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
