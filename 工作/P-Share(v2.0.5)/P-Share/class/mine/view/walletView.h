//
//  walletView.h
//  P-Share
//
//  Created by fay on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "subLabel.h"
@interface walletView : UIView
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnWidth;
@property (weak, nonatomic) IBOutlet MarqueeLabel *descributeL;
@property (weak, nonatomic) IBOutlet subLabel *moneyL;
@property (weak, nonatomic) IBOutlet UIImageView *ruleImageV;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@end
