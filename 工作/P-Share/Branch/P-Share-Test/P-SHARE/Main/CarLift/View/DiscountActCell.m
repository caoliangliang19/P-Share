//
//  DiscountActCell.m
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "DiscountActCell.h"
#import "CarLiftModel.h"

@interface DiscountActCell()
@property (weak, nonatomic) IBOutlet UIImageView *distanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageV;

@end
@implementation DiscountActCell

- (void)setModel:(CarLiftModel *)model
{
    [super setModel:model];
    [self.distanceImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"distanceAct"]];
    self.priceL.text = nil;
    self.timeL.text = model.remainTime;
    self.titleL.text = model.title;
    
}

@end
