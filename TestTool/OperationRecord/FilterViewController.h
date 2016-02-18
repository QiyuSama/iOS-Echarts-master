//
//  FilterViewController.h
//  ShowBugMsg
//
//  Created by NanTang on 16/1/15.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *txtCurrentVC;
@property (nonatomic, weak) IBOutlet UITextField *txtSource;
@property (nonatomic, weak) IBOutlet UITextField *txtTarget;
@property (nonatomic, weak) IBOutlet UITextField *txtAction;
@property (nonatomic, weak) IBOutlet UIDatePicker *startTime;
@property (nonatomic, weak) IBOutlet UIDatePicker *endTime;
@property (nonatomic, weak) IBOutlet UISwitch *swhSaveMethod;

@property (nonatomic,copy)void(^filterOk)(OperateModel *filterOperate);

+ (instancetype)shareController;

@end
