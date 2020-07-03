//
//  TradeDetailVC.h
//  P-Share
//
//  Created by fay on 16/4/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TradeStyleLinTing = 0,
    TradeStyleYueZu,
    TradeStyleWashCar,
    TradeStylelinTing,
    
}TradeStyle;
@interface TradeDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic,copy)NSDictionary *dataDic;
@property (nonatomic,strong)TemParkingListModel *pingZhengModel;
@property (nonatomic,assign)TradeStyle style;
//@property (nonatomic,copy)NSString *orderType;//月租 产权
@end
