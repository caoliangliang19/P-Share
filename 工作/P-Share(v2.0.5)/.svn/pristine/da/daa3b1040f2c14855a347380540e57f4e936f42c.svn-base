//
//  NewDiscountCell.m
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewDiscountCell.h"

#define Green   [MyUtil colorWithHexString:@"29d6b8"]
#define Purple  [MyUtil colorWithHexString:@"8957a1"]
#define Orangle [MyUtil colorWithHexString:@"faa952"]
#define Gray    [MyUtil colorWithHexString:@"e0e0e0"]

@implementation NewDiscountCell

- (void)awakeFromNib {


    
    
    
}

- (void)layoutSubviews
{
    [self initSubViewColor:_colorType];
    
   
//    _shadowView.layer.borderWidth = 1.0f;
//    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _shadowView.layer.opacity = 0.5f;
//    _shadowView.layer.shadowOffset = CGSizeMake(0, 5);
//    _shadowView.layer.shadowRadius = 2.0f;
    
    
}



- (void)initSubViewColor:(ColorType )colorType
{
    switch (colorType) {
        case GrayColor:
        {
            _headV.backgroundColor = Gray;
            _moneyL.textColor = Gray;
            _discountTypeL.textColor = Gray;
//            _timeL.textColor = Gray;
//            _youXiaoQi.textColor = Gray;
            
        }
            break;
            
        case GreenColor:
        {
            _headV.backgroundColor = Green;
            _moneyL.textColor = Green;
            _discountTypeL.textColor = Green;

        }
            break;
            
        case PurpleColor:
        {
            _headV.backgroundColor = Purple;
            _moneyL.textColor = Purple;
            _discountTypeL.textColor = Purple;

        }
            break;
            
        case OrangeColor:
        {
            _headV.backgroundColor = Orangle;
            _moneyL.textColor = Orangle;
            _discountTypeL.textColor = Orangle;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
