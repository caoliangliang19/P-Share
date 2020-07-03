//
//  OrderPointModel.m
//  P-Share
//
//  Created by fay on 16/3/31.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "OrderPointModel.h"

static OrderPointModel *orderPoint = nil;


@implementation OrderPointModel

+ (OrderPointModel *)shareOrderPointModelWithDic:(NSDictionary *)dic
{
    @synchronized(self) {
        
        if (orderPoint == nil) {
            
            orderPoint = [[self alloc] initWithDic:dic];
            
        }
    }
    return orderPoint;
    
}
- (id)initWithDic:(NSDictionary *)dic
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self setValuesForKeysWithDictionary:dic];
        
    });
    
    return self;
    
    
}
+ (id)shareOrderPoint
{
    @synchronized(self) {
        if (!orderPoint) {
            orderPoint = [[OrderPointModel alloc] init];
            
        }
    }
    
    return orderPoint;
    
}
+ (id)alloc
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (orderPoint == nil) {
            orderPoint = [super alloc];
        }
    });
    return orderPoint;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
