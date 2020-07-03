//
//  DaiBoRequest.m
//  P-SHARE
//
//  Created by fay on 16/10/24.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "DaiBoRequest.h"

@implementation DaiBoRequest
+ (void)requestDaiBoPriceWithURL:(NSString *)url WithDic:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *day = dic[@"day"];
    NSString *hour = dic[@"hour"];
    NSString *miunte = dic[@"miunte"];


    NSString *startDate = [DaiBoRequest getToday:[NSDate date] withFormatter:@"YYYY-MM-dd HH:mm:ss"];
    
     NSDictionary *parameterDic = [NSDictionary dictionaryWithObjectsAndKeys:@"2.0.1",@"version",[GroupManage shareGroupManages].parking.parkingId,@"parkingId",startDate,@"startTime",[DaiBoRequest getEndTimeDay:day hour:hour miunte:miunte],@"endTime", nil];
    
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(calcParkPrice) WithDic:parameterDic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (completion) {
            completion(responseObject);
        }
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
    }];

}

+ (void)requestCreateDaiBoOrderWithDic:(NSMutableDictionary *)dic Completion:(void (^)(OrderModel *model))completion Fail:(void (^)(NSString *error))failInfo;
{
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(orderc) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        OrderModel *orderModel = [OrderModel shareObjectWithDic:responseObject[@"data"]];
        
        if (completion) {
            completion(orderModel);
        }
    } error:^(NSString *error) {
        MyLog(@"%@",error);
        if (failInfo) {
            failInfo(error);
        }
    } failure:^(NSString *fail) {
        MyLog(@"%@",fail);
        if (failInfo) {
            failInfo(fail);
        }

    }];

}
+ (NSString*)getEndTimeDay:(NSString*)day hour:(NSString *)hour miunte:(NSString *)miunte
{
    NSString *endDate;
    if ([day isEqualToString:@"今日"]) {
        endDate = [NSString stringWithFormat:@"%@ %@:%@:00",[DaiBoRequest getToday:[NSDate date] withFormatter:@"YYYY-MM-dd"],hour,miunte];
    }else
    {
        endDate = [NSString stringWithFormat:@"%@ %@:%@:00",[DaiBoRequest getTomorrowDay:[NSDate date]],hour,miunte];
    }
    return endDate;

}
+(NSString *)getTomorrowDay:(NSDate *)aDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"YYYY-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

+ (NSString *)getToday:(NSDate *)date withFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *day = [dateFormatter stringFromDate:date];
    return day;
    
}


@end
