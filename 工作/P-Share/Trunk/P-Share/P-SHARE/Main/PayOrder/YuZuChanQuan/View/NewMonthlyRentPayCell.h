//
//  NewMonthlyRentPayCell.h
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMonthlyRentPayCellDelegate <NSObject>

- (void)getSwitchIsOn:(UISwitch *)swith;

@end

@interface NewMonthlyRentPayCell : UITableViewCell

@property (nonatomic,strong)OrderModel *orderModel;

@property (nonatomic,weak) id <NewMonthlyRentPayCellDelegate>delegate;
@property (nonatomic,assign)int monthNum;
@property (nonatomic,copy) void (^gotoMonthiyPayVC)(NewMonthlyRentPayCell *cell);
@property (nonatomic,copy)void (^gotoWebVC)();
@property (nonatomic,copy)NSString *maxDate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet UILabel *danJiaL;
@property (weak, nonatomic) IBOutlet UILabel *monthNumL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *jiaoFeeEndTimeL;
@property (weak, nonatomic) IBOutlet UILabel *agreeL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UISwitch *InvoiceSwitch;

- (NSDate*)StringChangeDate:(NSString *)str;
- (IBAction)isNeedInvoice:(UISwitch *)sender;

- (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
