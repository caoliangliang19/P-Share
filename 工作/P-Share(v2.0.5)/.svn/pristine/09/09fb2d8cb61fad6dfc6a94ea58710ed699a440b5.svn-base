//
//  YuYueTimeModel.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueTimeModel.h"

@implementation YuYueTimeModel
- (id)initWithDic:(NSDictionary *)dic
{
   
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}
+ (YuYueTimeModel *)shareYuYUeTimeModel:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}

@end
