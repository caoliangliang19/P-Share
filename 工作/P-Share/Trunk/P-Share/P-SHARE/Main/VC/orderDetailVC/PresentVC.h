//
//  PresentVC.h
//  P-SHARE
//
//  Created by 亮亮 on 16/11/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentVC : UIViewController

@property (nonatomic , strong)NSMutableArray *imageArray;

@property (nonatomic , assign)NSInteger tap;

/**
 *  显示下标
 */
@property(nonatomic, strong) UILabel *sliderLabel;

@end
