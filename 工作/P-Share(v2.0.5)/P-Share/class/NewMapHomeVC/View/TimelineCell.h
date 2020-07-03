//
//  TimelineCell.h
//  P-Share
//
//  Created by fay on 16/6/16.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeLineView;
@class TemParkingListModel;
typedef enum {
    TimelineCellPositionTop,    //第一个cell
    TimelineCellPositionMiddle, //中间的cell
    TimelineCellPositionBottom, //最后一个cell
}TimelineCellPosition;

@interface TimelineCell : UITableViewCell
@property (nonatomic,assign)TimelineCellPosition cellPosition;
@property (nonatomic,strong)UIView              *lineView;
@property (nonatomic,strong)TimeLineView        *timeLineView;
@property (nonatomic,assign)NSInteger           totalRowNum;


@property (nonatomic,strong)TemParkingListModel *temModel;


/**
 *  先给出类型  再给出状态： 支付状态
 */
@property (nonatomic,assign)int                 payStatus;
/**
 *  先给出类型  再给出状态：支付类型 0:代泊 1:预约停车
 */
@property (nonatomic,assign)int                 payTyle;

@end
