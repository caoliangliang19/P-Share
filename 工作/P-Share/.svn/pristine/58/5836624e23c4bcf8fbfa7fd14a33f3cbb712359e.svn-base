//
//  WebInfoModel.h
//  P-SHARE
//
//  Created by fay on 16/9/13.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"
typedef enum {
    WebInfoModelTypeNoShare = 0,//不需要分享
    WebInfoModelTypeShare//带有分享
}WebInfoModelType;
typedef enum {
    URLTypeNet = 0,//网络
    URLTypeNetLocal,//本地
    URLTypeNetLocalData,//本地data
}URLType;
@interface WebInfoModel : RootObject
/**
 *  url地址
 */
@property (nonatomic,copy)NSString *url;
/**
 *  活动图片地址
 */
@property (nonatomic,copy)NSString *imagePath;
/**
 *  是否是网络链接 1:网络  0:本地
 */
@property (nonatomic,assign)BOOL isNetUrl;
/**
 *  url类型
 */
@property (nonatomic,assign)URLType urlType;
/**
 *  活动名称
 */
@property (nonatomic,copy)NSString *title;
/**
 *  活动名称
 */
@property (nonatomic,copy)NSString *descibute;
/**
 *  分享类型
 */
@property (nonatomic,assign)WebInfoModelType shareType;
@end
