//
//  TableViewCell.h
//  linTingJieMianDemo
//
//  Created by fay on 16/2/15.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayOrderDelegate <NSObject>

- (void)payOrderWithBtn:(UIButton *)btn;

- (void)agreeBtnClickDelegate:(UIButton *)btn;

- (void)goToWebViewVC;


@end

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *parkingTimeL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet UILabel *infoL;

@property (nonatomic,assign)id<PayOrderDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidth;

@end
