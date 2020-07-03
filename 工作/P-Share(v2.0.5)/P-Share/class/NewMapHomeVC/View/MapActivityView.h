//
//  MapActivityView.h
//  P-Share
//
//  Created by fay on 16/6/14.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapActivityView : UIView

@property (nonatomic,strong)NSArray *activityArray;
@property (nonatomic,copy)void (^hiddenActivtyView)();
@property (nonatomic,copy)void (^washCarBlock)();
@end
