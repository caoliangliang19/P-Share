//
//  HistoryCell.h
//  linTingJieMianDemo
//
//  Created by fay on 16/2/15.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchOrderDelegate <NSObject>

- (void)searchOrder;

- (void)searchBtnClickWithButton:(UIButton *)btn;

- (void)goToCarMasterVC;



@end

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (nonatomic,assign)id<SearchOrderDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *carNum1;
@property (weak, nonatomic) IBOutlet UIButton *carNum2;
@property (weak, nonatomic) IBOutlet UIButton *carNum3;
@property (weak, nonatomic) IBOutlet UILabel *historyL;
@property (weak, nonatomic) IBOutlet UILabel *orderNumL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumWidth;

@end
