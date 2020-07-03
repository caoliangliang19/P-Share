

//
//  RequestModel.m
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "RequestModel.h"
#import "ParkingModel.h"
#import "provinceModel.h"
#import "ImageModel.h"
#import "TemParkingListModel.h"
#import "NewParkingModel.h"
#import "DataSource.h"
#import "NewOrderModel.h"
#import "WenQuanModel.h"
#import "OilCardModel.h"
#import "OilOrderList.h"
#import "RentCarModel.h"
#import "CarMasterDescribeModel.h"
#import "DiscountModel.h"
#import "CouponModel.h"
#import "CarKindModel.h"
#import "CarLiftModel.h"
#import "ManagerModel.h"
#define APP_URL @"http://itunes.apple.com/lookup?id=1049233050"

@interface RequestModel ()
{
    MBProgressHUD *_mbView;
    UIAlertView *_alert;
}

@end



@implementation RequestModel

#pragma mark -- post请求
- (void)postRequestWithURL:(NSString *)url WithDic:(NSDictionary *)dic
                needEncryption:(BOOL)need
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                error:(void (^)(NSString *error))error
                failure:(void (^)(NSString *fail))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];

    NSURL *URL = [NSURL URLWithString:url];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (need) {
//          需要加密
        NSArray *sortArray = [self sortDicWithKeyArray:[dic allKeys]];
        
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (int i = 0;i<sortArray.count; i++) {
            [tempStr appendString:dic[sortArray[i]]];
        }
        
        [tempStr appendString:MD5_SECRETKEY];
        NSString *summaryStr = [tempStr MD5];
        [dict setValue:summaryStr forKey:SUMMARY];
    }
    
    MyLog(@"%@",dict);
    
    [manager POST:URL.absoluteString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(task,JSON);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(NETWORKINGERROE);
            
        }
    }];
    
}


#pragma mark -- get请求
- (void)getRequestWithURL:(NSString *)url WithDic:(NSDictionary *)dic
                  success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                    error:(void (^)(NSString *error))error
                  failure:(void (^)(NSString *fail))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success(task,responseObject);
            }
        }else
        {
            if (error) {
                error(SERVERERROR);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(NETWORKINGERROE);
        }
        
    }];
    

    
}

#pragma mark -- 获取AppStore上面的最新版本号
+ (void)requestPShareVersionWithCompletion:(void (^)(VersionModel *versionModel))completion
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",currentVersion,@"offxm001",@"ios",MD5_SECRETKEY] MD5];
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@/%@/%@/%@/%@",UPDATE,currentVersion,@"offxm001",@"ios",summary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       VersionModel *versionModel = [VersionModel shareVersionModelWithDic:responseObject[@"version"]];
       
       if (completion) {
           completion(versionModel);
       }
       
   } error:^(NSString *error) {
       
       
   } failure:^(NSString *fail) {
       
   }];
    
    
}


#pragma mark -- 实现用户注册
+ (void)requestRegisterWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))errorMsg
{
    
     NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] postRequestWithURL:urlString WithDic:dic needEncryption:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject);
        }

        
    } error:^(NSString *error) {
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
       
        if (errorMsg) {
            errorMsg(fail);
        }
        
    }];
    
    
}

#pragma mark -- 获取手机验证码，以及登陆
+ (void)requestGetPhoneNumWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))errorMsg
{
    
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion) {
            
            completion(responseObject);
            
        }
        
    } error:^(NSString *error) {
        
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }
        
    }];
    
    
    
    
}
#pragma mark -- 获取手机验证码，以及登陆
+ (void)requestGetPhoneNumNewWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))errorMsg
{
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] postRequestWithURL:urlString WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if (completion) {
            completion(responseObject);
        }
    } error:^(NSString *error) {
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }

    }];
    

}
//请求首页家和公司停车场
+ (void)requestFirstVCParkingWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))errorMsg
{
    
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSMutableArray *homeArray = [NSMutableArray array];
        if ([dict[@"code"] isEqualToString:@"000000"])
        {
            
            NSArray *dictArray = dict[@"datas"][@"parkingList"];
            [homeArray removeAllObjects];
            
            
            for (int i=0; i<2; i++) {
                ParkingModel *model = [[ParkingModel alloc]init];
                [homeArray addObject:model];
            }
            
            for (NSDictionary *tmpDict in dictArray){
                ParkingModel *model = [[ParkingModel alloc] init];
                [model setValuesForKeysWithDictionary:tmpDict];
                
                if ([model.indexParkingType isEqualToString:@"1"]) {
                    [homeArray replaceObjectAtIndex:0 withObject:model];
                    
                }else if ([model.indexParkingType isEqualToString:@"2"])
                {
                    [homeArray replaceObjectAtIndex:1 withObject:model];
                }
            }
            
        }else{
            
        }

        
    } error:^(NSString *error) {
        
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }
    }];
    

}


#pragma mark --获取车辆违规信息
+ (void)requestRegulationsWithURL:(NSDictionary *)dic Completion:(void (^)(RegulationResultModel *model))completion Error:(void (^)(NSString *errorStr))errorMsg Fail:(void (^)(NSString *error))failInfo
{
    
    [[self alloc] getRequestWithURL:JUHEREHULATIONSEARCH WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"resultcode"] isEqualToString:@"200"])
        {
            
            RegulationResultModel *resultModel = [RegulationResultModel shareRegulationresultModelWithDic: responseObject[@"result"]];
            if (completion) {
                completion(resultModel);
            }
        }
        else
        {
            if (errorMsg) {
                errorMsg(responseObject[@"reason"]);
            }
        }

        
    } error:^(NSString *error) {
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (failInfo) {
            failInfo(fail);
            
        }
    }];
    
    
}

