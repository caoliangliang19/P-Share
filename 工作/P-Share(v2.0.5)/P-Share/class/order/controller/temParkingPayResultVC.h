//
//  temParkingPayResultVC.h
//  P-Share
//
//  Created by fay on 16/2/16.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemParkingListModel.h"
@interface temParkingPayResultVC : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property (weak, nonatomic) IBOutlet UILabel *titlePriceL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *payKindL;
@property (weak, nonatomic) IBOutlet UILabel *payTimeL;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *orderIDL;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspectRatio;

@property (nonatomic,copy)NSString *carNumber;
@property (nonatomic,copy)NSString *payState;
@property (nonatomic,strong)TemParkingListModel *temModel;
@end
