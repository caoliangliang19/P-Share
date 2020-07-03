//
//  MonthPropertyVC.h
//  P-Share
//
//  Created by 亮亮 on 16/8/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , MonthPropertyVCStyle){
    MonthPropertyVCStyleYueZu      =  0,
    MonthPropertyVCStyleChanQuan
};

@interface MonthPropertyVC : BaseViewController

@property (nonatomic,assign)MonthPropertyVCStyle monthPropertyVCStyle;
//用来存储订单的相关信息
@property (nonatomic,strong)OrderModel *orderModel;
@end
