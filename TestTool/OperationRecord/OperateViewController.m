//
//  OperateViewController.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/14.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "OperateViewController.h"
#import "FilterViewController.h"
#import "OperateDetialController.h"

@interface OperateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FilterViewController *filterVC;
@property (nonatomic, strong)OperateModel *filterOperate;
@property (nonatomic, strong)NSArray *operateList;
@property (nonatomic)CGFloat cellHeight;

@end

@implementation OperateViewController

- (instancetype)initWithTestID:(NSString *)testID
{
    self = [super init];
    if (self) {
        self.filterOperate.testID = testID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"事件列表";
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    [self setRightBar];
}

- (void)setRightBar
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"过滤" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(0x999999) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showFiltterController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)showFiltterController
{
    [self.navigationController pushViewController:self.filterVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.operateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 30)];
    labMsg.numberOfLines = 0;
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:self.operateList[indexPath.row]];
    OperateModel *operate = [OperateModel modelWithDictionary:data];
    labMsg.text = [operate description];
    labMsg.textColor = RGB(0x999999);
    labMsg.tag = indexPath.row;
    [labMsg sizeToFit];

    UITableViewCell *tabcell = [[UITableViewCell alloc]initWithFrame:labMsg.bounds];
    [tabcell addSubview:labMsg];
    tabcell.backgroundColor = [UIColor clearColor];
    self.cellHeight = labMsg.frame.size.height+8;
    tabcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tabcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:self.operateList[indexPath.row]];
    OperateModel *operate = [OperateModel modelWithDictionary:data];
    [self.navigationController pushViewController:[[OperateDetialController alloc]initWithOperate:operate] animated:YES];
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (FilterViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [FilterViewController shareController];
        __weak typeof(self)weakSelf = self;
        _filterVC.filterOk = ^(OperateModel *operate){
            operate.testID = [weakSelf.filterOperate.testID copy];
            weakSelf.filterOperate = operate;
            DLog(@"%@",[operate description]);
            [[DBBug alloc] queryOperateActionFliter:weakSelf.filterOperate complete:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
                weakSelf.operateList = table;
                [weakSelf.tableView reloadData];
            }];
        };
    }
    return _filterVC;
}

- (OperateModel *)filterOperate
{
    if (!_filterOperate) {
        _filterOperate = [[OperateModel alloc]init];
    }
    return _filterOperate;
}

- (NSArray *)operateList
{
    if (!_operateList) {
        _operateList = [[NSArray alloc]init];
    }
    return _operateList;
}

@end
