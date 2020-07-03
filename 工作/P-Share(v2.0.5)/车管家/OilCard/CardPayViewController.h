//
//  CardPayViewController.h
//  P-Share
//
//  Created by fay on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OilCardModel.h"
@interface CardPayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *payMoneyL;
@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;


@property (nonatomic ,strong)OilCardModel *model;
@property (nonatomic ,strong)TemParkingListModel *temModel1;

@property (nonatomic,copy)NSString *proid;
@property (nonatomic,copy)NSString *myMoney;
@property (nonatomic,copy)NSString *Money;

@end
