//
//  TableViewCell.h
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum CellStyle{
    CellStyleUnSelect = 0,       //没有选择
    CellStyleSelect= 1,         //已选择

    
}CellStyle;

typedef enum CellKind{
    CellCellKindParking = 0,       //停车场
    CellCellKindCarNum= 1,         //车牌号
    
    
}CellKind;


@interface MapCell : UITableViewCell

@property (nonatomic,assign)CellStyle style;
@property (nonatomic,assign)CellStyle kind;

@property (nonatomic,retain)UIImageView *imgV;
@property (nonatomic,retain)UILabel *infoL;
@property (nonatomic,retain)UIImageView *selectImgV;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithKind:(CellKind)kind;


@end



