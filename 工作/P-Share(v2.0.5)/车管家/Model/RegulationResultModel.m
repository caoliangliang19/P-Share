//
//  RegulationResultModel.m
//  P-Share
//
//  Created by fay on 16/1/19.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "RegulationResultModel.h"
#import "RegulationsModel.h"

@implementation RegulationResultModel
+ (RegulationResultModel *)shareRegulationresultModelWithDic:(NSDictionary *)dic
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
    if ([key isEqualToString:@"lists"]) {
        NSArray *arr = value;
        NSMutableArray *temArr = [[NSMutableArray alloc] init];
    
        for (NSDictionary *dic in arr) {
            RegulationsModel *model = [RegulationsModel shareRegulationresultModelWithDic:dic];
            [temArr addObject:model];
        }
        _listsArray = temArr;
        
    }
}
@end
