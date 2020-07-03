//
//  CarSetVC.h
//  P-Share
//
//  Created by fay on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarSetVC : UIViewController
@property (nonatomic,retain)NewCarModel *carModel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *descributeL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;

@end
