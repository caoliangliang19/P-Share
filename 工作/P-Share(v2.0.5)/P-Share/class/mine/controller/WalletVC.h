//
//  WalletVC.h
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface WalletVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,assign)BOOL couponRedPoint;

@end
