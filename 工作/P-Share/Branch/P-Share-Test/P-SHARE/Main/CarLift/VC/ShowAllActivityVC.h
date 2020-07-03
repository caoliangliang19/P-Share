//
//  ShowAllActivityVC.h
//  P-SHARE
//
//  Created by fay on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    ShowAllActivityVCTypeActity, //优惠活动
    ShowAllActivityVCTypeExperience//用车心得
}ShowAllActivityVCType;
@interface ShowAllActivityVC : BaseViewController

@property (nonatomic,assign)ShowAllActivityVCType showAllActivityVCType;

@end
