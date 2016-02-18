//
//  CatchAction.m
//  TeachAppOC
//
//  Created by NanTang on 16/1/4.
//  Copyright © 2016年 NewMoon. All rights reserved.
//

#import "CatchAction.h"
#import "NSObject+Swizzle.h"

@implementation UIControl (catchAction)


+(void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(sendAction:to:forEvent:) tarClass:selfClass tarSel:@selector(sendAction_debug:to:forEvent:)];
    }
}

- (void)sendAction_debug:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
        SK_TRY_BODY(
                    NSObject *obj = target;
                    UIViewController *vc = self.window.rootViewController;
                    if([vc isKindOfClass:[UINavigationController class]]){
                        UINavigationController *navVC = (UINavigationController *)vc;
                        vc = navVC.childViewControllers.lastObject;
                    }
                    
                    OperateModel *operate = [[OperateModel alloc] initForControlActionWithSource:NSStringFromClass([self class]) currentVC:NSStringFromClass([vc class]) target:NSStringFromClass([obj class]) action:NSStringFromSelector(action)];
                    
                    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
                    }];
                    if(isLogCatchAction){
                        DLog(@"OperateModel:%@",[operate description]);
                    }
                    );
    [self sendAction_debug:action to:target forEvent:event];
}

@end


@implementation UIViewController (catchAction)

+ (void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(presentViewController:animated:completion:) tarClass:selfClass tarSel:@selector(presentViewController_debug:animated:completion:)];
    }
}

- (void)presentViewController_debug:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [self presentViewController_debug:viewControllerToPresent animated:flag completion:completion];
    OperateModel *operate = [[OperateModel alloc] initForSwitchWithCurrentVC:NSStringFromClass([self class]) newVC:NSStringFromClass([viewControllerToPresent class]) action:@"presentViewController"];
    if(isLogCatchAction){
        DLog(@"OperateModel:%@",[operate description]);
    }
    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            DLog(@"%@",errors);
        }
    }];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL isrespond = [super respondsToSelector:aSelector];
    if (dbugIsSaveSystemMethod) {
        OperateModel *operate = [[OperateModel alloc] initForRespondActionWithCurrentVC:NSStringFromClass([self class]) action:NSStringFromSelector(aSelector)];
        [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
            if (!isSucess) {
                DLog(@"%@",errors);
            }
        }];
        if(isLogCatchAction){
            DLog(@"OperateModel:%@",[operate description]);
        }
    }
    return isrespond;
}

- (void)didPopBack
{

}

@end

@implementation UINavigationController (catchAction)

+ (void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(popViewControllerAnimated:) tarClass:selfClass tarSel:@selector(popViewControllerAnimated_Debug:)];
        [NSObject swizzleMethod:selfClass srcSel:@selector(pushViewController:animated:) tarClass:selfClass tarSel:@selector(pushViewController_Debug:animated:)];
    }
}

- (UIViewController *)popViewControllerAnimated_Debug:(BOOL)animated
{
    UIViewController *vc = [self popViewControllerAnimated_Debug:animated];
    NSString *newVCName = NSStringFromClass([self.childViewControllers.lastObject class]);
    [vc didPopBack];
    OperateModel *operate = [[OperateModel alloc] initForSwitchWithCurrentVC:NSStringFromClass([vc class]) newVC:newVCName action:@"popViewControllerAnimated:"];
    if(isLogCatchAction){
        DLog(@"OperateModel:%@",[operate description]);
    }
    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            DLog(@"%@",errors);
        }
    }];
    return vc;
}

- (void)pushViewController_Debug:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *currentVCName = NSStringFromClass([self.childViewControllers.lastObject class]);
    [self pushViewController_Debug:viewController animated:animated];
    OperateModel *operate = [[OperateModel alloc] initForSwitchWithCurrentVC:currentVCName newVC:NSStringFromClass([viewController class]) action:@"pushViewController"];
    if(isLogCatchAction){
        DLog(@"OperateModel:%@",[operate description]);
    }
    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            DLog(@"%@",errors);
        }
    }];
}

@end

@implementation UITableView (catchAction)

+ (void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(selectRowAtIndexPath:animated:scrollPosition:) tarClass:selfClass tarSel:@selector(selectRowAtIndexPath_Debug:animated:scrollPosition:)];
    }
}

- (void)selectRowAtIndexPath_Debug:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self selectRowAtIndexPath_Debug:indexPath animated:animated scrollPosition:scrollPosition];
    UIViewController *vc = self.window.rootViewController;
    if([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *navVC = (UINavigationController *)vc;
        vc = navVC.childViewControllers.lastObject;
    }
    
    OperateModel *operate = [[OperateModel alloc] initForControlActionWithSource:NSStringFromClass([self class]) currentVC:NSStringFromClass([vc class]) target:NSStringFromClass([self class]) action:@"selectRowAtIndexPath:animated:scrollPosition:"];
    
    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
    }];
}

@end

@implementation UITextField (catchAction)

+ (void)load
{
    if (isCatchAction) {
        Class selfClass = [self class];
        [NSObject swizzleMethod:selfClass srcSel:@selector(presentViewController:animated:completion:) tarClass:selfClass tarSel:@selector(presentViewController_debug:animated:completion:)];
        [NSObject swizzleMethod:selfClass srcSel:@selector(initWithFrame:) tarClass:selfClass tarSel:@selector(initWithFrame_Debug:)];
        [NSObject swizzleMethod:selfClass srcSel:@selector(drawRect:) tarClass:selfClass tarSel:@selector(drawRect_Debug:)];
    }
}

- (instancetype)initWithFrame_Debug:(CGRect)frame
{
    self = [self initWithFrame_Debug:frame];
    [self addTarget:self action:@selector(textFieldDidChange_CatchAction:) forControlEvents:UIControlEventEditingDidEnd];
    return self;
}

- (void)drawRect_Debug:(CGRect)rect
{
    [self drawRect_Debug:rect];
    [self addTarget:self action:@selector(textFieldDidChange_CatchAction:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void) textFieldDidChange_CatchAction:(UITextField *) textField{
    OperateModel *operate = [[OperateModel alloc] initForControlActionWithSource:NSStringFromClass([self class]) currentVC:NSStringFromClass([[self currentViewController] class]) target:@"UITextField" action:@"textFieldDidChange"];
    operate.data = [NSString stringWithFormat:@"%@,%@",textField.text,NSStringFromCGRect([textField frame])];
    [[DBBug alloc]insertOperateAction:operate completion:^(bool isSucess, NSDictionary *errors) {
        if (!isSucess) {
            DLog(@"%@",errors);
        }
    }];
    if(isLogCatchAction){
        DLog(@"OperateModel:%@",[operate description]);
    }
}

@end
