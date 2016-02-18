//
//  SQLiteDB.h
//  SQLiteOC
//
//  Created by NanTang on 15/9/24.
//  Copyright (c) 2015年 NanTang. All rights reserved.
//

#ifndef SQLiteOC_SQLiteDB_h
#define SQLiteOC_SQLiteDB_h

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SQLiteDB : NSObject

@property (nonatomic) sqlite3 *database;

- (BOOL)openDatabase:(NSString *)databaseName;
- (BOOL)execSql:(NSString *)sql;
- (void)execSql:(NSString *)sql
     completion:(void(^)(bool isSucess,NSDictionary *errors))completion;

- (void)existData:(NSString *)sql
       completion:(void(^)(bool isSucess,bool exist))completion;
- (void)queryTable:(NSString *)sql
       titleColumn:(int)titlecolumn
        completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;

- (void)queryTableForDicValue:(NSString *)sql
                  titleColumn:(int)titlecolumn
                   completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;
- (void)closeDataBase;
- (void)getTableInfo:(NSString *)tableName;

@end
#endif