#pragma mark --获取全国可以查询车辆违规的地区
+ (void)requestPickViewDataWithCompletion:(void (^)(NSArray *arr))completion
{
    
    [[self alloc] getRequestWithURL:JUHEURL WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *resultDic = responseObject[@"result"];
        
#pragma mark -- 加保护  防止请求数据错误
        if ([responseObject[@"resultcode"] isEqualToString:@"200"] == NO ) {
            return ;
        }
        
        NSArray *temArray = [resultDic allValues];
        
        NSMutableArray *resultArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in temArray) {
            provinceModel *province = [provinceModel shareProvinceModelWithDic:dic];
            [resultArr addObject:province];
        }
        if (completion) {
            completion(resultArr);
        }
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
}


+ (void)requestCarMasterLunBoImageWithURL:(NSString *)URL Completion:(void (^)(NSArray *resultArray))completion Fail:(void (^)(NSString *fail))failInfo
{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",CARMASTER_IMG,[MD5_SECRETKEY MD5]];
    
    
    [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *resultArr = [NSMutableArray array];
        NSArray *temArr = responseObject[@"eventPageList"];
        for (NSDictionary *dic in temArr) {
            ImageModel *model = [ImageModel shareImageModelWith:dic];
            [resultArr addObject:model];
        }
        if (completion) {
            completion(resultArr);
        }
    } error:^(NSString *error) {
        
        if (failInfo) {
            failInfo(error);
        }
        
    } failure:^(NSString *fail) {
        
        if (failInfo) {
            failInfo(fail);
        }
    }];
    
}

+ (void)requestCarMasterServerInfoWithParkingID:(NSString *)parkingID ServerID:(NSString *)serverID Completion:(void (^)(ServerInfoModel *serverInfoModel))completion Fail:(void (^)(NSString *errorMsg))errorMsg
{
        
    NSString *temStr = [NSString stringWithFormat:@"%@%@%@",parkingID,serverID,MD5_SECRETKEY];
    NSString *MD5_Str = [temStr MD5];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@",CARMASTER_SERVERINFO,parkingID,serverID,MD5_Str];
    
    
    [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"1"]) {
            if (errorMsg) {
                errorMsg(@"此停车场暂未开通,敬请期待");
                return ;
            }
        }
        
        NSDictionary *infoDic = responseObject[@"srvInfo"];
        
        ServerInfoModel *model = [ServerInfoModel shareModelWithDic:infoDic];
        
        if (completion) {
            completion(model);
            
        }
        
    } error:^(NSString *error) {
        
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }
    }];
    

}

//获取临停缴费订单
+ (void)requestTemParkingOrderWithURL:(NSString *)url WithTag:(NSString *)tag Completion:(void (^)(NSArray *resultArray))completion Fail:(void (^)(NSString *error))failInfo
{
    
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (failInfo) {
                failInfo(@"未查询到订单");
            }
            return ;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[tag]) {
            TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:dic];
            [resultArray addObject:model];
        }
        if (completion) {
            completion(resultArray);
            
        }
        
    } error:^(NSString *error) {
        
        if (failInfo) {
            failInfo(error);
        }
        
    } failure:^(NSString *fail) {
        if (failInfo) {
            failInfo(fail);
            
        }
    }];
    
}

//创建订单
+ (void)requestCreateTemparkingOrderWithURL:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(TemParkingListModel *model))completion Fail:(void (^)(NSString *error))failInfo
{
    
     NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *_temStr;
        if ([type isEqualToString:@"0"]) {
            if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
                
                if (failInfo) {
                    failInfo(responseObject[@"errorInfo"]);
                }
                return ;
            }
            _temStr = @"order";
        }else if ([type isEqualToString:@"1"]){
            if (![responseObject[@"errorNum"] isEqualToString:@"0"] && ![responseObject[@"errorNum"] isEqualToString:@"1"]) {
                failInfo(responseObject[@"errorInfo"]);
                return ;
            }
            _temStr = @"data";
        }
        
        TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:responseObject[_temStr]];
        if (completion) {
            
            completion(model);
            
        }
    } error:^(NSString *error) {
        if (failInfo) {
            failInfo(error);
        }
        
    } failure:^(NSString *fail) {
        if (failInfo) {
            failInfo(fail);
        }

    }];
    
    
}


//订单与可选优惠券绑定
+ (void)pinlessOrderAndConponWithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))failInfo
{

    
    [[self alloc] postRequestWithURL:REPAY WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (completion) {
            
            completion(dict);
            
        }
    } error:^(NSString *error) {
        
        if (failInfo) {
            failInfo(error);
        }
        
    } failure:^(NSString *fail) {
        if (failInfo) {
            failInfo(fail);
            
        }
    }];
    
    
}

//修改订单 以及修改优惠券信息
+ (void)changeOrderInfoWithURl:(NSString *)url Completion:(void (^)(NSString *info))completion Fail:(void (^)(NSString *error))fail
{
   
    
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            if ([responseObject[@"errorNum"] isEqualToString:@"2"]){
                fail(@"已存在当天凭证");
            }
            return ;
        }else{
            
            if (completion) {
                
                completion(@"success");
                
            }
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(@"提交失败");

        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(@"提交失败");
            
        }
    }];
    
}

