//
//  CoordinateModel.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CoordinateModel.h"

@implementation CoordinateModel

+ (instancetype)shareCoordinateModelWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    return [[self alloc]initWithLatitude:latitude longitude:longitude];
}
- (id)initWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    if (self == [super init]) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}
@end
