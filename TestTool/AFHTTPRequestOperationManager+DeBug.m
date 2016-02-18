//
//  AFHTTPRequestOperationManager+DeBug.m
//  eTMSDriver
//
//  Created by NanTang on 16/1/18.
//  Copyright © 2016年 e6. All rights reserved.
//

#import "AFHTTPRequestOperationManager+DeBug.h"
#import "NSObject+Swizzle.h"

@implementation AFHTTPRequestOperationManager (DeBug)

+(void)load
{
    Class selfClass = [self class];
    [NSObject swizzleMethod:selfClass srcSel:@selector(GET:parameters:success:failure:) tarClass:selfClass tarSel:@selector(GET_debug:parameters:success:failure:)];
    [NSObject swizzleMethod:selfClass srcSel:@selector(POST:parameters:success:failure:) tarClass:selfClass tarSel:@selector(POST_debug:parameters:success:failure:)];
}

- (AFHTTPRequestOperation *)GET_debug:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [self GET_debug:URLString parameters:parameters success:^(AFHTTPRequestOperation * request, id data) {
        NSLog(@"%@",parameters);
        success(request,data);
        OperateModel *operate = [[OperateModel alloc]initForControlActionWithSource:@"AFNetWork" currentVC:NSStringFromClass([[self currentViewController] class]) target:@"" action:URLString];
        NSString *input =  [DesEncryptDecipher textFromBase64String:parameters[@"sid"]];
        operate.data = [NSString stringWithFormat:@"输入:\r\n%@\r\n输出:\r\n%@",input,data];
        [[DBBug alloc]insertOperateAction:operate completion:nil];
    } failure:^(AFHTTPRequestOperation *request, NSError *error) {
        failure(request,error);
        OperateModel *operate = [[OperateModel alloc]initForControlActionWithSource:@"AFNetWork" currentVC:NSStringFromClass([[self currentViewController] class]) target:@"" action:URLString];
        operate.data = [NSString stringWithString:error.description];
        [[DBBug alloc]insertOperateAction:operate completion:nil];
    }];
}

- (AFHTTPRequestOperation *)POST_debug:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [self POST_debug:URLString parameters:parameters success:^(AFHTTPRequestOperation * request, id data) {
        success(request,data);
        OperateModel *operate = [[OperateModel alloc]initForControlActionWithSource:@"AFNetWork" currentVC:NSStringFromClass([[self currentViewController] class]) target:@"" action:URLString];
        NSString *input =  [DesEncryptDecipher textFromBase64String:parameters[@"sid"]];
        NSDictionary *dicData = data;
        operate.data = [NSString stringWithFormat:@"输入:\r\n%@\r\n输出:\r\n%@",input,[dicData toStringMoreLines]];
        [[DBBug alloc]insertOperateAction:operate completion:nil];
    } failure:^(AFHTTPRequestOperation *request, NSError *error) {
        failure(request,error);
        OperateModel *operate = [[OperateModel alloc]initForControlActionWithSource:@"AFNetWork" currentVC:NSStringFromClass([[self currentViewController] class]) target:@"" action:URLString];
        operate.data = [NSString stringWithString:error.description];
        [[DBBug alloc]insertOperateAction:operate completion:nil];
    }];
}

- (UIViewController *)currentViewController
{
    AppDelegate *app = [AppDelegate globalDelegate];
    UIViewController *vc = app.window.rootViewController;
    if([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *navVC = (UINavigationController *)vc;
        vc = navVC.childViewControllers.lastObject;
    }
    return vc;
}


@end