//使用优惠券 post
+ (void)requestWithUserCouponWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
    
    [[self alloc] postRequestWithURL:USECOUPON WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
        }
        if (completion) {
            
            completion(responseObject[@"payInfo"]);
            
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
    
    
}
+ (void)requestCreateMonthRentOrderWithDic:(NSMutableDictionary *)dic Completion:(void (^)(TemParkingListModel  *model))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlString = nil;
    if ([dic[@"orderType"] isEqualToString:@"17"]) {
        urlString = [washCarOrderc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        urlString = [ORDERC stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
   
    [[self alloc] postRequestWithURL:urlString WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
        }
        
        TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:responseObject[@"order"]];
        
        
        if (completion) {
            completion(model);
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}


//获取停车场列表
+ (void)requestGetParkingListWithURL:(NSString *)url WithTag:(NSString *)tag Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail
{
//    tag:  1:获取一个停车场  2:获取多个停车场
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
        }
        
        NSArray *dataArray;
        if ([tag isEqualToString:@"2"]) {
            
            dataArray  = responseObject[@"collectionList"];
        }else if ([tag isEqualToString:@"3"]){
            dataArray  = responseObject[@"mapList"];
            
        }else if ([tag isEqualToString:@"4"]){
            
            NSString *tem = [NSString stringWithFormat:@"%@",responseObject[@"list"]];
            if ([tem isEqualToString:@""]) {
                return;
            }
            dataArray  = responseObject[@"list"];
        }
        
        
        NSMutableArray *modelList = [NSMutableArray array];
        if ([tag isEqualToString:@"1"]) {
            NewParkingModel *model = [[NewParkingModel alloc] init];
            [model setValuesForKeysWithDictionary:responseObject[@"parkingMap"]];
            [modelList addObject:model];
            
        }else if ([tag isEqualToString:@"5"]) {
            
            ParkingModel *model = [[ParkingModel alloc] init];
            [model setValuesForKeysWithDictionary:responseObject[@"parkingMap"]];
            [modelList addObject:model];
            
        }else{
            if (dataArray.count > 0 )  {
                for (NSDictionary *dic in dataArray) {
                    ParkingModel *model = [[ParkingModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [modelList addObject:model];
                }
            }
        }
        if (completion) {
            
            completion(modelList);
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}
+ (void)requestGetHistoryOrderListWithURL:(NSString *)page WithType:(NSString *)type Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail;{
   
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@%@",userId,type,page,MD5_SECRETKEY] MD5];
 
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",HISTORYORDERLIST,userId,type,page,summary];
   
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"order"];
            if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *infoDict in dataArray){
                    
                    NewOrderModel *model = [[NewOrderModel alloc] init];
                    [model setValuesForKeysWithDictionary:infoDict];
                    __block BOOL isExist = NO;
                    [[DataSource shareInstance].temParkingArray enumerateObjectsUsingBlock:^(NewOrderModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.orderId isEqualToString:model.orderId]) {
                            isExist = YES;
                            *stop = YES;
                        }
                    }];
                    __block BOOL isExist1 = NO;
                    [[DataSource shareInstance].rentStopArray enumerateObjectsUsingBlock:^(NewOrderModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.orderId isEqualToString:model.orderId]) {
                            isExist1 = YES;
                            *stop = YES;
                        }
                    }];
                    if ([type integerValue] == 1) {
                        if (!isExist) {
                            [[DataSource shareInstance].temParkingArray addObject:model];
                        }
                        
                    }else{
                        if (!isExist1) {
                            [[DataSource shareInstance].rentStopArray  addObject:model];
                        }
                        
                    }
                    
                }
            }
        }
        if (completion) {
            if ([type integerValue] == 1) {
                completion([DataSource shareInstance].temParkingArray);
            }else{
                completion([DataSource shareInstance].rentStopArray);
            }
        }
        
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}
+ (void)requestHistoryOrderDetailListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(TemParkingListModel *model))completion Fail:(void (^)(NSString *error))fail;{
   
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",orderId,orderType,MD5_SECRETKEY] MD5];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",ORDERDETAIL,orderId,orderType,summary];
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString
                            WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSDictionary *dict = responseObject[@"order"];
                                NSLog(@"%@=======",responseObject[@"errorInfo"]);
                                if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                                    
                                    TemParkingListModel *model = [[TemParkingListModel alloc]init];
                                    [model setValuesForKeysWithDictionary:dict];
                                    if (completion) {
                                        completion(model);
                                    }
                                }else
                                {
                                    if (fail) {
                                        fail(responseObject[@"errorInfo"]);
                                    }
                                }
                                
                            } error:^(NSString *error) {
                                
                                if (fail) {
                                    fail(error);
                                }
                                
                            } failure:^(NSString *failInfo) {
                                
                                if (fail) {
                                    fail(failInfo);
                                }
                                
                            }];
   
}
//月租产权获取绑定车辆列表
+ (void)getCarListWithURL:(NSString *)url WithDic:(NSString *)dic Completion:(void (^)(NSMutableDictionary *resultDic))completion Fail:(void (^)(NSString *error))fail
{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userId = [user objectForKey:customer_id];
    
    NSString *summery = [[NSString stringWithFormat:@"%@%@%@",userId,dic,MD5_SECRETKEY] MD5];
    NSString *myurl = [NSString stringWithFormat:@"%@/%@/%@/%@",CARLIST,userId,dic,summery];

    [[self alloc] getRequestWithURL:myurl WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (fail) {
                fail(@"请去“个人中心”-“车辆管理”添加您的车辆信息");
            }
            return ;
        }
        
        NSArray *dataArray = responseObject[@"carlist"][@"parkingList"];
        NSMutableArray *modelList = [NSMutableArray array];
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        
        for (NSDictionary *dic in dataArray) {
            NewParkingModel *model = [NewParkingModel shareNewParkingModel:dic];
            [modelList addObject:model];
        }
        
        [resultDic setObject:modelList forKey:@"parkingList"];
        [resultDic setObject:responseObject[@"carlist"][@"cooperation"] forKey:@"cooperation"];
        
        if (completion) {
            completion(resultDic);
        }
        

        
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
        
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}
//提交验证码
+ (void)validateCodeWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail
{
    
    
    [[self alloc] postRequestWithURL:VALIDATECODE WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject[@"errorNum"]);
        }

    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
    
}

