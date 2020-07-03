//
//  CityModel.m
//  LoadDataForPickViewDemo
//
//  Created by fay on 16/1/18.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+ (CityModel *)shareCityModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
