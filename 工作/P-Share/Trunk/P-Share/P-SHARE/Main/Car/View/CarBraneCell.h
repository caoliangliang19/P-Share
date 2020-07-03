//
//  CarBraneCell.h
//  P-Share
//
//  Created by fay on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CarBraneCellTypeNormal,//正常车系
    CarBraneCellTypeHot,//热门车系
}CarBraneCellType;
@interface CarBraneCell : UICollectionViewCell

@property (nonatomic,assign)CarBraneCellType type;
@property (nonatomic,assign)BOOL needLine;
@property (nonatomic,retain)NSDictionary *dataDic;

@end
