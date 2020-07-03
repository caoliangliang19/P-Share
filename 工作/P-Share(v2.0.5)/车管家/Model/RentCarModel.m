//
//  RentCarModel.m
//  P-Share
//
//  Created by fay on 16/3/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "RentCarModel.h"

@implementation RentCarModel
+ (RentCarModel *)shareRentCarModel:(NSDictionary *)dic
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
    
}

@end
