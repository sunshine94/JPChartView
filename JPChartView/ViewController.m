//
//  ViewController.m
//  JPChartView
//
//  Created by 贾萍 on 16/5/30.
//  Copyright © 2016年 贾萍. All rights reserved.
//

#import "ViewController.h"
#import "JPLineView.h"
@interface ViewController ()
@property(nonatomic,strong)IBOutlet JPLineView *line;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *ddic = @{@"1.5":@"3478.78",@"1.6":@"3578.78",@"1.7":@"3203.78",@"1.8":@"3357.62",@"1.9":@"3866.73",@"1.10":@"3344.90",@"1.11":@"3489.55",@"1.12":@"3325.77",@"1.13":@"3595.12",@"1.14":@"3019.58",@"1.15":@"3478.78",@"1.16":@"3365.11",@"1.17":@"3214.67",@"1.18":@"3789.23",@"1.19":@"3156.78",@"1.20":@"3022.67",@"1.21":@"3566.12",@"1.22":@"3122.45",@"1.23":@"3555.21",@"1.24":@"3145.89",@"1.25":@"3345.65",@"1.26":@"3189.01",@"1.27":@"3621.56",@"1.28":@"3111.11",@"1.29":@"3477.21",@"1.30":@"3322.19",@"1.31":@"2946.09"};
    self.line.yMin = 2900.0;
    self.line.yMax = 3893.0;
    self.line.yInterval = (self.line.yMax-self.line.yMin)/10;
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<11; i++) {
        NSString* str = [NSString stringWithFormat:@"%.2f", self.line.yMin+self.line.yInterval*i];
        [yAxisValues addObject:str];
    }
    NSMutableArray *xArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<ddic.allKeys.count; i++) {
        NSString *str = [NSString stringWithFormat:@"1.%d",5+i];
        [xArray addObject:str];
    }
    self.line.xDataArray = xArray;
    self.line.yDataArray = yAxisValues;
    self.line.axisLeftLineWidth = 39;
    [self.line addData:ddic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
