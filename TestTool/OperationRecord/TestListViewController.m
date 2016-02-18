//
//  TestListViewController.m
//  ShowBugMsg
//
//  Created by NanTang on 16/1/15.
//  Copyright © 2016年 NanTang. All rights reserved.
//

#import "TestListViewController.h"
#import "OperateViewController.h"

@interface TestListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *appInfos;


@property (nonatomic, strong) NSArray *testNameList;
@property (nonatomic, strong) NSArray *testList;

@end

@implementation UIButton (data)

NSDictionary *_extData;
- (void)setExtData:(NSDictionary *)extData
{
    _extData = extData;
}

- (NSDictionary *)extData
{
    return _extData;
}

@end

@interface CellDataModel : NSObject

@property (nonatomic, retain) AppModel *appInfo;
@property (nonatomic, retain) TestModel *testInfo;

@end

@implementation CellDataModel

- (instancetype)initWithAppInfo:(AppModel *)appInfo
                       testInfo:(TestModel *)testInfo
{
    self = [super init];
    if (self) {
        self.appInfo = appInfo;
        self.testInfo = testInfo;
    }
    return self;
}

@end



@implementation TestListViewController

CGFloat cellHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"事件列表";
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
}

- (void)viewWillAppear:(BOOL)animated
{
    dbugSetIsSaveOperate(NO);
    [super viewWillAppear:animated];
    [self tableViewReloadData];
}

- (void)didPopBack
{
    dbugSetIsSaveOperate(YES);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.testList.count;
    NSArray *arr = dicTestData[appIDList[section]];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 30)];
    labMsg.numberOfLines = 0;
    CellDataModel *cellData = dicTestData[appIDList[indexPath.section]][indexPath.row];
    labMsg.text = [NSString stringWithFormat:@"测试时间:%@",cellData.testInfo.startTime];
    labMsg.textColor = RGB(0x999999);
    labMsg.tag = indexPath.row;
    [labMsg sizeToFit];
    
    UITableViewCell *tabcell = [[UITableViewCell alloc]initWithFrame:labMsg.frame];
    [tabcell addSubview:labMsg];
    tabcell.backgroundColor = [UIColor clearColor];
    cellHeight = labMsg.frame.size.height+10;
    tabcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tabcell;
}
- (UITableViewCell *)tableView1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 30)];
    labMsg.numberOfLines = 0;
    CellDataModel *cellData = dicTestData[appIDList[indexPath.section]][indexPath.row];
    labMsg.text = [NSString stringWithFormat:@"测试时间:%@",cellData.testInfo.startTime];
    labMsg.textColor = RGB(0x999999);
    labMsg.tag = indexPath.row;
    [labMsg sizeToFit];
    
    UIButton *btnShowDetial = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, labMsg.frame.size.height+20)];
     [btnShowDetial addTarget:self action:@selector(showOperateList:) forControlEvents:UIControlEventTouchUpInside];
     [btnShowDetial setExtData:@{@"indexPath":indexPath}];
    UITableViewCell *tabcell = [[UITableViewCell alloc]initWithFrame:btnShowDetial.frame];
    //[tabcell addSubview:btnShowDetial];
    [tabcell addSubview:labMsg];
    tabcell.backgroundColor = [UIColor clearColor];
    cellHeight = btnShowDetial.frame.size.height;
    tabcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tabcell;
}

- (UITableViewCell *)tableView2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *labMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-10, 30)];
    labMsg.numberOfLines = 0;
    TestModel *test = [TestModel modelWithDictionary:self.testList[indexPath.row]];
    NSDictionary *data = self.appInfos[test.appID];
    AppModel *appInfo = [AppModel modelWithDictionary:data];
    labMsg.text = [NSString stringWithFormat:@"%@\r\n%@\r\n%@",appInfo.appName,appInfo.version,test.startTime];
    labMsg.textColor = RGB(0x999999);
    labMsg.tag = indexPath.row;
    [labMsg sizeToFit];
    
    UIButton *btnShowDetial = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, labMsg.frame.size.height+20)];
    [btnShowDetial addTarget:self action:@selector(showOperateList:) forControlEvents:UIControlEventTouchUpInside];
    btnShowDetial.tag = indexPath.row;
    
    UITableViewCell *tabcell = [[UITableViewCell alloc]initWithFrame:btnShowDetial.frame];
    [tabcell addSubview:btnShowDetial];
    [tabcell addSubview:labMsg];
    tabcell.backgroundColor = [UIColor clearColor];
    cellHeight = btnShowDetial.frame.size.height+20;
    tabcell.selectedBackgroundView = nil;
    return tabcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDataModel *cellData = dicTestData[appIDList[indexPath.section]][indexPath.row];
    OperateViewController *operateVC = [[OperateViewController alloc]initWithTestID:cellData.testInfo.testID];
    [self.navigationController pushViewController:operateVC animated:YES];
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

#pragma mark - Action


- (IBAction)showOperateList:(UIButton *)btn
{
    NSIndexPath *indexPath = [btn extData][@"indexPath"];
    CellDataModel *cellData = dicTestData[appIDList[indexPath.section]][indexPath.row];
    OperateViewController *operateVC = [[OperateViewController alloc]initWithTestID:cellData.testInfo.testID];
    [self.navigationController pushViewController:operateVC animated:YES];
}

- (IBAction)showOperateList1:(UIButton *)btn
{
    TestModel *test = [TestModel modelWithDictionary:self.testList[btn.tag]];
    OperateViewController *operateVC = [[OperateViewController alloc]initWithTestID:test.testID];
    [self.navigationController pushViewController:operateVC animated:YES];
}

NSDictionary *dicTestData;
NSArray *sectionTitles;
NSArray *appIDList;

- (void)tableViewReloadData
{
    NSMutableArray *titles = [[NSMutableArray alloc]initWithCapacity:0];
    [[DBBug alloc] queryAppInfoList:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        NSMutableArray *appIDs = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *dic in table) {
            AppModel *appInfo = [AppModel modelWithDictionary:dic];
            [titles addObject:[NSString stringWithFormat:@"%@ %@",appInfo.appName,appInfo.version]];
            [appIDs addObject:appInfo.appID];
            [[DBBug alloc] queryOperateTestListWithFliter:appInfo completion:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
                
                NSMutableArray *cellDatas = [[NSMutableArray alloc]initWithCapacity:0];
                for (NSDictionary *testDic in table) {
                    
                    TestModel *testInfo = [TestModel modelWithDictionary:testDic];
                    [cellDatas addObject:[[CellDataModel alloc]initWithAppInfo:appInfo testInfo:testInfo]];
                }
                mutDic[appInfo.appID] = cellDatas;
            }];
        }
        dicTestData = mutDic;
        sectionTitles = titles;
        appIDList = appIDs;
        //self.appInfos = mutDic;
        [self.tableView reloadData];
    }];
}

- (void)tableViewReloadData1
{
    [[DBBug alloc] queryOperateTestList:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        self.testList = table;
        [self.tableView reloadData];
    }];
    
    [[DBBug alloc] queryAppInfoList:^(NSArray *table, NSArray *titlelist, NSArray *columnnamelist) {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        for (NSDictionary *dic in table) {
            mutDic[dic[@"appID"]] = dic;
        }
        self.appInfos = mutDic;
        [self.tableView reloadData];
    }];
}


#pragma mark - getter
- (NSArray *)testList
{
    if (!_testList) {
        _testList = [[NSArray alloc]init];
    }
    return _testList;
}

- (NSArray *)testNameList
{
    if (!_testNameList) {
        _testNameList = [[NSArray alloc]init];
    }
    return _testNameList;
}

@end
