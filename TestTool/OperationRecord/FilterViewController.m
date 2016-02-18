//
//  FilterViewController.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/15.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) OperateModel *filterOperate;

@end

@implementation FilterViewController


+ (instancetype)shareController
{
    FilterViewController *vc = [[[NSBundle mainBundle] loadNibNamed:@"FilterViewController" owner:nil options:nil] firstObject];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.swhSaveMethod setOn:dbugIsSaveSystemMethod animated:NO];
    [self.view tapToHideKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFilterOperateValue
{
    self.filterOperate.currentVC = self.txtCurrentVC.text;
    self.filterOperate.source = self.txtSource.text;
    self.filterOperate.target = self.txtTarget.text;
    self.filterOperate.action = self.txtAction.text;
    self.filterOperate.fitterStartTime = [self.startTime.date toStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    self.filterOperate.fitterEndTime = [self.endTime.date toStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    if (self.filterOk) {
        [self.navigationController popViewControllerAnimated:YES];
        self.filterOk(self.filterOperate);
    }
}

#pragma mark - action

- (IBAction)userControlAction:(UIButton *)btn
{
    [self.filterOperate setTypeByOperateType:OperateControlAction];
    [self setFilterOperateValue];
}

- (IBAction)respondAction:(UIButton *)btn
{
    [self.filterOperate setTypeByOperateType:OperateRespondAction];
    [self setFilterOperateValue];
}


- (IBAction)allAction:(UIButton *)btn
{
    self.filterOperate.type = @0;
    [self setFilterOperateValue];
}

- (IBAction)switchPagesAction:(UIButton *)btn
{
    [self.filterOperate setTypeByOperateType:OperateSwitchPages];
    [self setFilterOperateValue];
}

- (IBAction)clearActionDataAction:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"将清空所有数据，是否继续?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[DBBug alloc]clearActionData];
    }
}


- (IBAction)switchReceiveSystemMethod:(UISwitch *)switchBtn
{
    if (switchBtn.on) {
        dbugSetIsSaveSystemMethod(YES);
    }else{
        dbugSetIsSaveSystemMethod(NO);
    }
}

#pragma mark - getter

- (OperateModel *)filterOperate
{
    if (!_filterOperate) {
        _filterOperate = [[OperateModel alloc]init];
    }
    return _filterOperate;
}

@end
