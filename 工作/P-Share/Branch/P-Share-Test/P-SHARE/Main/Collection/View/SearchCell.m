//
//  SearchCell.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/17.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "SearchCell.h"
#import "MapSearchModel.h"
@implementation SearchCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSearchCellStyle:(SearchCellStyle)searchCellStyle
{
    _searchCellStyle = searchCellStyle;
    if (searchCellStyle == SearchCellStyleUnCollection) {
        _favoriteParking.image = [UIImage imageNamed:@"unCollection_v2"];
    }else
    {
        _favoriteParking.image = [UIImage imageNamed:@"collection_v2"];

    }
}
- (void)setModel:(MapSearchModel *)model
{
    _model = model;
    self.textL.text = model.searchTitle;
    self.detailTextL.text = model.searchDistrict;
    self.searchCellStyle = model.isCollection ? SearchCellStyleCollection:SearchCellStyleUnCollection;
}
- (IBAction)favoriteParking:(UIButton *)sender {
    if (self.block) {
        self.block(self);
    }
}
@end
