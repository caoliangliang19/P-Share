//
//  YuYueCell.h
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuYueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainL;
@property (weak, nonatomic) IBOutlet UILabel *subL;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLayout0;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
