//
//  YuYueBtnCell.h
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuYueBtnCell : UITableViewCell
@property (nonatomic,copy)void (^commitYueYue)();
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end