//调用老的使用优惠券借口
+ (void)UserOldCouponWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{

    
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:URL WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            if (completion) {
                
                completion(responseObject[@"datas"]);
                
            }
            
        }else
        {
            if (fail) {
                fail(@"优惠券不可用");
            }
        }

        
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }

    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
                                             
}

//获取问券调查列表
+ (void)getQuestionnairelist:(NSString *)url Completion:(void (^)(NSMutableArray *dataArr))completion fail:(void (^)(NSString *error))Error
{

    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            NSMutableArray *dataArr = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"questionnaireInfo"]) {
                WenQuanModel *model = [WenQuanModel shareWenQuanModelWithDic:dic];
                [dataArr addObject:model];
            }
            
            if (completion) {
                completion(dataArr);
            }
            
        }else
        {
            if (Error) {
                Error(SERVERERROR);
            }
        }

        
    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
    
}

//调查问券提交
+ (void)CommitQuestionnairecWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSString *completion))completion Fail:(void (^)(NSString *error))Error
{
    
    [[self alloc] postRequestWithURL:url WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject[@"errorInfo"]);
        }
        
    } error:^(NSString *error) {
        
        if (Error) {
            Error(error);
        }
        
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
    
}

//地图页面附近是否存在停车场
+ (void)IsExitParkingWithURL:(NSString *)url Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *str))fail
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
                    
                    NSArray *arr = responseObject[@"parkingList"];
                    
                    if (arr.count == 0) {
                        return ;
                    }
                    ParkingModel *model = [[ParkingModel alloc] init];
                    [model setValuesForKeysWithDictionary:responseObject[@"parkingList"][0]];
                    NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:responseObject[@"errorNum"],model, nil];
                    
                    completion(dataArr);
                    
                }else
                {
                    NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:responseObject[@"errorNum"], nil];
                    
                    completion(dataArr);
                    
                }
            });
            
        } error:^(NSString *error) {
            
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(error);

                });
            }
            
        } failure:^(NSString *failInfo) {
            
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail(failInfo);
                    
                });
            }
            
        }];

    });

}
+ (void)requestGetAddOilCardWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))fail
{
    NSArray *sortArray = [[self alloc] sortDicWithKeyArray:[dic allKeys]];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (int i = 0;i<sortArray.count; i++) {
        [tempStr appendString:dic[sortArray[i]]];
    }
    
    [tempStr appendString:MD5_SECRETKEY];
    NSString *summaryStr = [tempStr MD5];
    [dic setValue:summaryStr forKey:SUMMARY];
    

    [[self alloc] postRequestWithURL:addOilCard WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(SERVERERROR);
            return ;
        }
        NSString *str =responseObject[@"errorInfo"];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:str];
        
        if (completion) {
            completion(array);
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }

    }];
}

+ (void)requestAddOilCardListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))fail{

    NSString *summary = [[NSString stringWithFormat:@"%@%@",orderId,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",oilCardList,orderId,summary];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"refuelCard"];
        if ([responseObject[@"errorNum"] isEqualToString:@"1"]) {
            NSMutableArray *arrayNil = nil;
            if (completion) {
                completion(arrayNil);
            }
            return ;
        }
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
            for (NSDictionary *dict in array) {
                OilCardModel *model = [[OilCardModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                __block BOOL isExist = NO;
                [[DataSource shareInstance].oilCardListArray enumerateObjectsUsingBlock:^(OilCardModel *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj.cardNo isEqualToString:model.cardNo]) {
                        isExist = YES;
                        *stop = YES;
                    }
                }];
                if (isExist == NO) {
                    [[DataSource shareInstance].oilCardListArray addObject:model];
                }
            }
            if (completion) {
                completion([DataSource shareInstance].oilCardListArray);
            }
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}

+ (void)requestAddCardOrderListWithURL:(NSString *)orderId WithType:(NSString *)orderType Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))fail;{
   
    
    NSString *summary = [[NSString stringWithFormat:@"%@%@%@",orderId,orderType,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",orderList,orderId,orderType,summary];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"order"];
        if ([responseObject[@"errorNum"] isEqualToString:@"1"]) {
            NSMutableArray *arrayNil = nil;
            if (completion) {
                completion(arrayNil);
            }
            return ;
        }
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
            for (NSDictionary *dict in array) {
                OilOrderList *model = [[OilOrderList alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                __block BOOL isExist = NO;
                [[DataSource shareInstance].oilOrderListArray enumerateObjectsUsingBlock:^(OilOrderList *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj.orderId isEqualToString:model.orderId]) {
                        isExist = YES;
                        *stop = YES;
                    }
                }];
                if (isExist == NO) {
                    
                    [[DataSource shareInstance].oilOrderListArray addObject:model];
                }
                
            }
            if (completion) {
                completion([DataSource shareInstance].oilOrderListArray);
            }
        }
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
    
}
+ (void)requestWinXinRegistByOtherURL:(NSMutableDictionary *)dic code:(NSString *)code  Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail;{
    
    
    [[self alloc] postRequestWithURL:registByOther WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {

            if (fail) {
                fail(responseObject[@"errorInfo"]);

            }
            return;
        }
        if (completion) {
            completion(responseObject);
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
    
}
+ (void)requestWeiXinFirstGoinWithURL:(NSString *)openid Type:(NSString *)type Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
//    type:01 微信 02微博 03 QQ
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:openid,@"quickId",type,@"quickType",@"2.0.1",@"version", nil];
    
    
    NSString *url = [NSString stringWithFormat:@"%@",loginByOther];
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlString WithDic:dict needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
    } failure:^(NSString *failer) {
        NSString *str =[NSString stringWithFormat:@"%@",failer];
        if (fail) {
            fail(str);
        }
    }];

}

