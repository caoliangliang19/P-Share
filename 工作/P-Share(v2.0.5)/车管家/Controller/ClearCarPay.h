//
//  ClearCarPay.h
//  P-Share
//
//  Created by fay on 16/4/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearCarPay : UIViewController


@property(nonatomic,strong)NSDictionary *pamaDict;
@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectSelfImageView;

@property (weak, nonatomic) IBOutlet UILabel *yingFuPrice;
@property (weak, nonatomic) IBOutlet UILabel *zheKouPrice;
@property (weak, nonatomic) IBOutlet UILabel *shiFuPrice;



@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;

@property (nonatomic,strong)TemParkingListModel *temParkingModel;

@property (nonatomic,copy)NSString *parkingId;


@end
