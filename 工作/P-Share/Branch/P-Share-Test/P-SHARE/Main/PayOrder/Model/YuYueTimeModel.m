//
//  YuYueTimeModel.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueTimeModel.h"

@implementation YuYueTimeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
}

@end
