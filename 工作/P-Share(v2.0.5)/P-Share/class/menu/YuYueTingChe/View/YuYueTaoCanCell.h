//
//  YuYueTaoCanCell.h
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YuYueTimeModel;
typedef enum {
    YuYueTaoCanCellStyleOne,
    YuYueTaoCanCellStyleTwo,

}YuYueTaoCanCellStyle;

typedef enum {
    
    YuYueTaoCanCellSelectStyleUnSelect,
    YuYueTaoCanCellSelectStyleSelected,
    
}YuYueTaoCanCellSelectStyle;
@interface YuYueTaoCanCell : UITableViewCell
@property (nonatomic,assign)YuYueTaoCanCellStyle style;
@property (nonatomic,assign)YuYueTaoCanCellSelectStyle selectStyle;
@property (nonatomic,strong)YuYueTimeModel *model;
@property (nonatomic,strong)NSArray *timeArrar;
@property (nonatomic,strong)UILabel *titleLabel;



@end
