//
//  MonthRentOrderController.h
//  P-Share
//
//  Created by 亮亮 on 16/3/16.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthRentOrderController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;

@property (weak, nonatomic) IBOutlet UIButton *noPayfor;
@property (weak, nonatomic) IBOutlet UIButton *yesPayfor;
@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UIView *yesView;

- (IBAction)backBtnClick:(id)sender;

- (IBAction)payForBtnClick:(UIButton *)payBtn;

@property (nonatomic,copy)NSString *orderType;
@end
