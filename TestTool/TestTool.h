//
//  TestTool.h
//  IOSCommon
//
//  Created by NanTang on 16/1/18.
//  Copyright © 2016年 NewMoon. All rights reserved.
//



#ifndef TestTool_h
#define TestTool_h

#import "TestModel.h"
#import "OperateModel.h"
#import "UIView+Addition.h"
#import "DBBug.h"          //刷新控件
#import "AppDelegate+BugTool.h"

#define dbugIsSaveOperate [[AppDelegate globalDelegate] isSaveOperate]
#define dbugSetIsSaveOperate(isSaveOperate) [[AppDelegate globalDelegate] setIsSaveOperate:isSaveOperate]
#define dbugIsSaveSystemMethod [[AppDelegate globalDelegate] isSaveSystemMethod]
#define dbugSetIsSaveSystemMethod(isSaveSystemMethod) [[AppDelegate globalDelegate] setIsSaveSystemMethod:isSaveSystemMethod]
#define isCatchAction ([DBBug needCatchAction])
#define isLogCatchAction YES


#pragma mark - 颜色

#define RGB(x) [UIColor colorWithRed:((x & 0xff0000) >> 16)/255.0 green:((x & 0x00ff00) >> 8)/255.0 blue:(x & 0x0000ff)/255.0 alpha:1.0]
#define RGBA(x, a) [UIColor colorWithRed:((x & 0xff0000) >> 16)/255.0 green:((x & 0x00ff00) >> 8)/255.0 blue:(x & 0x0000ff)/255.0 alpha:a]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define SK_TRY_BODY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
DLog(@"%@",exception);\
}\
@finally {\
\
}

#pragma mark - 打印日志
#ifdef DEBUG

#define DLog( ... ) NSLog(__VA_ARGS__)

#else

#define DLog( ... )

#endif

#endif /* TestTool_h */
