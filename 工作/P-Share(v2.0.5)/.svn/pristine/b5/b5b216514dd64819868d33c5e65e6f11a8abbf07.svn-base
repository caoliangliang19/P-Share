//
//  PayKindView.h
//  P-Share
//
//  Created by fay on 16/6/15.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewParkingModel;

typedef enum {
    PayKindLinTing, //临停支付
    PayKindYueZu,   //月租支付
    PayKindChanQuan,//产权支付
    PayKindNoCar,   //未绑定车辆
    PayKindNoOrder, //没有订单
}PayKind;
@interface PayKindView : UIView
@property (nonatomic,strong)UIView          *bgView;
@property (nonatomic,assign)PayKind         payKind;
//@property (nonatomic,strong)ParkingModel    *model;
@property (nonatomic,strong)NewParkingModel *model;

@end
