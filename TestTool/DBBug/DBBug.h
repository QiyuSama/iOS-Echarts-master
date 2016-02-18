//
//  DBBug.h
//  SQLiteOC
//
//  Created by NanTang on 15/9/24.
//  Copyright (c) 2015年 NanTang. All rights reserved.
//

#ifndef SQLiteOC_DBBug_h
#define SQLiteOC_DBBug_h
#import <Foundation/Foundation.h>
#import "SQLiteDB.h"
#import "AppModel.h"

@interface NSDate (Category)
- (NSString *)toStringWithFormatter:(NSString *)formatter;
@end

@interface DBBug : SQLiteDB

+ (BOOL)needCatchAction;

#pragma mark - action list
- (void)insertOperateAction:(OperateModel *)operate
                 completion:(void(^)(bool isSucess,NSDictionary *errors))completion;

- (void)queryOperateAction:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;
- (void)queryOperateActionFliter:(OperateModel *)operate complete:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;

- (void)clearActionData;


#pragma mark - test list
- (void)insertOperateTest:(TestModel *)test
               completion:(void(^)(bool isSucess,NSDictionary *errors))completion;
- (void)queryOperateTestListWithFliter:(AppModel *)appInfo completion:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;

- (void)queryOperateTestList:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;


#pragma mark - App info

- (void)insertAppInfo:(AppModel *)appInfo
           completion:(void(^)(bool isSucess,NSDictionary *errors))completion;

- (void)queryAppInfoList:(void(^)(NSArray *table,NSArray *titlelist,NSArray *columnnamelist))completion;

@end

#endif
