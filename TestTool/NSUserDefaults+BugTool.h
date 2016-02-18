//
//  NSUserDefaults+BugTool.h
//  ShowBugMsg
//
//  Created by NanTang on 16/1/16.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (BugTool)

+ (void)saveCurrentTestID:(NSString *)currentTestID;
+ (NSString *)currentTestID;
+ (void)saveCurrentAppID:(NSString *)currentAppID;
+ (NSString *)currentAppID;

@end
