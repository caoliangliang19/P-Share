//
//  RendPayForController.h
//  P-Share
//
//  Created by 亮亮 on 16/2/19.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentModel.h"
#import "TemParkingListModel.h"
typedef void(^passOnValueDatagate) ();

@interface RendPayForController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (nonatomic,copy)NSString *price;
@property (weak, nonatomic) IBOutlet UILabel *infoL;

@property (weak, nonatomic) IBOutlet UILabel *yingFuPrice;
@property (weak, nonatomic) IBOutlet UILabel *zheKouPrice;
@property (weak, nonatomic) IBOutlet UILabel *shiFuPrice;

@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectSelfpayImageView;

@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIButton *turePay;

@property (nonatomic,strong)NSMutableDictionary *paramDic;
@property (weak, nonatomic) IBOutlet UIView *grayView;


- (IBAction)distanceMoney:(id)sender;

- (IBAction)payBtn:(UIButton *)sender;



- (IBAction)backBtn:(id)sender;

@property (nonatomic,strong)RentModel *rendModel;

@property (nonatomic,strong)TemParkingListModel *temParkingModel;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,copy)passOnValueDatagate myblock;

@property (nonatomic,copy)NSString *parkingId;
@end
