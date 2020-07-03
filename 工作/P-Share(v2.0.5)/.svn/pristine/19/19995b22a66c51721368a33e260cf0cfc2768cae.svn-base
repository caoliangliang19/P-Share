//
//  AllHistoryCell.h
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyClickDelegate <NSObject>

- (void)onClickEvent;

@end
@interface AllHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClick:(id)sender;
@property (nonatomic,assign)id<MyClickDelegate> delegate;
@end
