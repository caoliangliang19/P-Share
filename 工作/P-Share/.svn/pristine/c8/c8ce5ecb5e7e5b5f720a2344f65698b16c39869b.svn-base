//
//  NetWorkEngine.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "NetWorkEngine.h"
#import "UIViewController+Swizzling.h"
@implementation NetWorkEngine
#pragma mark -- post请求
+ (NSURLSessionDataTask *)postRequestUse:(id)use WithURL:(NSString *)url WithDic:(NSDictionary *)dic
            needEncryption:(BOOL)need
                 needAlert:(BOOL)needAlert
                   showHud:(BOOL)showHub
                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     error:(void (^)(NSString *error))error
                   failure:(void (^)(NSString *fail))failure
{
    GroupManage *groupManage = [GroupManage shareGroupManages];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
//    manager.
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (need) {
        //          需要加密
        NSArray *sortArray = [self sortDicWithKeyArray:[dic allKeys]];
        
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (int i = 0;i<sortArray.count; i++) {
            [tempStr appendString:dic[sortArray[i]]];
        }
        
        [tempStr appendString:SECRET_KEY];
        NSString *summaryStr = [tempStr MD5];
        [dict setValue:summaryStr forKey:@"summary"];
    }
    
    MyLog(@"%@",dict);
    
    
    if (showHub) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [groupManage groupHubShow];
        });
    }

   

    NSURLSessionDataTask *dataTask = [manager POST:URL.absoluteString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success && [JSON[@"errorNum"] isEqualToString:@"0"]) {
            
            success(task,JSON);
        }else
        {
            if (needAlert) {
                [groupManage groupAlertShowWithTitle:JSON[@"errorInfo"]];
            }
            if (error) {
                error(JSON[@"errorInfo"]);
            }
        }
        
        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }
        if (needAlert) {
            [groupManage groupAlertShowWithTitle:NETWORKINGERROE];
        }

        if (failure) {
            failure(NETWORKINGERROE);
        }
    }];
    
    MyLog(@"dataTask.taskIdentifier post:%ld",dataTask.taskIdentifier);
    [NetWorkEngine addTaskRquest:dataTask tagContainer:use];
    return dataTask;
}


#pragma mark -- get请求
+ (NSURLSessionDataTask *)getRequestUse:(id)use WithURL:(NSString *)url WithDic:(NSDictionary *)dic
                needAlert:(BOOL)needAlert
                  showHud:(BOOL)showHub
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    error:(void (^)(NSString *error))error
                  failure:(void (^)(NSString *fail))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    
    GroupManage *groupManage = [GroupManage shareGroupManages];
    
    if (showHub) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [groupManage groupHubShow];
        });
    }
    
    NSString *encodeStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *dataTask = [manager GET:encodeStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
        MyLog(@"%@",[NSThread currentThread]);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (success && [responseObject[@"errorNum"] isEqualToString:@"0"]) {
                success(task,responseObject);
            }else
            {
                if (error) {
                    if (needAlert) {
                        [groupManage groupAlertShowWithTitle:responseObject[@"errorInfo"]];
                    }
                    error(responseObject[@"errorInfo"]);
                }
            }
        }else
        {
            if (error) {
                if (needAlert) {
                    [groupManage groupAlertShowWithTitle:SERVERERROR];
                }
                error(SERVERERROR);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        
        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }
        if (failure) {
            failure(NETWORKINGERROE);
        }
        if (needAlert) {
            [groupManage groupAlertShowWithTitle:NETWORKINGERROE];
        }
        
    }];
    MyLog(@"dataTask.taskIdentifier get:%ld",dataTask.taskIdentifier);
    [NetWorkEngine addTaskRquest:dataTask tagContainer:use];
    
    return dataTask;
}
+ (NSURLSessionDataTask *)postRequestUse:(id)use AddErrorObjectWithURL:(NSString *)url WithDic:(NSDictionary *)dic
                          needEncryption:(BOOL)need
                               needAlert:(BOOL)needAlert
                                 showHud:(BOOL)showHub
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   error:(void (^)(id responseObject))error
                                 failure:(void (^)(NSString *fail))failure
{
    GroupManage *groupManage = [GroupManage shareGroupManages];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    //    manager.
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (need) {
        //          需要加密
        NSArray *sortArray = [self sortDicWithKeyArray:[dic allKeys]];
        
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (int i = 0;i<sortArray.count; i++) {
            [tempStr appendString:dic[sortArray[i]]];
        }
        
        [tempStr appendString:SECRET_KEY];
        NSString *summaryStr = [tempStr MD5];
        [dict setValue:summaryStr forKey:@"summary"];
    }
    
    MyLog(@"%@",dict);
    
    
    if (showHub) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [groupManage groupHubShow];
        });
    }
    
    NSURLSessionDataTask *dataTask = [manager POST:URL.absoluteString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success && [JSON[@"errorNum"] isEqualToString:@"0"]) {
            
            success(task,JSON);
        }else
        {
           
            error(JSON);
        }
        
        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        if (showHub) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupManage groupHubHidden];
            });
        }
        if (needAlert) {
            [groupManage groupAlertShowWithTitle:NETWORKINGERROE];
        }
        
        if (failure ) {
            failure(NETWORKINGERROE);
        }
    }];
    [NetWorkEngine addTaskRquest:dataTask tagContainer:use];

    return dataTask;

}


#pragma mark --将NSURLSessionDataTask 保存到ViewController的taskQueue中
+ (void)addTaskRquest:(NSURLSessionDataTask *)task tagContainer:(id)tag
{
    if ([tag isKindOfClass:[UIViewController class]]) {
        UIViewController *temVC = (UIViewController *)tag;
        [temVC addTask:task];
        
    }else if ([tag isKindOfClass:[UIView class]]){
        UIView *temView = (UIView *)tag;
        if (temView.viewController) {
            [temView.viewController addTask:task];
        }
    }
}

#pragma mark -- 对字典进行排序
+ (NSArray *)sortDicWithKeyArray:(NSArray *)keyArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [keyArray sortedArrayUsingDescriptors:descriptors];
    return resultArray;
    
}
@end
