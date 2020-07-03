//
//  ShareHistoryCell.h
//  P-Share
//
//  Created by 亮亮 on 15/12/31.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myCellDelegate <NSObject>

- (void)myCellButtonClick;

@end

@interface ShareHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myLable;

@property (weak, nonatomic) IBOutlet UIButton *stopCarButton;
- (IBAction)stopCar:(UIButton *)sender;

@property (nonatomic,assign)id<myCellDelegate> delegate;
@end
