//
//  CoreDataManage.m
//  P-SHARE
//
//  Created by fay on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CoreDataManage.h"
@implementation CoreDataManage
+ (NSManagedObjectContext *)createMOC
{
    //    创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *MOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //    初始化托管对象 并使用Model.momd的路径当作初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"P_SHARE" withExtension:@"momd"];
    NSManagedObjectModel *MOM = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    
    //    创建持久化存储调度器 PSC
    NSPersistentStoreCoordinator *PSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:MOM];
    
    
    
    //    创建并关联SQLite数据库文件 如果已经存在  则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.splite",@"P_SHARE"];
    
    //    NSSQLiteStoreType : SQLite数据库
    //    NSXMLStoreType : XML文件
    //    NSBinaryStoreType : 二进制文件
    //    NSInMemoryStoreType : 直接存储在内存中
    //    PSC有四种可选的持久化存储方案，用得最多的是SQLite的方式。其中Binary和XML这两种方式，在进行数据操作时，需要将整个文件加载到内存中，这样对内存的消耗是很大的
    [PSC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    //    上下文对象设置属性为持久化存储器
    MOC.persistentStoreCoordinator = PSC;
    
    return MOC;

}
@end
