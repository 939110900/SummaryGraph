//
//  ViewController.m
//  SummaryGraph
//
//  Created by MOKA_MBP on 2019/3/7.
//  Copyright © 2019 weining. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
#import "MXNCircleCharts.h"
#import "PieChartView.h"

#define KDeviceHeight  [[UIScreen mainScreen] bounds].size.height
#define KDeviceWidth   [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //利用贝塞尔三次曲线,绘制曲线图动画
    LineChartView * Lineview = [[LineChartView alloc] initWithFrame:CGRectMake(0,0, KDeviceWidth , 170)];
    Lineview.backgroundColor = [UIColor whiteColor];
    Lineview.valueArray = @[@"60",@"90",@"100",@"80",@"200",@"30"];
    Lineview.monthArray =@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"];
    [self.view addSubview:Lineview];
    
    
    CGFloat width = KDeviceWidth;
    CGFloat height = 200;
    CGFloat chartWidth = height * 0.7;
    CGFloat x = 30;
    CGFloat y = 185;
    
    MXNCircleCharts *circle = [[MXNCircleCharts alloc] initWithFrame:CGRectMake(x, y, 120, 120) withMaxValue:100 value:85];
    
    //    circle.valueTitle = @"85%";
    //    circle.valueColor = [UIColor blackColor];
    //
    //    circle.title = @"我的掌握度";
    //    circle.titleColor = [UIColor blackColor];
    
    circle.colorArray = @[[self colorWithHexString:@"#3C78FF" alpha:1],[self colorWithHexString:@"#66A6FF" alpha:1]];
    
    circle.locations = @[@0.15,@0.85];
    [self.view addSubview:circle];
    
    
    PieChartView *pieChartView = [[PieChartView alloc]initWithFrame:CGRectMake(0, 300, KDeviceWidth, 200)];
    
    pieChartView.ArcCentreCoordinateAll = @[@"20",@"20",@"20",@"20",@"10",@"10",];
    pieChartView.aboveHintTextAttayAll = @[@"交车",@"无效",@"失控",@"战败",@"下订",@"待跟进",];
    pieChartView.belowHintTextAttayAll = @[@"20%",@"20%",@"20%",@"20%",@"10%",@"10%",];
    
    pieChartView.PieChartWidth = 15;
    
    pieChartView.indicatrixLineColor = [UIColor redColor];
    pieChartView.IndicatrixLineWidth = 1.0;
    pieChartView.IndicatrixLineLength = 100;
    
    pieChartView.HintTextFont = 13.0;
    pieChartView.HintTextColor = [UIColor blackColor];
    
    
    [self.view addSubview:pieChartView];
}

#pragma mark 设置16进制颜色
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}




@end
