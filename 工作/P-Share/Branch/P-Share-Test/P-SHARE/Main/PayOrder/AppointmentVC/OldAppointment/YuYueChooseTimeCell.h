//
//  YuYueChooseTimeCell.h
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseTimeView;
@interface YuYueChooseTimeCell : UITableViewCell
@property (nonatomic,strong)NSArray *timeArrar;
@property (nonatomic,strong)ChooseTimeView *currentTimeView;

@property (nonatomic,copy)void (^chooseTimeView)(ChooseTimeView *);

@end
