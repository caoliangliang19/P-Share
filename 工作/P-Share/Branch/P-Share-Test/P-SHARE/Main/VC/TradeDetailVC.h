//
//  TradeDetailVC.h
//  P-Share
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef enum {
    TradeStyleLinTing = 0,
    TradeStyleYueZu,
    TradeStyleWashCar,
    TradeStylelinTing,
    
}TradeStyle;
@interface TradeDetailVC : BaseViewController
@property (nonatomic,copy)NSDictionary *dataDic;
@property (nonatomic,strong)OrderModel *order;
@property (nonatomic,assign)TradeStyle style;
@end
