//
//  TestModel.h
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject<NSCoding, NSCopying>

@property (retain,nonatomic) NSString *appID;
@property (retain,nonatomic) NSString *testID;
@property (retain,nonatomic) NSString *startTime;

- (instancetype)initWithAppID:(NSString *)appID
                       testID:(NSString *)testID
                    startTime:(NSString *)startTime;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

+ (TestModel *)modelWithDictionary:(NSDictionary *)dictionary;

@end
