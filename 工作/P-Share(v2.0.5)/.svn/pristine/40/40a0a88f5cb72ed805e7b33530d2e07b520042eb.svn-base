//
//  AddOilCard.h
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OilCardModel.h"
@protocol passOnModel <NSObject>

- (void)passOnChange:(OilCardModel *)model;

@end

@interface AddOilCard : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (assign ,nonatomic)id<passOnModel>delegate;

- (IBAction)addOilCardClick:(id)sender;

@property (nonatomic,copy)NSString *addSucceed;
@end
