//
//  PayStatusView.h
//  P-Share
//
//  Created by fay on 16/6/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YuYueView;
@class DaiBoInfoV;
@class DaoHangView;
typedef enum {
    PayKindDaiBo,//代泊
    PayKindYuYue,//预约
    PayKindDaoHang//导航
}PayStatusViewKind;
@interface PayStatusView : UIView
@property (nonatomic,strong)ParkingModel                *dataModel;
@property (nonatomic,assign)PayStatusViewKind           status;
@property (nonatomic,strong)DaiBoInfoV                  *daiBoInfoV;
@property (nonatomic,strong)YuYueView                   *yuYueView;
@property (nonatomic,strong)UIView                      *bgView;//底层白色view
@property (nonatomic,copy)  NSString                    *distance;
@property (nonatomic,copy)void (^greenBtnClickBlock)(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV);
@property (nonatomic,copy)void (^tapGestureBlock)(PayStatusViewKind status,YuYueView *yuYueView,DaoHangView *daoHangV,DaiBoInfoV *daiBoV);

@end
