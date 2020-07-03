//
//  AllHistoryDetailViewController.h
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryOrderModel.h"
#import "RentModel.h"
#import "TemOrderModel.h"
#import "NewOrderModel.h"
@interface AllHistoryDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *allHistoryTableView;

@property (nonatomic,strong) TemOrderModel *temOrderModel;
@property (nonatomic,strong) TemParkingListModel *orderModel;
@property (nonatomic,strong) RentModel *rentModel;
@property (nonatomic,copy) NSString *historyType;
@property (nonatomic,strong)TemParkingListModel *temParkModel;
@property (nonatomic,strong) NewOrderModel *myOrderModel;
@property (nonatomic,copy)NSString *monthRent;

- (IBAction)backBtnClick:(id)sender;

@end
