//
//  NetWorkEngine.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络引擎
 */
@interface NetWorkEngine : NSObject
/**
 *  post 请求
 *
 *  @param url     接口地址
 *  @param dic     参数
 *  @param need    是否需要加密
 *  @param needAlert    是否需要弹框
 *  @param showHub 是否展示hub
 *  @param success 请求成功
 *  @param error   请求错误
 *  @param failure 请求失败
 */
+ (NSURLSessionDataTask *)postRequestUse:(id)use WithURL:(NSString *)url WithDic:(NSDictionary *)dic
            needEncryption:(BOOL)need
                 needAlert:(BOOL)needAlert
                   showHud:(BOOL)showHub
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     error:(void (^)(NSString *error))error
                   failure:(void (^)(NSString *fail))failure;

/**
 *  get 请求
 *
 *  @param url     接口地址
 *  @param dic     参数
 *  @param needAlert    是否需要弹框
 *  @param showHub 是否展示hub
 *  @param success 请求成功
 *  @param error   请求错误
 *  @param failure 请求失败
 */
+ (NSURLSessionDataTask *)getRequestUse:(id)use WithURL:(NSString *)url WithDic:(NSDictionary *)dic
                needAlert:(BOOL)needAlert
                  showHud:(BOOL)showHub
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    error:(void (^)(NSString *error))error
                  failure:(void (^)(NSString *fail))failure;

/**
 *  post 请求
 *
 *  @param url     接口地址
 *  @param dic     参数
 *  @param need    是否需要加密
 *  @param needAlert    是否需要弹框
 *  @param showHub 是否展示hub
 *  @param success 请求成功
 *  @param error   请求错误
 *  @param failure 请求失败
 */
+ (NSURLSessionDataTask *)postRequestUse:(id)use AddErrorObjectWithURL:(NSString *)url WithDic:(NSDictionary *)dic
            needEncryption:(BOOL)need
                 needAlert:(BOOL)needAlert
                   showHud:(BOOL)showHub
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     error:(void (^)(id responseObject))error
                   failure:(void (^)(NSString *fail))failure;
/**
 *  上传图片
 *
 *  @param url             url
 *  @param ratio           图片压缩比
 *  @param imageArray      图片数组
 *  @param dic             参数
 *  @param completion      完成回到
 *  @param sessionProgress 进度
 *  @param fail            失败回调
 */
//+ (void)postImageWithURL:(NSString *)url ScareRatio:(CGFloat)ratio WithImage:(UIImage *)image WithDic:(NSDictionary *)dic Completion:(void(^)(NSArray *dataArray))completion WithProgress:(void (^)(NSProgress *progress))sessionProgress Fail:(void (^)(NSString *error))fail;

@end
