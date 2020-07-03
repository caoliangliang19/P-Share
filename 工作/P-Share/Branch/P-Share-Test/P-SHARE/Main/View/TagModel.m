//
//  TagModel.m
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel
+ (TagModel *)shareTagModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        MyLog(@"%@",self.info);
        [self setValuesForKeysWithDictionary:dic];
        MyLog(@"%@",self.info);

    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
