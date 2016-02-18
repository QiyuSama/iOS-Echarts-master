//
//  SQLiteDB.m
//  SQLiteOC
//
//  Created by NanTang on 15/9/24.
//  Copyright (c) 2015年 NanTang. All rights reserved.
//

#import "SQLiteDB.h"

@implementation SQLiteDB

- (BOOL)openDatabase:(NSString *)databaseName
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    if (sqlite3_open([databaseFilePath UTF8String], &_database)==SQLITE_OK) {
        return YES;
    }
    else{
        sqlite3_close(_database);
        NSAssert(0, @"数据库打开失败。");
        return NO;
    }
}

- (void)getTableInfo:(NSString *)tableName
{
    char *error;
    const char *selectSql = [[NSString stringWithFormat:@"PRAGMA table_info([%@])",tableName] UTF8String];//"select * from person";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database,selectSql, -1, &statement, nil)==SQLITE_OK) {
        int row = 0;
        while(sqlite3_step(statement)==SQLITE_ROW) {
            row++;
            int columnCount = sqlite3_column_count(statement);
            int i = 0;
            NSString *colvalues = @"";
            for (i=0; i < columnCount; i++) {
                const char *colvalue = (char *)sqlite3_column_text(statement, i);
                colvalues = [NSString stringWithFormat:@"%@   %s",colvalues , colvalue];
            }
            NSLog(@"row:%d value:%@",row,colvalues);
        }
    }
    else
    {
        NSLog(@"error: %s",error);
        //sqlite3_free(error);
    }
    sqlite3_finalize(statement);
}

- (BOOL)execSql:(NSString *)sql
{
    char *error;
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"%@ \n操作数据失败: %s",sql,error);
        //sqlite3_free(error);//每次使用完毕清空error字符串，提供给下一次使用
        return NO;
    }else{
        return  YES;
    }
}


- (void)execSql:(NSString *)sql
     completion:(void(^)(bool isSucess,NSDictionary *errors))completion
{
    char *error;
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSString *errorMessage = [NSString stringWithFormat:@"%s",error];
        NSLog(@"%@ \n操作数据失败: %s",sql,error);
        sqlite3_free(error);//每次使用完毕清空error字符串，提供给下一次使用
        completion(NO,@{@"sql":sql,@"message":errorMessage});
    }else{
        completion(YES,@{});
    }
}

- (void)existData:(NSString *)sql
        completion:(void(^)(bool isSucess,bool exist))completion
{
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database,selectSql, -1, &statement, nil)==SQLITE_OK) {
        while(sqlite3_step(statement)==SQLITE_ROW) {
            completion(YES,YES);
            sqlite3_finalize(statement);
            return;
        }
        completion(YES,NO);
    }
    else{
        completion(NO,NO);
    }
    sqlite3_finalize(statement);
}



- (void)queryTable:(NSString *)sql
       titleColumn:(int)titlecolumn
        completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    //char *error;
    NSMutableArray *tableData = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *titleList = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *columnNameList = [[NSMutableArray alloc]initWithCapacity:0];
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database,selectSql, -1, &statement, nil)==SQLITE_OK) {
        NSLog(@"%@",sql);
        //NSLog(@"select operation is ok.");
        //dispatchAsyncGlobal(^{})
        int columnCount = 0;
        while(sqlite3_step(statement)==SQLITE_ROW) {
            columnCount = sqlite3_column_count(statement);
            NSMutableArray *rowData = [[NSMutableArray alloc]initWithCapacity:0];
            int i = 0;
            for (i=0; i < columnCount; i++) {
                NSString *columnStringValue = @"";
                const char *_abc = (char *) sqlite3_column_text(statement, i);
                if (_abc){
                    columnStringValue = _abc == NULL ? nil : [[NSString alloc] initWithUTF8String:_abc];
                }
                [rowData addObject:columnStringValue];
                if (i == titlecolumn) {
                    [titleList addObject:columnStringValue];
                }
            }
            [tableData addObject:rowData];
        }
        for (int i = 0; i < columnCount; i++) {
            const char *colCharName = sqlite3_column_name(statement, i);
            int type = sqlite3_column_type(statement, i);
            NSString *colStrName = colCharName == NULL ? nil : [[NSString alloc] initWithUTF8String:colCharName];
            NSArray *columnInfo =  [[NSArray alloc] initWithObjects:colStrName,[self sqliteTypeString:type],nil];
            [columnNameList addObject:columnInfo];
        }
        //NSLog(@"columnNameList:%@",columnNameList);
    }
    else
    {
        //NSLog(@"error: %s",error);
    }
    completion(tableData,titleList,columnNameList);
    sqlite3_finalize(statement);
}



- (void)queryTableForDicValue:(NSString *)sql
                  titleColumn:(int)titlecolumn
                   completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion
{
    NSMutableArray *tableData = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *titleList = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *columnNameList = [[NSMutableArray alloc]initWithCapacity:0];
    const char *selectSql = [sql UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(self.database,selectSql, -1, &statement, nil)==SQLITE_OK) {
        int columnCount = 0;
        columnCount = sqlite3_column_count(statement);
        for (int i = 0; i < columnCount; i++) {
            const char *colCharName = sqlite3_column_name(statement, i);
            int type = sqlite3_column_type(statement, i);
            NSString *colStrName = colCharName == NULL ? nil : [[NSString alloc] initWithUTF8String:colCharName];
            NSArray *columnInfo =  [[NSArray alloc] initWithObjects:colStrName,[self sqliteTypeString:type],nil];
            [columnNameList addObject:columnInfo];
        }
        while(sqlite3_step(statement)==SQLITE_ROW) {
            NSMutableDictionary *rowData = [[NSMutableDictionary alloc]initWithCapacity:0];
            int i = 0;
            for (i=0; i < columnCount; i++) {
                NSString *columnStringValue = @"";
                const char *_abc = (char *) sqlite3_column_text(statement, i);
                if (_abc){
                    columnStringValue = _abc == NULL ? nil : [[NSString alloc] initWithUTF8String:_abc];
                }
                rowData[columnNameList[i][0]] = columnStringValue;
                if (i == titlecolumn) {
                    [titleList addObject:columnStringValue];
                }
            }
            [tableData addObject:rowData];
        }
        //NSLog(@"columnNameList:%@",columnNameList);
    }
    else
    {
        //NSLog(@"error: %s",error);
    }
    completion(tableData,titleList,columnNameList);
    sqlite3_finalize(statement);
}

- (NSString *)sqliteTypeString:(int)type
{
    NSString *strType = @"not know";
    switch (type) {
        case SQLITE_INTEGER:
            strType = @"SQLITE_INTEGER";
            break;
        case SQLITE_FLOAT:
            strType = @"SQLITE_FLOAT";
            break;
        case SQLITE_BLOB:
            strType = @"SQLITE_BLOB";
            break;
        case SQLITE_NULL:
            strType = @"SQLITE_NULL";
            break;
        case SQLITE_TEXT:
            strType = @"SQLITE_TEXT";
            break;
        default:
            break;
    }
    return strType;
}

- (void)closeDataBase
{
    sqlite3_close(self.database);
}

@end