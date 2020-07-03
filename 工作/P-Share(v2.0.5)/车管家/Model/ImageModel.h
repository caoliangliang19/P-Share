//
//  ImageModel.h
//  P-Share
//
//  Created by fay on 16/1/20.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic,copy)NSString *title,*sort,*imageType,*imagePath,*imageLink;

+ (ImageModel *)shareImageModelWith:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
