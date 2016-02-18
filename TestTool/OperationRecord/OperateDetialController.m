//
//  OperateDetialController.m
//  eTMSDriver
//
//  Created by NanTang on 16/1/18.
//  Copyright © 2016年 e6. All rights reserved.
//

#import "OperateDetialController.h"

@interface OperateDetialController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)OperateModel *operate;
@property (nonatomic, strong)NSArray *tableData;
@property (nonatomic)CGFloat cellHeight;

@end

@implementation OperateDetialController

- (instancetype)initWithOperate:(OperateModel *)operate
{
    self = [super init];
    if (self) {
        self.tableData = [operate validPropertyValues];
        self.operate = operate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [self.operate typeString];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 30)];
    labMsg.numberOfLines = 0;
    labMsg.text = self.tableData[indexPath.row];
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


@end
