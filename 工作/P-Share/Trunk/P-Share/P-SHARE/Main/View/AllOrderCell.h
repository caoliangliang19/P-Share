//
//  OrderCell.h
//  P-Share
//
//  Created by 亮亮 on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;

@protocol AllOrderCellDelegate <NSObject>

- (void)clickBtn:(NSInteger)tag row:(NSInteger)row;

@end

@interface AllOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *StopCarType;
@property (weak, nonatomic) IBOutlet UILabel *parkingName;
@property (weak, nonatomic) IBOutlet UILabel *parkingTime;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *paidMoney;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (assign,nonatomic) NSInteger row;

@property (assign, nonatomic)id<AllOrderCellDelegate>delegate;

- (void)upDataCell:(Order *)model indexPathRow:(NSInteger)row;
- (IBAction)clickBtn:(UIButton *)myBtn;
@end
