//
//  MapBottomSecondView.h
//  P-Share
//
//  Created by fay on 16/6/15.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayKindView,NewParkingModel;
@interface MapBottomSecondView : UIView
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)void (^payKindViewClick)(NewParkingModel *model,PayKindView *payKindView);

- (void)ActivityViewShow;
- (void)ActivityViewHidden;

@end
