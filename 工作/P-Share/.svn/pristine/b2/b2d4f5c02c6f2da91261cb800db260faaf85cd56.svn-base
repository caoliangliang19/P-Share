//
//  SearchCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/17.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapSearchModel,SearchCell;
typedef enum {
    SearchCellStyleUnCollection,
    SearchCellStyleCollection
}SearchCellStyle;
typedef void(^SearchCellBlock) (SearchCell *searchCell);

@interface SearchCell : UITableViewCell
@property (nonatomic,assign)NSInteger row;
@property (nonatomic,assign)NSInteger second;
@property (nonatomic,copy)SearchCellBlock block;
@property (nonatomic,assign)SearchCellStyle searchCellStyle;
@property (weak, nonatomic) IBOutlet UILabel *textL;
@property (weak, nonatomic) IBOutlet UILabel *detailTextL;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteParking;
@property (nonatomic,strong)MapSearchModel *model;
- (IBAction)favoriteParking:(UIButton *)sender;

@end
