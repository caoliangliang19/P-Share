//
//  carDetailModel.m
//  P-Share
//
//  Created by fay on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "carDetailModel.h"
#import "CarKindModel.h"
@implementation carDetailModel
+ (carDetailModel *)sharecarDetailModel:(NSDictionary *)dic
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
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
        
    }else if ([key isEqualToString:@"childrenList"]){
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dic in value) {
            CarKindModel *carModel = [CarKindModel shareCarKindModel:dic];
            [arr addObject:carModel];
        }

        self.subCarArray = arr;
        
    }

}
@end
