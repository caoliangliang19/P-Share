//
//  NoPayForCell.h
//  P-Share
//
//  Created by 亮亮 on 16/3/16.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellClickEvent <NSObject>

- (void)payFor:(NSInteger)index;
- (void)canclePayFor:(NSInteger)index;

@end

@interface NoPayForCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payForTitleL;
@property (weak, nonatomic) IBOutlet UIView *LineView;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xuFeiMoneyW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xuFeiTimeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xuFeiGoTimeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderLH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderLH1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLay;

@property (weak, nonatomic) IBOutlet UILabel *xuFeiGoTimeL;
@property (weak, nonatomic) IBOutlet UILabel *xuFeiTimeL;

@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *getDateTimeL;
@property (weak, nonatomic) IBOutlet UILabel *payTimerL;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderBeginTimerL;
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
@property (weak, nonatomic) IBOutlet UILabel *payForMoneyL;
@property (weak, nonatomic) IBOutlet UIButton *canclePayFor;
@property (weak, nonatomic) IBOutlet UIButton *payFor;
@property (assign,nonatomic)NSInteger index;
@property (assign,nonatomic)id<cellClickEvent>myDelegate;

- (IBAction)canclePayFor:(id)sender;
- (IBAction)payFor:(id)sender;
@end
