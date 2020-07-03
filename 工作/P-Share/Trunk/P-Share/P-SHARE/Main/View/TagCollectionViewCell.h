//
//  TagCollectionViewCell.h
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagModel;
typedef enum {
    TagCollectionViewCellSelected,
    TagCollectionViewCellUnSelect,
}TagCollectionViewCellSelect;

typedef enum {
    TagCollectionViewCellZan,
    TagCollectionViewCellCai,
}TagCollectionViewCellStyle;
@interface TagCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)TagCollectionViewCellSelect     select;
@property (nonatomic,assign)TagCollectionViewCellStyle      style;
@property (nonatomic,strong)TagModel                        *model;
@end