+ (void)requestRemindCouponWithURL:(NSString *)url Completion:(void (^)(NSDictionary *dic))completion
{

    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion) {
            completion(responseObject);
        }
        
    } error:^(NSString *error) {
        
        
    } failure:^(NSString *fail) {
        
    }];
    
}
+ (void)requestMonthRentOrderListWithURL:(NSInteger)indexPage orderStare:(NSString *)orderState orderType:(NSString *)orderType Completion:(void (^)())completion Fail:(void (^)(NSString *error))fail{
    

    NSString *summery = [[NSString stringWithFormat:@"%@%@%@%ld%@",orderType,[MyUtil getCustomId],orderState,(long)indexPage,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%ld/%@",monthlyEquityList,orderType,[MyUtil getCustomId],orderState,(long)indexPage,summery];
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"order"];
            if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *infoDict in dataArray){
                    
                    TemParkingListModel *model = [[TemParkingListModel alloc] init];
                    [model setValuesForKeysWithDictionary:infoDict];
                    __block BOOL isExist = NO;
                    [[DataSource shareInstance].noPayForArray enumerateObjectsUsingBlock:^(TemParkingListModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.orderId isEqualToString:model.orderId]) {
                            isExist = YES;
                            *stop = YES;
                        }
                    }];
                    __block BOOL isExist1 = NO;
                    [[DataSource shareInstance].yesPayForArray enumerateObjectsUsingBlock:^(TemParkingListModel *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.orderId isEqualToString:model.orderId]) {
                            isExist1 = YES;
                            *stop = YES;
                        }
                    }];
                    if ([orderState integerValue] == 10) {
                        if (!isExist) {
                            MyLog(@"%@",orderType);
                            if ([model.orderType isEqualToString:orderType]) {
                                [[DataSource shareInstance].noPayForArray addObject:model];
                            }
                        }
                        
                    }else{
                        if (!isExist1) {
                            if ([model.orderType isEqualToString:orderType]) {
                                [[DataSource shareInstance].yesPayForArray  addObject:model];
                            }
                        }
                        
                    }
                }
            }
        }
        
        if (completion) {
            if ([orderState integerValue] == 10) {
                completion([DataSource shareInstance].noPayForArray);
            }else{
                completion([DataSource shareInstance].yesPayForArray);
            }
            
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }

        
    }];
    
}

//获取车管家服务信息
+ (void)requestCarMasterServerDescribeWithUrl:(NSString *)url Completion:(void (^)(NSArray *resultArr))completion
{
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"srvList"]) {
            CarMasterDescribeModel *model = [CarMasterDescribeModel shareCarMasterDescribeModelWithDic:dic];
            [dataArr addObject:model];
            
        }
        if (completion) {
            
            completion(dataArr);
            
        }
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}

//获取租车界面数据
+ (void)requestRentCarInfoWithURL:(NSString *)url Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))error
{

    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(![[responseObject objectForKey:@"errorNum"] isEqualToString:@"0"]){
            
            if (error) {
                error(responseObject[@"errorInfo"]);
            }
            return ;
        }
        
        NSMutableArray *totalArray = [NSMutableArray array];
        NSArray *titleArray = [NSArray arrayWithObjects:responseObject[@"data"][@"commonRent"][@"title"],responseObject[@"data"][@"timeRent"][@"title"], nil];
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"][@"commonRent"][@"carList"]) {
            RentCarModel *model = [RentCarModel shareRentCarModel:dic];
            [dataArr addObject:model];
        }
        RentCarModel *model = [RentCarModel shareRentCarModel:responseObject[@"data"][@"timeRent"][@"carList"][0]];
        [dataArr addObject:model];
        [totalArray addObject:titleArray];
        [totalArray addObject:dataArr];
        
        if (completion) {
            completion(totalArray);
        }
        
    } error:^(NSString *errorMsg) {
        
        if (error) {
            error(errorMsg);
        }
        
        
    } failure:^(NSString *fail) {
        
        if (error) {
            error(fail);
        }

    }];

}

//获取账户余额
+ (void)requestWalletMoneyWithURL:(NSString *)url Completion:(void (^)(NSString *money))completion Fail:(void(^)(NSString *error))fail
{
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
            
        }
        if (completion) {
            
            completion(responseObject[@"money"]);
            
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
    }];
}

//获取钱包充值规则
+ (void)requestWalletRuleWithURL:(NSString *)url Completion:(void (^)(NSArray *resultArray))completion Fail:(void(^)(NSString *error))fail
{
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
        }
        if (completion) {
            
            completion(responseObject[@"rule"]);
            
        }

    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    

}
//钱包支付
+ (void)requestPayWithWalletWithURL:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            fail(responseObject[@"errorInfo"]);
            return ;
        }
        
        if (completion) {
            completion(responseObject);
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    

}
+ (void)requstTopUpListAndConsumeListWithURL:(NSString *)Url type:(NSString *)type Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))isError{
   
    
    [[self alloc] getRequestWithURL:Url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([type isEqualToString:rechargelist]) {
            
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                
                NSArray *dataArray = responseObject[@"order"];
                
                if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *infoDict in dataArray){
                        
                        TemParkingListModel *model = [[TemParkingListModel alloc] init];
                        [model setValuesForKeysWithDictionary:infoDict];
                        
                        [array addObject:model];
                    }
                }
                
            }
            if (completion) {
                completion(array);
            }
        }else if([type isEqualToString:consumlist]){
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                
                NSArray *dataArray = responseObject[@"order"];
                
                if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *infoDict in dataArray){
                        
                        TemParkingListModel *model = [[TemParkingListModel alloc] init];
                        [model setValuesForKeysWithDictionary:infoDict];
                        
                        [array addObject:model];
                    }
                }
                
            }
            if (completion) {
                completion(array);
            }
        }else if ([type isEqualToString:@"gainBindingCar"]){
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                NSDictionary *dict = responseObject[@"data"];
                NewCarModel *model = [[NewCarModel alloc]initWithDic:dict];
                [array addObject:model];
            }
            if (completion) {
                completion(array);
            }
        }
       

        
    } error:^(NSString *error) {
        
        if (isError) {
            isError(error);
        }
        
    } failure:^(NSString *fail) {
        
        if (isError) {
            isError(fail);
        }
        
    }];
    
}
+ (void)validatePurseBaoCodeWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail;{
  
    [[self alloc] getRequestWithURL:url WithDic:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                if (completion) {
                                    completion(responseObject[@"errorNum"]);
                                }

                                
                            } error:^(NSString *error) {
                                
                                if (fail) {
                                    fail(error);
                                }
                                
                            } failure:^(NSString *failInfo) {
                                if (fail) {
                                    fail(failInfo);
                                }
                            }];
    
    
}
+ (void)validateResetPayPasswordWithURL:(NSString *)url WithDic:(NSDictionary *)dic  Completion:(void (^)(NSString *result))completion Fail:(void (^)(NSString *error))fail;{
    
    
    
    [[self alloc] getRequestWithURL:url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion) {
            completion(responseObject[@"errorNum"]);
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
    }

// 查询月租产权代泊未付款订单(小红点)
+ (void)requestOrderPointWithUrl:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail
{
    
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:URL WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (completion) {
                
                completion(responseObject);
                
            }
            
        }else
        {

            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];

}

