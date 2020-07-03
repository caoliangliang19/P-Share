//
//  provinceModel.m
//  LoadDataForPickViewDemo
//
//  Created by fay on 16/1/18.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "provinceModel.h"
#import "CityModel.h"

@implementation provinceModel
+ (provinceModel *)shareProvinceModelWithDic:(NSDictionary *)dic
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
    if ([key isEqualToString:@"citys"]) {
        
        NSArray *temArray = value;

        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in temArray) {
            CityModel *city = [CityModel shareCityModelWithDic:dic];
            [array addObject:city];
            
        }
        _cityArrays = array;
        
    }
    
}
@end
