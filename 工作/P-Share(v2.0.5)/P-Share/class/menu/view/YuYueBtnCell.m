//
//  YuYueBtnCell.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "YuYueBtnCell.h"

@implementation YuYueBtnCell

- (void)awakeFromNib {


    _commitBtn.layer.cornerRadius = 4;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)commitYuYue:(UIButton *)sender {
    
    if (self.commitYueYue) {
        self.commitYueYue();
    }
}

@end
