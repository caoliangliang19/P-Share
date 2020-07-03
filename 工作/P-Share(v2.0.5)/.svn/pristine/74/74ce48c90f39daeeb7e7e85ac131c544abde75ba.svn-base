//
//  NewCarModel.m
//  P-Share
//
//  Created by fay on 16/4/5.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "NewCarModel.h"

@implementation NewCarModel

+ (NewCarModel *)shareNewModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
    
}
- (id)initWithDic:(NSDictionary *)dic
{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    
    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"identity"]) {
        self.carIdentity = value;
        
    }else if ([key isEqualToString:@"isAutoPay"]){
        self.carIsAutoPay = value;
        
    }
}
@end
