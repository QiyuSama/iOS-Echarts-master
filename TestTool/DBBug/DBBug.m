//
//  DBBug.m
//  SQLiteOC
//
//  Created by NanTang on 15/9/24.
//  Copyright (c) 2015年 NanTang. All rights reserved.
//

#import "DBBug.h"
#import "AppDelegate+BugTool.h"

#define dispatchAsyncMain(main_queue_block) dispatch_async(dispatch_get_main_queue(), main_queue_block);
///在次线程中执行
#define dispatchAsyncGlobal(global_queue_block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), global_queue_block);

@implementation NSDate (Category)
- (NSString *)toStringWithFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:self];
}
@end

@implementation DBBug

+ (BOOL)needCatchAction
{
    #ifdef DEBUG
        return YES;
    #else
        return NO;
    #endif
}

- (void)openOperateDB
{
    [super openDatabase:@"OperateDB"];
}

- (void)openOperateTestDB
{
    [super openDatabase:@"OperateTest"];
}

- (void)createOperateTestTable
{
    NSString *sqlCreateTable = @"create table if not exists OperateTest(id integer primary key autoincrement,testID NvarChar(128) default '', appID NvarChar(128)  default '',startTime  DateTime default '' )";
    [self execSql:sqlCreateTable];
}


- (void)createAppInfoTable
{
    NSString *sqlCreateTable = @"create table if not exists AppInfo(id integer primary key autoincrement,appName NvarChar(128) default '', appID NvarChar(128)  default '', version NvarChar(32)  default '',time  DateTime default '' )";
    [self execSql:sqlCreateTable];
}

- (void)createOperateActionTable
{
    //[self execSql:@"drop table BugMessage"];
    NSString *sqlCreateTable = @"create table if not exists OperateAction(id integer primary key autoincrement,testID NvarChar(128) default '', type NvarChar(64)  default '',source NvarChar(64) default '',currentVC  NvarChar(64)  default '',target  NvarChar(64)  default '',action  NvarChar(256)  default '',data  NvarChar(256)  default '',time  DateTime default '' )";
    [self execSql:sqlCreateTable];
}


- (void)dropOperateActionTable
{
    [self execSql:@"drop table OperateAction"];
}

- (void)insertOperateAction:(OperateModel *)operate
                 completion:(void(^)(bool isSucess,NSDictionary *errors))completion
{
    if (dbugIsSaveOperate) {
        [self openOperateDB];
        [self createOperateActionTable];
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into OperateAction(testID,type,source,currentVC,target,action,data,time) values('%@','%@','%@','%@','%@','%@','%@','%@')",operate.testID,operate.type,operate.source,operate.currentVC,operate.target,operate.action,operate.data,operate.time];
        [super execSql:sqlInsert completion:^(bool isSucess, NSDictionary *errors) {
            if (completion) {
                completion(isSucess,errors);
            }
        }];
        [super closeDataBase];
    }else{
    
    }
}

- (void)queryOperateActionFliter:(OperateModel *)operate complete:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    [self openOperateDB];
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select id,testID,type,source,currentVC,target,action,data,time from OperateAction where testID == '%@' And  (time Between '%@' and '%@') ",operate.testID,operate.fitterStartTime,operate.fitterEndTime];
    if(operate.type.integerValue>0){
        [sql appendFormat:@"And  type like '%@' ",operate.type];
    }
    if(operate.currentVC.length > 0){
        [sql appendFormat:@"And  currentVC like '%%%@%%' ",operate.currentVC];
    }
    if(operate.target.length > 0){
        [sql appendFormat:@"And  target like '%%%@%%' ",operate.target];
    }
    if(operate.action.length > 0){
        [sql appendFormat:@"And  action like '%%%@%%' ",operate.action];
    }
    if(operate.source.length > 0){
        [sql appendFormat:@"And  source like '%%%@%%' ",operate.source];
    }
    [sql appendString:@" order by id DESC"];
    
    [super queryTableForDicValue:sql titleColumn:4 completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        completion(table,titlelist,columnnamelist);
    }];
    [super closeDataBase];
}

#pragma mark - test list
- (void)insertOperateTest:(TestModel *)test
                 completion:(void(^)(bool isSucess,NSDictionary *errors))completion
{
    if (dbugIsSaveOperate) {
        [self openOperateDB];
        [self createOperateTestTable];
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into OperateTest(testID,appID,startTime) values('%@','%@','%@')",test.testID,test.appID,test.startTime];
        [super execSql:sqlInsert completion:^(bool isSucess, NSDictionary *errors) {
            completion(isSucess,errors);
        }];
        [super closeDataBase];
    }else{
        
    }
}

- (void)queryOperateTestListWithFliter:(AppModel *)appInfo completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    [self openOperateDB];
    NSString *sql;
    if (appInfo.appID.length>0) {
       sql = [NSString stringWithFormat:@"select id,testID,appID,startTime from OperateTest where appID == '%@' order by id DESC",appInfo.appID];
    }else{
        sql = @"select id,testID,appID,startTime from OperateTest order by id DESC";
    }
    [super queryTableForDicValue:sql titleColumn:1 completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        completion(table,titlelist,columnnamelist);
    }];
    [super closeDataBase];
}

- (void)queryOperateTestList:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    [self openOperateDB];
    NSString *sql = @"select id,testID,appID,startTime from OperateTest order by id DESC";
    [super queryTableForDicValue:sql titleColumn:1 completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        completion(table,titlelist,columnnamelist);
    }];
    [super closeDataBase];
}


- (void)queryOperateAction:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    [self openOperateDB];
    NSString *sql = @"select id,testID,type,source,currentVC,target,action,time from OperateAction order by id DESC";
    
    [super queryTableForDicValue:sql titleColumn:4 completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        completion(table,titlelist,columnnamelist);
    }];
    [super closeDataBase];
}

- (void)clearActionData
{
    [self openOperateDB];
    [self dropOperateActionTable];
    [self execSql:@"drop table OperateTest"];
    [self execSql:@"drop table AppInfo"];
    [super closeDataBase];
}


#pragma mark - App info

- (void)insertAppInfo:(AppModel *)appInfo
           completion:(void(^)(bool isSucess,NSDictionary *errors))completion
{
    if (dbugIsSaveOperate) {
        [self openOperateDB];
        [self createAppInfoTable];
        NSString *sqlExist = [NSString stringWithFormat:@"select * from AppInfo where appID = '%@'",appInfo.appID];
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into AppInfo(appID,appName,version,time) values('%@','%@','%@','%@'); ",appInfo.appID,appInfo.appName,appInfo.version,appInfo.time];
        [super existData:sqlExist completion:^(bool isSucess, bool exist) {
            if (isSucess) {
                if (!exist) {
                    [super execSql:sqlInsert completion:^(bool isSucess, NSDictionary *errors) {
                        completion(isSucess,errors);
                    }];
                }else{
                    completion(NO,@{@"插入失败":@"数据已存在"});
                }
            }else{
                completion(NO,@{@"插入失败":@"检测存在失败"});
            }
        }];
        [super closeDataBase];
    }else{
        
    }
}

- (void)queryAppInfoList:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    [self openOperateDB];
    NSString *sql = @"select id,appID,appName,version,time from AppInfo order by id DESC";
    [super queryTableForDicValue:sql titleColumn:1 completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        completion(table,titlelist,columnnamelist);
    }];
    [super closeDataBase];
}

@end
