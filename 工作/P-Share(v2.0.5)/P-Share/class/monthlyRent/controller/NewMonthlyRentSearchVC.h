//
//  NewMonthlyRentSearchVC.h
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMonthlyRentSearchVC : UIViewController
@property (nonatomic,copy)NSString *orderType;

@property (weak, nonatomic) IBOutlet UILabel *dingDanL;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
- (IBAction)monthlyRentOrder:(id)sender;

@end
