//
//  PingZhengCell.h
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PingZhengCellDelegate <NSObject>

- (void)clickPingBtn:(NSInteger)index tableView:(NSString *)type;

@end
@interface PingZhengCell : UITableViewCell
@property (assign, nonatomic)NSInteger index;
@property (copy, nonatomic)NSString *tableViewType;
@property (assign ,nonatomic)id<PingZhengCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameL;
@property (weak, nonatomic) IBOutlet UIButton *pingZhengBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
