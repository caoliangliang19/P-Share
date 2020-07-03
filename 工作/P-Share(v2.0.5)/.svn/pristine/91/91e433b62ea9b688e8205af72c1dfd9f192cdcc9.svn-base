//
//  TemParkingListModel.m
//  P-Share
//
//  Created by fay on 16/2/17.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "TemParkingListModel.h"

@implementation TemParkingListModel
+ (TemParkingListModel *)shareTemParkingListModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
    
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"count"]) {
        _waitCarCount = value;
        
    }
    
}
@end
