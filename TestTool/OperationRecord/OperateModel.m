//
//  OperateModel.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//
#import "OperateModel.h"
#import "NSUserDefaults+BugTool.h"

@implementation NSDate (bug)

- (NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strTime = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    return strTime;
}

@end

@implementation OperateModel

#pragma mark - init

- (instancetype)initForRespondActionWithCurrentVC:(NSString *)currentVC
                                        action:(NSString *)action
{
    return [self initWithTestID:[NSUserDefaults currentTestID] source:@"" currentVC:currentVC target:@"" action:action type:OperateRespondAction];
}

- (instancetype)initForControlActionWithSource:(NSString *)source
                                     currentVC:(NSString *)currentVC
                                        target:(NSString *)target
                                        action:(NSString *)action
{
    return [self initWithTestID:[self defaultTestID] source:source currentVC:currentVC target:target action:action type:OperateControlAction];
}

- (instancetype)initForSwitchWithCurrentVC:(NSString *)currentVC
                                  newVC:(NSString *)newVC
                                 action:(NSString *)action
{
    return [self initWithTestID:[self defaultTestID] source:@"" currentVC:currentVC target:newVC action:action type:OperateSwitchPages];
}

- (instancetype)initWithTestID:(NSString *)testID
                        source:(NSString *)source
                     currentVC:(NSString *)currentVC
                        target:(NSString *)target
                        action:(NSString *)action
                          type:(OperateType)type
{
    self = [super init];
    if (self) {
        _source = source;
        _currentVC = currentVC;
        _target = target;
        _action = action;
        _testID = testID;
        _time = [[NSDate date] description];
        _type = [[NSNumber alloc]initWithInteger:type];
    }
    return self;
}

#pragma mark - dictionary

+ (OperateModel *)modelWithDictionary:(NSDictionary *)dictionary
{
    OperateModel *model = [[OperateModel alloc] init];
    model.source = dictionary[@"source"];
    model.currentVC = dictionary[@"currentVC"];
    model.target = dictionary[@"target"];
    model.action = dictionary[@"action"];
    model.testID = dictionary[@"testID"];
    model.time = dictionary[@"time"];
    model.data = dictionary[@"data"];
    model.type = dictionary[@"type"];
    return model;
}

#pragma mark - getter

- (NSString *)source{
    if(!_source){
        _source = @"";
    }
    return _source;
}

- (NSString *)currentVC{
    if(!_currentVC){
        _currentVC = @"";
    }
    return _currentVC;
}

- (NSString *)target{
    if(!_target){
        _target = @"";
    }
    return _target;
}

- (NSString *)action{
    if(!_action){
        _action = @"";
    }
    return _action;
}

- (NSString *)testID{
    if(!_testID){
        _testID = @"";
    }
    return _testID;
}

- (NSString *)time{
    if(!_time){
        _time = @"";
    }
    return _time;
}

- (NSNumber *)type{
    if(!_type){
        _type = @0;
    }
    return _type;
}

- (NSString *)data
{
    if(!_data){
        _data = @"";
    }
    return _data;
}

- (NSString *)defaultTestID
{
    static NSString *currentTestID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTestID = [NSUserDefaults currentTestID];
    });
    return currentTestID;
}

#pragma mark - archiv

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _source = [aDecoder decodeObjectForKey:@"source"];
        _currentVC = [aDecoder decodeObjectForKey:@"currentVC"];
        _target = [aDecoder decodeObjectForKey:@"target"];
        _action = [aDecoder decodeObjectForKey:@"action"];
        _testID = [aDecoder decodeObjectForKey:@"testID"];
        _time = [aDecoder decodeObjectForKey:@"time"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _data = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.currentVC forKey:@"currentVC"];
    [aCoder encodeObject:self.target forKey:@"target"];
    [aCoder encodeObject:self.action forKey:@"action"];
    [aCoder encodeObject:self.testID forKey:@"testID"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.data forKey:@"data"];
}

