//
//  WenQuanModel.m
//  P-Share
//
//  Created by fay on 16/3/8.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "WenQuanModel.h"

@implementation WenQuanModel
+ (WenQuanModel *)shareWenQuanModelWithDic:(NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
    
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
        
        _ID = value;
        
    }
}
@end
