//
//  ChooseFreeViewController.h
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountModel.h"
#import "CouponModel.h"

@protocol ChooseFreeDelegate <NSObject>

- (void)selectedFreeWithModel:(CouponModel *)model;

@end


@interface ChooseFreeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *noFreeView;
@property (weak, nonatomic) IBOutlet UITableView *chooseTableView;

@property (nonatomic ,copy)NSString *orderType;

@property (nonatomic,weak) id<ChooseFreeDelegate> delegate;

@property (nonatomic,assign) int orderTotalPay;

@property (nonatomic,copy) NSString *parkingId;
- (IBAction)backBtnClick:(id)sender;
@end
