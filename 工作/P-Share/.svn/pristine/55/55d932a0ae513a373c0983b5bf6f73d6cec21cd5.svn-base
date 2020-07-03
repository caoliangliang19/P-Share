//
//  DistanceCell.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceCell : UITableViewCell

@property (nonatomic , assign)NSInteger index;

@property (nonatomic , strong)UIView *bgView;

@property (nonatomic , strong)UILabel *distanceTypeL;

@property (nonatomic , strong)UILabel *parkingNameL;

@property (nonatomic , strong)UILabel *payTimeL;

@property (nonatomic , strong)UILabel *carNumberL;

@property (nonatomic , strong)UIButton *lookUpBtn;

@property (nonatomic , copy)void(^lookUpPingZ)(NSInteger);

+(instancetype)instanceTableView:(UITableView *)tableView;

- (void)upDataModel:(OrderModel *)model;
@end
