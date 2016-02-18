//
//  AppModel.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

#pragma mark - init
- (instancetype)initWithAppID:(NSString *)appID
                      appName:(NSString *)appName
                      version:(NSString *)version
                         time:(NSString *)time
{
    self = [super init];
    if (self) {
        _appID = appID;
        _appName = appName;
        _version = version;
        _time = time;
    }
    return self;
}


- (instancetype)initWithCurrentInfo
{
    self = [super init];
    if (self) {
        AppInfo *appInfo = [[AppInfo alloc]init];
        _appID = [appInfo appID];
        _appName = [appInfo appDisplayName];
        _version = [appInfo currentVersion];
        _time = [[NSDate date] description];
    }
    return self;
}

#pragma mark - dictionary

+ (AppModel *)modelWithDictionary:(NSDictionary *)dictionary
{
    AppModel *model = [[AppModel alloc] init];
    model.appID = dictionary[@"appID"];
    model.appName = dictionary[@"appName"];
    model.time = dictionary[@"time"];
    model.version = dictionary[@"version"];
    return model;
    
}

#pragma mark - getter

- (NSString *)appID{
    if(!_appID){
        _appID = @"";
    }
    return _appID;
}

- (NSString *)appName{
    if(!_appName){
        _appName = @"";
    }
    return _appName;
}

- (NSString *)version{
    if(!_version){
        _version = @"";
    }
    return _version;
}

#pragma mark - archiv

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _appID = [aDecoder decodeObjectForKey:@"appID"];
        _appName = [aDecoder decodeObjectForKey:@"appName"];
        _time = [aDecoder decodeObjectForKey:@"time"];
        _version = [aDecoder decodeObjectForKey:@"version"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.appID forKey:@"appID"];
    [aCoder encodeObject:self.appName forKey:@"appName"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.version forKey:@"version"];
}

- (id)copyWithZone:(NSZone *)zone
{
    AppModel *model = [[AppModel alloc] init];
    model.appID = self.appID;
    model.appName = self.appName;
    model.time = self.time;
    model.version = self.version;
    return model;
    
}

@end
