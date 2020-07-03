//
//  SelectView.h
//  选择tableView
//
//  Created by 亮亮 on 16/9/5.
//  Copyright © 2016年 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewDelegate <NSObject>

- (void)selectBtn:(UIButton *)button;

@end

@interface SelectView : UIView

- (instancetype)initWithController:(UIViewController *)pearentVC;

@property (nonatomic, weak)id<SelectViewDelegate>delegate;

@property (nonatomic , strong)NSMutableArray *selectArray;

@property (nonatomic ,assign)NSInteger selectIndex;

@end
