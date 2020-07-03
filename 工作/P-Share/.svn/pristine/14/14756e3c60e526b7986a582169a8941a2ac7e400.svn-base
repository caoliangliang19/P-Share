//
//  ChooseFreeCouponVC.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
@class CouponModel;

@protocol ChooseFreeDelegate <NSObject>

- (void)selectedFreeWithModel:(CouponModel *)model;

@end

@interface ChooseFreeCouponVC : BaseViewController

@property (nonatomic ,copy)NSString *orderType;

@property (nonatomic,weak) id<ChooseFreeDelegate> delegate;

@property (nonatomic,assign) int orderTotalPay;

@property (nonatomic,copy) NSString *parkingId;

@end
