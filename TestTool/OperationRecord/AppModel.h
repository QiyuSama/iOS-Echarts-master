//
//  AppModel.h
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "AppInfo.h"

@interface AppModel : NSObject<NSCoding, NSCopying>

@property (retain,nonatomic) NSString *appID;
@property (retain,nonatomic) NSString *appName;
@property (retain,nonatomic) NSString *time;
@property (retain,nonatomic) NSString *version;

- (instancetype)initWithCurrentInfo;
- (instancetype)initWithAppID:(NSString *)appID
                      appName:(NSString *)appName
                      version:(NSString *)version
                         time:(NSString *)time;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

+ (AppModel *)modelWithDictionary:(NSDictionary *)dictionary;

@end
