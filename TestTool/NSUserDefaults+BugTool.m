//
//  NSUserDefaults+BugTool.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/16.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "NSUserDefaults+BugTool.h"

static NSString *kCurrentTestID = @"kCurrentTestID";
static NSString *kCurrentAppID = @"kCurrentAppID";


@implementation NSUserDefaults (BugTool)


+ (void)saveCurrentTestID:(NSString *)currentTestID
{
    [[NSUserDefaults standardUserDefaults] setObject:currentTestID forKey:kCurrentTestID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentTestID
{
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentTestID];
    return password;
}

+ (void)saveCurrentAppID:(NSString *)currentAppID
{
    [[NSUserDefaults standardUserDefaults] setObject:currentAppID forKey:kCurrentAppID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentAppID
{
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentAppID];
    return password;
}

@end
