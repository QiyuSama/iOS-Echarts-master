//
//  UIView+Addition.m
//  iOS-Echarts
//
//  Created by NanTang on 16/1/20.
//  Copyright © 2016年 pluto-y. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (UIViewController *)currentViewController
{
    UIViewController *vc = self.window.rootViewController;
    if([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *navVC = (UINavigationController *)vc;
        vc = navVC.childViewControllers.lastObject;
    }
    return vc;
}
UIView *keyBordForView;
- (void)tapToHideKeyBoard
{
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

- (void)tapToHideKeyBoardForView:(UIView *)view
{
    keyBordForView = view;
    [self tapToHideKeyBoard];
}

- (IBAction)viewTapped:(UITapGestureRecognizer*)tap
{
    if (keyBordForView) {
        [keyBordForView endEditing:YES];
    }else{
        [self endEditing:YES];
    }
}

@end
