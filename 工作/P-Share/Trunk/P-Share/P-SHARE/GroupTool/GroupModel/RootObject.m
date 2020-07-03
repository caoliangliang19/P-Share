//
//  RootObject.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@implementation RootObject
+ (instancetype)shareObjectWithDic:(NSDictionary *)dic
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
- (void)setNilValueForKey:(NSString *)key
{
    MyLog(@"setNilValueForKey --->%@",key);
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
//    MyLog(@"UndefinedKey ---->%@",key);
    
}
@end
