//
//  ShowTingCheMaViewController.h
//  P-Share
//
//  Created by fay on 16/1/20.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface ShowTingCheMaViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *rendL;


@property (weak, nonatomic) IBOutlet UILabel *cheChangNameL;
@property (weak, nonatomic) IBOutlet UILabel *tingCheMaL;
@property (weak, nonatomic) IBOutlet UILabel *chePaiHaoL;
@property (weak, nonatomic) IBOutlet UILabel *payTimeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *temLable;
@property (weak, nonatomic) IBOutlet UILabel *promptLable;
@property (weak, nonatomic) IBOutlet UILabel *headLable;
@property (weak, nonatomic) IBOutlet UILabel *ruChangL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tingCheCons;
@property (weak, nonatomic) IBOutlet UILabel *xuFeiL;
@property (weak, nonatomic) IBOutlet UILabel *monthL;

@property (weak, nonatomic) IBOutlet UILabel *yueL;
@property (nonatomic,retain)OrderModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *payImage;





@end
