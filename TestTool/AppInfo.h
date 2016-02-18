//
//  AppInfo.h
//  OCTool
//
//  Created by NanTang on 15/11/16.
//  Copyright © 2015年 NanTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInfo : NSObject

@property(strong,nonatomic)NSDictionary *appInfos;
@property(strong,nonatomic)NSString *appDisplayName;

- (NSString *)appDescription;
- (NSString *)phoneDescription;

- (NSString *)currentVersion;
- (NSString *)bundleIdentifier;
- (NSString *)appID;

@end
