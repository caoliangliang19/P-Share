//
//  DataSource.m
//  P-Share
//
//  Created by 亮亮 on 16/2/23.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
+ (instancetype)shareInstance
{
    static DataSource *source = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source = [[DataSource alloc] init];
    });
    return source;
    
}

- (void)setModel:(ParkingModel *)model
{
    _model = model;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:model.parkingId forKey:KCarLiftModelID];
    [userDefault setObject:model.parkingName forKey:KCarLiftModelName];

    [userDefault synchronize];

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.temParkingArray = [NSMutableArray array];
        self.rentStopArray = [NSMutableArray array];
        self.oilCardListArray = [NSMutableArray array];
        self.oilOrderListArray = [NSMutableArray array];
        self.noPayForArray = [NSMutableArray array];
        self.yesPayForArray = [NSMutableArray array];
        
    }
    
    return self;
}

@end
