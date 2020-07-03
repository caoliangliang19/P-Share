//
//  CarListCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarListCell : UITableViewCell

@property (nonatomic,strong)Car *car;

@property (nonatomic,copy)void (^carListCellBlock)(CarListCell *);


@end