+ (void)requestAddCarWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail;{
    
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[self alloc] postRequestWithURL:urlString WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject);
            
        }
        
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }

        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}

//查询车辆列表
+ (void)requestGetCarListWithURL:(NSString *)URL WithPage:(NSInteger)page Completion:(void (^)(NSArray *dataArray))completion Fail:(void (^)(NSString *error))fail
{
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"])
        {
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *nilArray = responseObject[@"data"];
            if (nilArray.count == 0) {
                if (fail) {
                    fail(responseObject[@"errorInfo"]);
                }
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                NewCarModel *carModel = [NewCarModel shareNewModelWithDic:dic];
                [dataArr addObject:carModel];
            }
            
            if (completion) {
                completion(dataArr);
            }
            
        }else{
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
            
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
            
        }
    }];
    
}

+ (void)requestCalcGiftAmountWithUrl:(NSInteger)paymoney WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail{

    
    NSString *summery = [[NSString stringWithFormat:@"%ld%@",(long)paymoney,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%ld/%@",calcGiftAmount,(long)paymoney,summery];
    
    
    
    
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:URL WithDic:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (completion) {
                
                completion(responseObject);
                
            }
            
        }else
        {
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }

        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }

    }];
    
}
+ (void)requestGetPhoneCodeWithUrl:(NSString *)phoneMoilble WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail{
    
    NSString *summery = [[NSString stringWithFormat:@"%@%@",phoneMoilble,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",getPhoneCode,phoneMoilble,summery];
    
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:URL WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (completion) {
                completion(responseObject);
            }
            
        }else
        {
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}
+ (void)requestPostInvoiceInfoWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail{
  
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] postRequestWithURL:urlString WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            
            completion(responseObject);
            
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}
//获取发票信息
+ (void)requestGetLatestInvoiceInfoWithURL:(NSString *)URL Completion:(void (^)(NSDictionary *))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"])
        {
            if (completion) {
                completion(responseObject);
            }
            
        }else{
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}


//获取优惠券列表
+ (void)requestGetCouponListWithURL:(NSString *)URL WithDic:(NSDictionary *)dic Completion:(void (^)(NSMutableArray *dataArr))completion Fail:(void (^)(NSString *error))fail
{
    
    [[self alloc] postRequestWithURL:GETCOUPONLIST WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"])
        {
            NSArray *dataArray = responseObject[@"couponList"];
            if (![dataArray isKindOfClass:[NSArray class]]) {
                fail(responseObject[@"errorInfo"]);
                return ;
            }
            NSMutableArray *temArr = [NSMutableArray array];
            for (NSDictionary *temDict in dataArray){
                
                CouponModel *model = [[CouponModel alloc] init];
                [model setValuesForKeysWithDictionary:temDict];
                [temArr addObject:model];
            }
            if (completion) {
                completion(temArr);
            }
        }else
        {
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
        }

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }

        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
}


+ (void)requestCarWashListWithURL:(NSInteger)indexPage orderStare:(NSString *)orderState orderType:(NSString *)orderType Completion:(void (^)())completion Fail:(void (^)(NSString *error))fail{
   
    NSString *summery = [[NSString stringWithFormat:@"%@%@%ld%@",[MyUtil getCustomId],orderState,(long)indexPage,MD5_SECRETKEY] MD5];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@",carwashList,[MyUtil getCustomId],orderState,(long)indexPage,summery];
    
    [[self alloc] getRequestWithURL:url WithDic:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                
                                if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                                    
                                    NSArray *dataArray = responseObject[@"carwashList"];
                                    if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                                        for (NSDictionary *infoDict in dataArray){
                                            
                                            TemParkingListModel *model = [[TemParkingListModel alloc] init];
                                            [model setValuesForKeysWithDictionary:infoDict];
                                            __block BOOL isExist = NO;
                                            [[DataSource shareInstance].noPayForArray enumerateObjectsUsingBlock:^(TemParkingListModel *obj, NSUInteger idx, BOOL *stop) {
                                                if ([obj.orderId isEqualToString:model.orderId]) {
                                                    isExist = YES;
                                                    *stop = YES;
                                                }
                                            }];
                                            __block BOOL isExist1 = NO;
                                            [[DataSource shareInstance].yesPayForArray enumerateObjectsUsingBlock:^(TemParkingListModel *obj, NSUInteger idx, BOOL *stop) {
                                                if ([obj.orderId isEqualToString:model.orderId]) {
                                                    isExist1 = YES;
                                                    *stop = YES;
                                                }
                                            }];
                                            if ([orderState integerValue] == 10) {
                                                if (!isExist) {
                                                    [[DataSource shareInstance].noPayForArray addObject:model];
                                                }
                                                
                                            }else{
                                                if (!isExist1) {
                                                    
                                                    [[DataSource shareInstance].yesPayForArray  addObject:model];
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                
                                if (completion) {
                                    if ([orderState integerValue] == 10) {
                                        completion([DataSource shareInstance].noPayForArray);
                                    }else{
                                        completion([DataSource shareInstance].yesPayForArray);
                                    }
                                    
                                }
                            
                        }
                            error:^(NSString *error) {
                                
                                if (fail) {
                                    fail(error);
                                }
                                  
                              }
                            failure:^(NSString *failInfo) {
                                if (fail) {
                                    fail(failInfo);
                                }
                            }];
    
}

+ (void)requestGetQueryChargeWithURL:(NSString *)URL Completion:(void (^)(NSDictionary *))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] postRequestWithURL:urlString WithDic:nil needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"])
        {
            if (completion) {
                completion(responseObject);
            }
            
        }else{
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
        }
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}
+ (void)requstQueryVoucherPageWithURL:(NSString *)Url type:(NSString *)type Completion:(void(^)(NSMutableArray *resultArray))completion Fail:(void (^)(NSString *error))isError{

    
    [[self alloc] getRequestWithURL:Url WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([type isEqualToString:@"0"]) {
            
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                
                NSArray *dataArray = responseObject[@"carwashList"];
                for (NSDictionary *infoDict in dataArray){
                    
                    TemParkingListModel *model = [[TemParkingListModel alloc] init];
                    [model setValuesForKeysWithDictionary:infoDict];
                    
                    [array addObject:model];
                    
                    
                }
                
                if (completion) {
                    completion(array);
                }
            }else{
                isError(responseObject[@"errorInfo"]);
            }
            
            
        }else if([type isEqualToString:@"1"]){
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                
                NSArray *dataArray = responseObject[@"carwashList"];
                
                for (NSDictionary *infoDict in dataArray){
                    
                    TemParkingListModel *model = [[TemParkingListModel alloc] init];
                    [model setValuesForKeysWithDictionary:infoDict];
                    
                    
                    [array addObject:model];
                    
                }
                if (completion) {
                    completion(array);
                }
            }else{
                isError(responseObject[@"errorInfo"]);
            }
            
            
        }else if ([type isEqualToString:@"2"]){
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"errorNum"] isEqualToString:@"0"]){
                
                NSArray *dataArray = responseObject[@"carwashList"];
                
                for (NSDictionary *infoDict in dataArray){
                    
                    TemParkingListModel *model = [[TemParkingListModel alloc] init];
                    [model setValuesForKeysWithDictionary:infoDict];
                    
                    
                    [array addObject:model];
                    
                }
                if (completion) {
                    completion(array);
                }
                
            }else{
                if (isError) {
                    isError(responseObject[@"errorInfo"]);
                }
            }
        }

        
    } error:^(NSString *error) {
        
        if (isError) {
            isError(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (isError) {
            isError(failInfo);
        }
        
    }];
    
}
//获取车的种类
+ (void)requestGetCarKindWith:(NSString *)URL With:(NSDictionary *)dic Completion:(void (^)(NSMutableDictionary *dataDic))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlStr = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlStr WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            return ;
        }
        
        NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            CarKindModel *model = [CarKindModel shareCarKindModel:dic];
            
            if (model.carDataArray.count == 0 || model.carDataArray == nil) {
                continue;
            }
            [temDic setValue:model forKey:dic[@"nodeName"]];
        }
        if (completion) {
            completion(temDic);
        }

    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];

}
+ (void)requestQueryAppointmentWithUrl:(NSString *)url WithDic:(NSString *)type Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *errror))fail{
    
    NSString *URL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:URL WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (completion) {
                completion(responseObject);
            }
            
        }else
        {
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }

        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
}

