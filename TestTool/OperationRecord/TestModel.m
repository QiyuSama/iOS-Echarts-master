//
//  TestModel.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

#pragma mark - init
- (instancetype)initWithAppID:(NSString *)appID
                       testID:(NSString *)testID
                    startTime:(NSString *)startTime
{
    self = [super init];
    if (self) {
        _appID = appID;
        _testID = testID;
        _startTime = startTime;
    }
    return self;
}

#pragma mark - dictionary

+ (TestModel *)modelWithDictionary:(NSDictionary *)dictionary
{
    TestModel *model = [[TestModel alloc] init];
    model.appID = dictionary[@"appID"];
    model.testID = dictionary[@"testID"];
    model.startTime = dictionary[@"startTime"];
    return model;
}

#pragma mark - getter

- (NSString *)appID{
    if(!_appID){
        _appID = @"";
    }
    return _appID;
}

- (NSString *)testID{
    if(!_testID){
        _testID = @"";
    }
    return _testID;
}

- (NSString *)startTime{
    if(!_startTime){
        _startTime = @"";
    }
    return _startTime;
}

#pragma mark - archiv

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _appID = [aDecoder decodeObjectForKey:@"appID"];
        _testID = [aDecoder decodeObjectForKey:@"testID"];
        _startTime = [aDecoder decodeObjectForKey:@"startTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.appID forKey:@"appID"];
    [aCoder encodeObject:self.testID forKey:@"testID"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
}

- (id)copyWithZone:(NSZone *)zone
{
    TestModel *model = [[TestModel alloc] init];
    model.appID = self.appID;
    model.testID = self.testID;
    model.startTime = self.startTime;
    return model;
}

@end
