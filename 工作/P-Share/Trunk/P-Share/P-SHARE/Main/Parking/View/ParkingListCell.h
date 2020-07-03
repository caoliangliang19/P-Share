//
//  ParkingListCell.h
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ParkingListCellStyleUnSelect,
    ParkingListCellStyleSelect
}ParkingListCellStyle;
@interface ParkingListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,strong)Parking *parking;
@property (nonatomic,assign)ParkingListCellStyle parkingListCellStyle;

@property (nonatomic,copy)void (^parkingListCellBlock)(ParkingListCell *cell);


@end
