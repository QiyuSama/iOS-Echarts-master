//
//  OperateModel.h
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OperateControlAction = 1,
    OperateRespondAction = 2,
    OperateSwitchPages = 3
} OperateType;

@interface OperateModel : NSObject<NSCoding, NSCopying>

@property (retain,nonatomic) NSString *source;
@property (retain,nonatomic) NSString *currentVC;
@property (retain,nonatomic) NSString *target;
@property (retain,nonatomic) NSString *action;
@property (retain,nonatomic) NSString *testID;
@property (retain,nonatomic) NSString *time;
@property (retain,nonatomic) NSNumber *type;

@property (retain,nonatomic) NSString *data;

@property (retain,nonatomic) NSString *fitterStartTime;
@property (retain,nonatomic) NSString *fitterEndTime;


- (instancetype)initForRespondActionWithCurrentVC:(NSString *)currentVC
                                        action:(NSString *)action;

- (instancetype)initForControlActionWithSource:(NSString *)source
                                     currentVC:(NSString *)currentVC
                                        target:(NSString *)target
                                        action:(NSString *)action;

- (instancetype)initForSwitchWithCurrentVC:(NSString *)currentVC
                                  newVC:(NSString *)newVC
                                 action:(NSString *)action;


- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)setTypeByOperateType:(OperateType)type;
+ (OperateModel *)modelWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)typeToString:(OperateType)typeValue;

- (NSArray *)validPropertyValues;
- (NSString *)typeString;

@end
