//
//  RentCarModel.h
//  P-Share
//
//  Created by fay on 16/3/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentCarModel : NSObject
@property (nonatomic,copy) NSString         *price,
                                            *jumpUrl,
                                            *imagePath,
                                            *name,
                                            *type;

+ (RentCarModel *)shareRentCarModel:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
