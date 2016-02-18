//
//  UIView+Addition.h
//  iOS-Echarts
//
//  Created by NanTang on 16/1/20.
//  Copyright © 2016年 pluto-y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

- (UIViewController *)currentViewController;
- (void)tapToHideKeyBoard;
- (void)tapToHideKeyBoardForView:(UIView *)view;

@end
