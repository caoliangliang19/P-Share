//
//  selfAlertView.h
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"



@interface selfAlertView : UIView

- (void)getUserCarArrayWhenCompetion:(void (^)())completion Failure:(void(^)())failure;

- (void)removeView;

@property (nonatomic,copy)void (^nextStep)(CarModel *model);
@property (nonatomic,retain)UIView *grayView;
@property (nonatomic,assign)BOOL isHiddenGrayView;

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *btnStr;

@end
