//
//  AppDelegate+BugTool.h
//  eTMSDriver
//
//  Created by NanTang on 16/1/18.
//  Copyright © 2016年 e6. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (BugTool)

- (void)setIsSaveOperate:(BOOL)saveOperate;
- (BOOL)isSaveOperate;
- (void)setIsSaveSystemMethod:(BOOL)isSaveSystemMethod;
- (BOOL)isSaveSystemMethod;

+ (AppDelegate *)globalDelegate;

@end
