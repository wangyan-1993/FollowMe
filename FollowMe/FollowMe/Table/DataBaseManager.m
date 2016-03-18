//
//  DataBaseManager.m
//  FollowMe
//
//  Created by SCJY on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>

@interface DataBaseManager()
{
    NSString *dataBasePath;//数据库创建路径
}
@end

@implementation DataBaseManager
//创建一个静态的单例对象（DataBaseManager）,设置初始值为空
static DataBaseManager *dbManager = nil;
+ (DataBaseManager *)shareInatance{
    //如果单例对象为空，就去创建一个
    if (dbManager == nil) {
        dbManager =[[DataBaseManager alloc]init];
    }
    return dbManager;
}
#pragma mark------数据库基础操作
//创建一个静态数据库实例对象
static sqlite3 *dataBase = nil;

//创建数据库
- (void)createDataBase{
    //获取应用程序沙盒路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    dataBasePath = [documentPath stringByAppendingPathComponent:@"/Mango.sqlite"];
    NSLog(@"%@", dataBasePath);
}


//打开数据库
- (void)openDataBase{
    //如果数据库存在就直接返回，如果不存在就去创建一个新的数据库和表
    if (dataBase != nil) {
        return;
    }
    //创建数据库
    [self createDataBase];
    
    //第一个参数  数据库文件路径名  注意是UTF8String编码格式
    //第二个参数  数据库对象的地址
    //如果数据库文件已经存在，就是打开操作，如果数据库文件不存在，则先创建后打开
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //数据库打开成功之后去创建数据库表
        [self createDataBaseTable];
    }else{
        NSLog(@"数据库打开失败");
    }
}


//创建数据库表
- (void)createDataBaseTable{
    //建表语句
    NSString *sql =[NSString stringWithFormat:@"create table a%@ (city text not null)", self.name];
    NSLog(@"%@", sql);
    //执行SQL语句
    /*
     第一个参数：数据库
     第二个参数：sql语句，UTF8String编码格式
     第三个参数：sqlites_callBack是函数回调，当这条语句执行完之后会调用你提供的函数，可以是NULL
     第四个参数：是你提供的指针变量，这个参数最终会传到你的回调函数中，也可以为NULL
     第五个参数：是错误信息，需要注意是指针类型，接收sqlite3执行的错误信息， 也可以为null
     */
    char *error = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &error);
    
}



//关闭数据库
- (void)closeDataBase{
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"关闭成功");
        dataBase = nil;
    }else{
        NSLog(@"关闭失败");
    }
}

- (void)insertIntoSearch:(NSString *)name{
    //打开数据库
    [self openDataBase];
    //简单的理解为它里边就是sql语句
    sqlite3_stmt *stmt = nil;
    //sql语句
 NSString *sql =[NSString stringWithFormat:@"insert into a%@(city) values(?)", self.name];    /*
     第一个参数      sqlite3 *db  :  数据库
     第二个参数 const char *zSql  ： sql语句
     第三个参数       int nByte   ： 如果nByte小于0，则函数取出zSql中从开始到第一个0终止符的内容；如果nByte不是负的，那么它就是这个函数能从zSql中读取的字节数的最大值。如果nBytes非负，zSql在第一次遇见’/000/或’u000’的时候终止
     第四个参数           ppStmt  ：能够使用sqlite3_step()执行的编译好的准备语句的指针，如果错误发生，它被置为NULL，如假如输入的文本不包括sql语句。调用过程必须负责在编译好的sql语句完成使用后使用sqlite3_finalize()删除它。
     第五个参数            pzTail  ：上面提到zSql在遇见终止符或者是达到设定的nByte之后结束，假如zSql还有剩余的内容，那么这些剩余的内容被存放到pZTail中，不包括终止符
     
     */
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //sql语句没有问题---绑定数据(绑定的是上边sql语句中的？。也就是讲？替换为应该存储的值)
        //绑定？时，标记从1开始，不是0
        
        //绑定第一个？------name
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
                //执行
        sqlite3_step(stmt);
        
    }else{
        NSLog(@"sql语句有问题");
    }
    //删除释放掉
    sqlite3_finalize(stmt);

}
- (NSMutableArray *)selectAllCollect{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"select *from a%@", self.name];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *array = nil;
    if (result == SQLITE_OK) {
        array = [NSMutableArray new];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            [array addObject:name];
            //如果数据库里面的数据元素多于10个，就删除
            if (array.count > 10) {
                [array removeObjectAtIndex:0];
            }
        }
    }
    else{
        NSLog(@"获取失败");
        array = [NSMutableArray new];
    }
    sqlite3_finalize(stmt);
    return array;

}



@end
