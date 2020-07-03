//
//  CarListCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CarListCellBlock) (NSInteger);
@interface CarListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driveDistance;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *driveTime;
@property (weak, nonatomic) IBOutlet UILabel *carInfo;
@property (nonatomic,copy)CarListCellBlock myBlock;
@property (nonatomic,assign) NSInteger second;
- (IBAction)myMoreCsrInfo;
@end
