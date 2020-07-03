//
//  DBManager.m
//  Pop Daily
//
//  Created by qianfeng on 15/7/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager
{
    FMDatabase *_dataBase;
}

+ (DBManager *)sharedInstance
{
    static DBManager *manager = nil;
    @synchronized(self){
        if (nil == manager) {
            manager = [[DBManager alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self createDataBase];
    }
    return self;
}

- (void)createDataBase
{
     NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/searchModle"];
   
     NSLog(@"---------%@",path);
    _dataBase = [[FMDatabase alloc] initWithPath:path];
    
     NSString *createSpl = @"CREATE TABLE IF NOT EXISTS searchModle(searchTitle NSSTRING PRIMARY KEY, searchLatitude NSSTRING DEFAULT 暂无介绍, searchLongitude NSSTRING, searchDistrict NSSTRING)";
    BOOL ret = [_dataBase open];
    if (!ret) {
        MyLog(@"数据创建失败");
    }else{
        
       
        [_dataBase executeUpdate:createSpl];
        MyLog(@"数据创建成功");
    }
}
/* *searchTitle;
 ng *searchLatitude;
 ng *searchLongitude;
 *searchDistrict;*/
- (void)addSearchtModel:(ManagerModel *)model
{
    NSString *insertSql = @"INSERT INTO searchModle (searchTitle,searchLatitude,searchLongitude,searchDistrict) VALUES (?,?,?,?)";
    BOOL ret = [_dataBase executeUpdate:insertSql,model.searchTitle,model.searchLatitude,model.searchLongitude,model.searchDistrict];
    if (!ret) {
        MyLog(@"添加失败%@",_dataBase.lastErrorMessage);
    }
}

- (NSArray *)searchAllModel
{
    NSString *selectSql = @"select * from searchModle";
//    执行查询操作
    FMResultSet *rs = [_dataBase executeQuery:selectSql];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        
        ManagerModel *model = [[ManagerModel alloc] init];
        model.searchTitle = [rs stringForColumn:@"searchTitle"];
        model.searchLatitude = [rs stringForColumn:@"searchLatitude"];
        model.searchLongitude = [rs stringForColumn:@"searchLongitude"];
        model.searchDistrict = [rs stringForColumn:@"searchDistrict"];
        [array addObject:model];
    }
    return array;
}

- (void)deleteModel:(ManagerModel *)model
{
    NSString *deleteSql = @"delete from searchModle where searchTitle = ?";
    
    BOOL ret = [_dataBase executeUpdate:deleteSql,model.searchTitle];
    if (!ret) {
        MyLog(@"删除失败:%@",_dataBase.lastErrorMessage);
    }
}

//判断一条记录是否存在
- (BOOL)isModelExists:(ManagerModel *)model
{
    //sql
    NSString *sql = @"select * from searchModle where searchTitle=?";
    
    FMResultSet *rs = [_dataBase executeQuery:sql,model.searchTitle];
    
    if ([rs next]) {
        return YES;
    }
    return NO;
}

- (void)deleteAllModel
{
    NSString *deleteSql = @"delete from searchModle";
    
    BOOL ret = [_dataBase executeUpdate:deleteSql];
    if (!ret) {
        MyLog(@"删除失败:%@",_dataBase.lastErrorMessage);
    }
}

@end