//新代泊相关
+ (void)requestDaiBoWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{

    
    [[self alloc] postRequestWithURL:url WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}

+ (void)requestDaiBoOrder:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSArray *dataArray))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    MyLog(@"%@",urlStr);
    
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
            
        }else
        {
            NSMutableArray *dataArray = [NSMutableArray array];
            
            if ([type isEqualToString:@"getOrder"]) {
                for (NSDictionary *dic in responseObject[@"parkerList"]) {
                    TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:dic];
                    [dataArray addObject:model];
                }
            }else if ([type isEqualToString:@"getCar"]){
                TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:responseObject[@"data"]];
                [dataArray addObject:model];
            }else if ([type isEqualToString:@"getPingZheng"]){
                TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:responseObject[@"carwashList"][0]];
                [dataArray addObject:model];
            }else if ([type isEqualToString:@"getOrder1"]){
                for (NSDictionary *dict in responseObject[@"data"]) {
                    TemParkingListModel *model = [TemParkingListModel shareTemParkingListModelWithDic:dict];
                    [dataArray addObject:model];
                }
                
            }else if ([type isEqualToString:@"getDaiBoTime"]){
                TemParkingListModel *model = [[TemParkingListModel alloc] init];
                model.data = responseObject[@"data"];
                [dataArray addObject:model];
                
            }else if ([type isEqualToString:@"getParkingList"]){
                for (NSDictionary *dict in responseObject[@"data"]) {
                    ParkingModel *model = [[ParkingModel alloc]initWithDic:dict];
                    [dataArray addObject:model];
                }
                
            }else if ([type isEqualToString:@"getQiyuId"]){
                
                NSArray *qiyuIdArray =responseObject[@"qiyuId"];
             
                dataArray = [NSMutableArray arrayWithArray:qiyuIdArray];
                
            }

            
            if (completion) {
                
                completion(dataArray);
                
            }
        }
        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }
        
    } failure:^(NSString *failInfo) {
        
        if (fail) {
            fail(failInfo);
        }
        
    }];
    
}

