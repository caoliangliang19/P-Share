//
//  SearchCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/17.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SearchCellBlock) (NSInteger,NSInteger);

@interface SearchCell : UITableViewCell
@property (nonatomic,assign)NSInteger row;
@property (nonatomic,assign)NSInteger second;
@property (nonatomic,copy)SearchCellBlock block;

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteParking;

- (IBAction)favoriteParking:(UIButton *)sender;

@end
