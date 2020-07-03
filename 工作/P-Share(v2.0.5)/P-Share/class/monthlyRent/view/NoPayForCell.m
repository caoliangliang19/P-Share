//
//  NoPayForCell.m
//  P-Share
//
//  Created by 亮亮 on 16/3/16.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "NoPayForCell.h"

@implementation NoPayForCell

- (void)awakeFromNib {
    self.canclePayFor.layer.borderWidth = 1;
    self.canclePayFor.layer.borderColor = [MyUtil colorWithHexString:@"bfbfbf"].CGColor;
    self.payFor.layer.borderWidth = 1;
    self.payFor.layer.borderColor = [MyUtil colorWithHexString:@"39d5b8"].CGColor;
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)canclePayFor:(id)sender;{
    if ([self.myDelegate respondsToSelector:@selector(canclePayFor:)]) {
        [self.myDelegate canclePayFor:self.index];
    }
}
- (IBAction)payFor:(id)sender;{
    if ([self.myDelegate respondsToSelector:@selector(payFor:)]) {
        [self.myDelegate payFor:self.index];
    }
}

@end