//代泊订单列表+代泊评论接口
+ (void)requestQueryFinishParkOrder:(NSString *)url WithType:(NSString *)type WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dict))completion Fail:(void (^)(NSString *error))fail{
   
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            if (fail) {
                fail(responseObject[@"errorInfo"]);
            }
        }else
        {
            if (completion) {
                completion(responseObject);
            }
            
        }
        

        
    } error:^(NSString *error) {
        
        if (fail) {
            fail(error);
        }

        
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }

    }];
    
}
+ (void)requestCollectionWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error{
     NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@==",responseObject);
        NSMutableArray *goInArray = [[NSMutableArray alloc]init];
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            NSArray *array = responseObject[@"collectionList"];
            for (NSDictionary *tmpDict in array) {
                ManagerModel *model = [[ManagerModel alloc]init];
                [model setValuesForKeysWithDictionary:tmpDict];
                [goInArray addObject:model];
            }
        
            if (completion) {
                completion(goInArray);
            }
        }else{
            if (Error) {
                Error(responseObject[@"errorInfo"]);
            }
        }
    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
}

+ (void)requestGetParkingStatusWith:(NSString *)url WithDic:(NSMutableDictionary *)dic Completion:(void (^)(ParkingModel *model))completion Fail:(void (^)(NSString *error))Error;{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@====",responseObject);
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            ParkingModel *model = [[ParkingModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            if (completion) {
                completion(model);
            }
            
            
        }
    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
}
+ (void)requestGetMonthlyEquityWith:(NSString *)url WithDic:(NSMutableDictionary *)dic  Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error
{
     NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                NewParkingModel *model = [NewParkingModel shareNewParkingModel:dic];
                NSDictionary *temDic;
                if ([dic[@"type"] integerValue]==13) {
                    temDic = [NSDictionary dictionaryWithObjectsAndKeys:model,@"monthly", nil];
                }else
                {
                    temDic = [NSDictionary dictionaryWithObjectsAndKeys:model,@"equity", nil];

                }
                
                [dataArray addObject:temDic];
                
            }
            
            if (completion) {
                completion(dataArray);
            }
        }else
        {
            if (Error) {
                Error(responseObject[@"errorInfo"]);
            }
        }

    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
    
}

+ (void)requestGetParkingListWith:(NSString *)url WithDic:(NSMutableDictionary *)dic type:(NSString *)type Completion:(void (^)(NSMutableArray *array))completion Fail:(void (^)(NSString *error))Error;{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@==",responseObject);
        NSMutableArray *goInArray = [[NSMutableArray alloc]init];
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if ([type isEqualToString:@"parkingList"]) {
                NSArray *array = responseObject[type];
                for (NSDictionary *tmpDict in array) {
                    ParkingModel *model = [[ParkingModel alloc]init];
                    [model setValuesForKeysWithDictionary:tmpDict];
                    [goInArray addObject:model];
                }
                
                if (completion) {
                    completion(goInArray);
                }
            }
          
        }else{
            if (Error) {
                Error(responseObject[@"errorInfo"]);
            }
        }
    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];
}

+ (void)requestGetCarLiftWith:(NSString *)url withDic:(NSMutableDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))Error
{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            NSDictionary *jsonDic = responseObject[@"data"];
            
            NSMutableArray *type1Array = [NSMutableArray array];
            for (NSDictionary *dic in jsonDic[@"type1"]) {
                CarLiftModel *model = [CarLiftModel shareLiftModelWift:dic];
                [type1Array addObject:model];
            }
            NSMutableArray *type2Array = [NSMutableArray array];
            for (NSDictionary *dic in jsonDic[@"type2"]) {
                CarLiftModel *model = [CarLiftModel shareLiftModelWift:dic];
                [type2Array addObject:model];
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type1Array,@"type1",type2Array,@"type2", nil];
            
            if (completion) {
                completion(dic);
            }

            
        }else{
            if (Error) {
                Error(responseObject[@"errorInfo"]);
            }
        }

        
    } error:^(NSString *error) {
        if (Error) {
            Error(error);
        }
    } failure:^(NSString *fail) {
        if (Error) {
            Error(fail);
        }
    }];

}

#pragma mark --- get  返回字典
+ (void)getDicWithUrl:(NSString *)url Completion:(void (^)(NSDictionary *dataDic))completion Fail:(void (^)(NSString *error))errorMsg
{
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[self alloc] getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject[@"errorNum"] isEqualToString:@"0"]) {
            if (errorMsg) {
                errorMsg(responseObject[@"errorInfo"]);
            }
        }
        
        if (completion) {
            completion(responseObject);
        }
        
    } error:^(NSString *error) {
        
        if (errorMsg) {
            errorMsg(error);
        }
        
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }
        
    }];
    

}

#pragma mark --- post 返回字典
+ (void)postGetDiction:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dataDic))completion Fail:(void (^)(NSString *error))errorMsg
{
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[self alloc] postRequestWithURL:urlStr WithDic:dic needEncryption:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errorNum"] isEqualToString:@"0"]) {
            
            if (completion) {
                completion(responseObject);
            }
            
        }else{
            if (errorMsg) {
                errorMsg(responseObject[@"errorInfo"]);
            }
        }
        
        
    } error:^(NSString *error) {
        if (errorMsg) {
            errorMsg(error);
        }
    } failure:^(NSString *fail) {
        if (errorMsg) {
            errorMsg(fail);
        }
    }];

}

#pragma mark -- 对字典进行排序
-(NSArray *)sortDicWithKeyArray:(NSArray *)keyArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [keyArray sortedArrayUsingDescriptors:descriptors];
    return resultArray;
    
}

@end