- (id)copyWithZone:(NSZone *)zone
{
    OperateModel *model = [[OperateModel alloc] init];
    model.source = self.source;
    model.currentVC = self.currentVC;
    model.target = self.target;
    model.action = self.action;
    model.testID = self.testID;
    model.time = self.time;
    model.type = self.type;
    model.data = self.data;
    return model;
}

- (NSString *)typeString
{
    return [OperateModel typeToString:self.type.integerValue];
}

+ (NSString *)typeToAsscillString:(OperateType)typeValue
{
    if (typeValue == OperateControlAction) {
        return @"ControlAction";
    }else if (typeValue == OperateRespondAction) {
        return @"RespondAction";
    }if (typeValue == OperateSwitchPages) {
        return @"SwitchPages";
    }
    return @"SwitchPages";
}


+ (NSString *)typeToString:(OperateType)typeValue
{
    if (typeValue == OperateControlAction) {
        return @"用户事件";
    }else if (typeValue == OperateRespondAction) {
        return @"系统事件";
    }if (typeValue == OperateSwitchPages) {
        return @"页面切换";
    }
    return @"事件类型异常";
}

- (void)setTypeByOperateType:(OperateType)type
{
    self.type = [[NSNumber alloc]initWithInteger:type];
}

- (NSString *)description1
{
    return [NSString stringWithFormat:@"testID:%@,type:%@,currentVC:%@,source:%@,target:%@,action:%@",self.testID,[self typeString],self.currentVC,self.source,self.target,self.action];
}

- (NSArray *)validPropertyValues
{
    NSInteger typeValue = self.type.integerValue;
    NSMutableArray *mutValues = [[NSMutableArray alloc]initWithCapacity:0];
    [mutValues addObject:[NSString stringWithFormat:@"操作时间:%@",self.time]];
    [mutValues addObject:[NSString stringWithFormat:@"当前控制器:%@",self.currentVC]];
        [mutValues addObject:[NSString stringWithFormat:@"执行方法:%@",self.action]];
    if (typeValue == OperateControlAction) {
        [mutValues addObject:[NSString stringWithFormat:@"来源:%@",self.source]];
        [mutValues addObject:[NSString stringWithFormat:@"目标:%@",self.target]];
        [mutValues addObject:[NSString stringWithFormat:@"数据:%@",self.data]];
    }else if (typeValue == OperateSwitchPages) {
        [mutValues addObject:[NSString stringWithFormat:@"目标:%@",self.target]];
    }
    return mutValues;
}

- (NSString *)description
{
    NSInteger typeValue = self.type.integerValue;
    if (typeValue == OperateControlAction) {
        NSString *data = @"";
        if (self.data.length > 0) {
            data = [NSString stringWithFormat:@"数据:%@",self.data];
            data = [data stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            if (data.length>20) {
                data = [NSString stringWithFormat:@"\r\n%@...",[data substringToIndex:20]];
            }else{
                data = [NSString stringWithFormat:@"\r\n%@",data];
            }
        }
        return [NSString stringWithFormat:@"类型:%@\r\n当前控制器:%@\r\n执行方法:%@\r\n来源:%@\r\n目标:%@%@\r\n时间:%@",[self typeString],self.currentVC,self.action,self.source,self.target,data,self.time];
        
    }else if(typeValue == OperateRespondAction){
        return [NSString stringWithFormat:@"类型:%@\r\n当前控制器:%@\r\n执行方法:%@\r\n时间:%@",[self typeString],self.currentVC,self.action,self.time];
    
    }else if(typeValue == OperateSwitchPages){
        return [NSString stringWithFormat:@"类型:%@\r\n当前控制器:%@\r\n执行方法:%@\r\n目标:%@\r\n时间:%@",[self typeString],self.currentVC,self.action,self.target,self.time];
    }
    return @"数据类型异常";
}

@end

