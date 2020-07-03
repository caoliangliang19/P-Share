//
//  ActivityCell.m
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ActivityCell.h"
#import "CarLiftModel.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(CarLiftModel *)model
{
    _model = model;
    if (self.style == ActivityCellStyleYouHui) {
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"distanceAct"]];
    }else if (self.style == ActivityCellStyleXinde){
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"index_ch_head_313"]];

    }
    
}

@end
