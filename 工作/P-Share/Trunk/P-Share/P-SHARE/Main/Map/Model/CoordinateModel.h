//
//  CoordinateModel.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface CoordinateModel : BaseView
/**
 *  纬度
 */
@property (nonatomic,assign)CGFloat latitude;
/**
 *  经度
 */
@property (nonatomic,assign)CGFloat longitude;

+ (instancetype)shareCoordinateModelWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;
- (id)initWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


@end
