//
//  SelectParkController.h
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectParkingDelegate <NSObject>

- (void)refreshParking;

@end
@interface SelectParkController : UIViewController
- (IBAction)backFrom:(UIButton *)sender;


@property (nonatomic , assign)id<selectParkingDelegate>delegate;

@end
