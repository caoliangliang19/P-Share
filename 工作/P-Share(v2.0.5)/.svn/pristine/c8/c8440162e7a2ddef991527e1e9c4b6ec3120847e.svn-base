//
//  DaiBoInfoView.h
//  P-Share
//
//  Created by fay on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemParkingListModel.h"

typedef enum {
    TIMETYPEDAY,
    TIMETYPEHOUR,
    TIMETYPEMINITE,
    TIMETYPESECOND,
}TIMETYPE;
/**
 orderState 订单状态
 已预约           1
 停车中/已接车     2
 停车完毕/已停车    4
 取车中/待取车       9
 订单完成/已完成     5
 订单取消/已取消     12
 */

typedef NS_ENUM(NSInteger,DAIBOSTATUS) {
    /**
     *  已预约
     */
    DAIBOSTATUSAPPOINTMENT = 1,
    /**
     *  停车中
     */
    DAIBOSTATUSPARKING = 2,
    /**
     *  停车完毕
     */
    DAIBOSTATUSPARKEND = 4,
    /**
     *  取车中
     */
    DAIBOSTATUSGETCARING = 9,
    /**
     *  订单完成
     */
    DAIBOSTATUSORDEREND = 5,
    /**
     *  订单取消
     */
    DAIBOSTATUSCANCEL = 12
    
    
};
@interface DaiBoInfoView : UIView

//layout-------------
@property (nonatomic,strong)TemParkingListModel *orderModel;
@property (nonatomic,copy)void (^cancelOrderBlock)(NSString *orderId);
@property (nonatomic,copy)void (^getCarBlock)(NSString *orderId);
//@property (nonatomic,copy)void (^)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *muQinFeeLayout0;//900
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *muQianFeeLayout1;//700
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *muQianFeeLayout2;//600
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;




//layout-------------

@property (nonatomic,copy)void (^tapPictureGestureBlock)(UITapGestureRecognizer *tap);

@property (nonatomic,copy)NSMutableArray *imageArray;
@property (nonatomic,assign)DAIBOSTATUS orderStatue;
@property (nonatomic,assign)TIMETYPE timeType;

@property (nonatomic,strong)NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *orderIdL;
@property (weak, nonatomic) IBOutlet UIButton *daiBoBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *carMasterImage;
@property (weak, nonatomic) IBOutlet UILabel *carMasterNameL;
@property (weak, nonatomic) IBOutlet UILabel *carMasterPhone;
@property (weak, nonatomic) IBOutlet UILabel *jieCheTime;
@property (weak, nonatomic) IBOutlet UILabel *quCheTime;
@property (weak, nonatomic) IBOutlet UILabel *tingCheTime;
@property (weak, nonatomic) IBOutlet UILabel *quCheOutTime;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIScrollView *imageViewScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carImageLeading;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel0;

- (void)stopTimer;


@end
