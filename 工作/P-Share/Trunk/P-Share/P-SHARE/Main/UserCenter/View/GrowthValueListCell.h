//
//  GrowthValueListCell.h
//  P-Share
//
//  Created by fay on 16/8/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    GrowthValueListCellColorStyleGray,
    GrowthValueListCellColorStyleNormal,
}GrowthValueListCellColorStyle;
@interface GrowthValueListCell : UITableViewCell
@property (nonatomic,assign)GrowthValueListCellColorStyle colorStyle;
@end
