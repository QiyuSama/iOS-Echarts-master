//
//  AppInfo.m
//  OCTool
//
//  Created by NanTang on 15/11/16.
//  Copyright © 2015年 NanTang. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

#pragma mark - AppInfo

- (NSString *)appDescription
{
    NSMutableArray *description = [[NSMutableArray alloc]initWithCapacity:0];
    // 当前应用名称
    NSString *appCurName = self.appDisplayName;
    [description addObject:[NSString stringWithFormat:@"当前应用名称：%@",appCurName]];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [self.appInfos objectForKey:@"CFBundleShortVersionString"];
    [description addObject:[NSString stringWithFormat:@"当前应用软件版本:%@",appCurVersion]];
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [self.appInfos objectForKey:@"CFBundleVersion"];
    [description addObject:[NSString stringWithFormat:@"当前应用版本号码：%@",appCurVersionNum]];
    
//    NSLog(@"当前应用名称：%@",appCurName);
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
//    NSLog(@"%@",description);
//    NSLog(@"description%@",description.description);
//    NSLog(@"当前应用版本号码：%@",self.appInfos);
    return description.description;
}

- (NSString *)currentVersion
{
    // 当前应用软件版本  比如：1.0.1
    return [self.appInfos objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)bundleIdentifier
{
    // 当前应用软件版本  比如：1.0.1
    return [self.appInfos objectForKey:@"CFBundleIdentifier"];
}

- (NSString *)appID
{
    return [NSString stringWithFormat:@"%@_%@",[self.appInfos objectForKey:@"CFBundleIdentifier"],[self.appInfos objectForKey:@"CFBundleShortVersionString"]];
}

#pragma mark - getter

- (NSString *)appDisplayName
{
    if (!_appDisplayName) {
        _appDisplayName = [self.appInfos objectForKey:@"CFBundleDisplayName"];
        if (!_appDisplayName) {
            _appDisplayName = [self.appInfos objectForKey:@"CFBundleName"];
        }
    }
    return _appDisplayName;
}

- (NSDictionary *)appInfos
{
    if (!_appInfos) {
        _appInfos = [NSBundle mainBundle].infoDictionary;
    }
    return _appInfos;
}

@end
