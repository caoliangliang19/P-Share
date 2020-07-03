//
//  NewMonthlyRentAuthCodeCell.h
//  P-Share
//
//  Created by fay on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMonthlyRentAuthCodeCellDeleaget <NSObject>

- (void)getAuthCodeWith:(UIButton *)btn;
- (void)sureCommitAuthCode:(UIButton *)btn;


@end

@interface NewMonthlyRentAuthCodeCell : UITableViewCell

@property (nonatomic,weak)id <NewMonthlyRentAuthCodeCellDeleaget>delegate;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UITextField *authCode;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;

@end
