//
//  OrderListCell.h
//  P-Share
//
//  Created by fay on 16/3/4.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *myCellView;

@property (weak, nonatomic) IBOutlet UILabel *chinaName;
@property (weak, nonatomic) IBOutlet UIImageView *chinaImage;
@property (weak, nonatomic) IBOutlet UILabel *oilCardNo;
@property (weak, nonatomic) IBOutlet UILabel *payTimer;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *readyMoney;

@end
