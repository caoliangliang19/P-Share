//
//  ShareModel.h
//  P-SHARE
//
//  Created by fay on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@interface ShareModel : RootObject
/**
 *  标题
 */
@property (nonatomic,copy)NSString  *title;
/**
 *  描述文字
 */
@property (nonatomic,copy)NSString  *describute;
/**
 *  活动图片链接
 */
@property (nonatomic,copy)NSString  *imagePath;
/**
 *  活动链接
 */
@property (nonatomic,copy)NSString  *url;
@end
