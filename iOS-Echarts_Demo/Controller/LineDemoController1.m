//
//  LineDemoController1.m
//  iOS-Echarts
//
//  Created by NanTang on 16/1/21.
//  Copyright © 2016年 pluto-y. All rights reserved.
//

#import "LineDemoController1.h"

@interface LineDemoController1 ()

@end

@implementation LineDemoController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initAll];
}

-(void)initAll {
    self.title = @"折线图";
    [self showStandardLineDemo];
    [_kEchartView loadEcharts];
}


/**
 *  标准折线图
 */
-(void)showStandardLineDemo {
    PYOption *option = [[PYOption alloc] init];
    //option.backgroundColor = [[PYColor alloc]initWithColor:RGB(0xa19911)];
    PYTitle *title = [[PYTitle alloc] init];
    title.text = @"未来一周气温变化";
    title.subtext = @"纯属虚构";
    option.title = title;
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    tooltip.trigger = @"axis";
    option.tooltip = tooltip;
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);
    grid.x2 = @(50);
    option.grid = grid;
    PYLegend *legend = [[PYLegend alloc] init];
    legend.data = @[@"最高温度",@"最低温度"];
    legend.x  = @(_kEchartView.frame.size.width - 60);//@"right";
    option.legend = legend;
    PYToolbox *toolbox = [[PYToolbox alloc] init];
    toolbox.show = YES;
    toolbox.x = @(_kEchartView.frame.size.width - 160);//@"right";
    toolbox.y = @(26);//@"top";
    toolbox.z = @(100);
    toolbox.feature.mark.show = NO;
    toolbox.feature.dataView.show = YES;
    toolbox.feature.dataView.readOnly = YES;
    toolbox.feature.magicType.show = YES;
    toolbox.feature.magicType.type = @[@"bar", @"line"];
    toolbox.feature.restore.show = NO;
    toolbox.feature.saveAsImage.show = NO;
    option.toolbox = toolbox;
    option.calculable = YES;
    PYAxis *xAxis = [[PYAxis  alloc] init];
    xAxis.type = @"category";
    xAxis.boundaryGap = @(NO);
    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    yAxis.axisLabel.formatter = @"{value} ℃";
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    PYSeries *series1 = [[PYSeries alloc] init];
    series1.name = @"最高温度";
    series1.type = @"line";
    series1.data = @[@(16),@(11),@(15),@(13),@(12),@(13),@(10)];
    PYMarkPoint *markPoint = [[PYMarkPoint alloc] init];
    markPoint.data = @[@{@"type" : @"max", @"name": @"最大值"},@{@"type" : @"min", @"name": @"最小值"}];
    series1.markPoint = markPoint;
    PYMarkLine *markLine = [[PYMarkLine alloc] init];
    markLine.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series1.markLine = markLine;
    PYSeries *series2 = [[PYSeries alloc] init];
    series2.name = @"最低温度";
    series2.type = @"line";
    series2.data = @[@(1),@(-2),@(2),@(5),@(3),@(2),@(0)];
    PYMarkPoint *markPoint2 = [[PYMarkPoint alloc] init];
    markPoint2.data = @[@{@"value" : @(2), @"name": @"周最低", @"xAxis":@(1), @"yAxis" : @(-1.5)}];
    series2.markPoint = markPoint2;
    PYMarkLine *markLine2 = [[PYMarkLine alloc] init];
    markLine2.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series2.markLine = markLine2;
    option.series = [[NSMutableArray alloc] initWithObjects:series1, series2, nil];
    /*option.dataZoom = [[PYDataZoom alloc] init];
     option.dataZoom.show = YES;
     option.dataZoom.start = @(70);*/
    [_kEchartView setOption:option];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
