//
//  CoordinateModel.h
//  P-Share
//
//  Created by fay on 16/4/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateModel : NSObject
@property (nonatomic,assign) float latitude;//当前经度
@property (nonatomic,assign) float longitude;//当前纬度
+ (CoordinateModel *)shareCoodinateModel;

@end
