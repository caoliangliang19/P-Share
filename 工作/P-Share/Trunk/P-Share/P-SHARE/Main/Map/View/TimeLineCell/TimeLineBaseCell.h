//
//  TimeLineBaseCell.h
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TimeLineBaseCellPositionStyleTop = 0,
    TimeLineBaseCellPositionStyleMiddle,
    TimeLineBaseCellPositionStyleBottom,
    TimeLineBaseCellPositionStyleSingleTop,

}TimeLineBaseCellPositionStyle;
@interface TimeLineBaseCell : UITableViewCell

/**
  cell所处的位置
 */
@property (nonatomic,assign)TimeLineBaseCellPositionStyle positionStyle;
@property (nonatomic,strong)UIView              *lineView;

@property (nonatomic,strong)UIImageView         *bubbleImageV;
@property (nonatomic,strong)OrderModel          *orderModel;
/**
    初始化UI控件
 */
- (void)setUI;
@end
