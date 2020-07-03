//
//  CarLiftModel.m
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CarLiftModel.h"

@implementation CarLiftModel
+ (CarLiftModel *)shareLiftModelWift:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self == [super init] ) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
        
    }
}
@end
