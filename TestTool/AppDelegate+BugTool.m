//
//  AppDelegate+BugTool.m
//  eTMSDriver
//
//  Created by NanTang on 16/1/18.
//  Copyright © 2016年 e6. All rights reserved.
//

#import "AppDelegate+BugTool.h"
#import "NSObject+Swizzle.h"
#import "AppInfo.h"
#import "AppModel.h"
#import "TestModel.h"
#import "NSUserDefaults+BugTool.h"

@implementation AppDelegate (BugTool)


BOOL _isSaveOperate;
BOOL _isSaveSystemMethod;


+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(application:didFinishLaunchingWithOptions:) tarClass:selfClass tarSel:@selector(application_Debug:didFinishLaunchingWithOptions:)];
    }
}

- (BOOL)application_Debug:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _isSaveOperate = YES;
    _isSaveSystemMethod = NO;
    [self saveTestData];
    BOOL finish = [self application_Debug:application didFinishLaunchingWithOptions:launchOptions];
    return finish;
}

- (void)saveTestData
{
    AppInfo *appInfo = [[AppInfo alloc]init];
    NSString *testID = [NSString stringWithFormat:@"%@%@",appInfo.appDisplayName,[[NSDate date] description]];
    [NSUserDefaults saveCurrentTestID:testID];
    TestModel *testData = [[TestModel alloc]initWithAppID:[appInfo appID] testID:testID startTime:[[NSDate date] description]];
    [[DBBug alloc] insertOperateTest:testData completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            NSLog(@"%@",errors);
        }
    }];
    
    [[DBBug alloc] insertAppInfo:[[AppModel alloc]initWithCurrentInfo] completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            NSLog(@"%@",errors);
        }
    }];
}

#pragma mark - getter/setter

- (void)setIsSaveOperate:(BOOL)saveOperate
{
    _isSaveOperate = saveOperate;
}

- (BOOL)isSaveOperate
{
    return _isSaveOperate;
}


- (void)setIsSaveSystemMethod:(BOOL)isSaveSystemMethod
{
    _isSaveSystemMethod = isSaveSystemMethod;
}

- (BOOL)isSaveSystemMethod
{
    return _isSaveSystemMethod;
}

@end
