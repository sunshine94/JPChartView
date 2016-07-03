//
//  JPLineView.h
//  JPChartView
//
//  Created by 贾萍 on 16/5/30.
//  Copyright © 2016年 贾萍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLineView : UIView
@property(nonatomic,retain)NSDictionary *dataDic;
@property(nonatomic,retain)NSArray *yDataArray;
@property(nonatomic,retain)NSArray *xDataArray;
@property (nonatomic, assign) float  yMax;
@property (nonatomic, assign) float  yMin;
@property (nonatomic, assign) float  yInterval;
@property (nonatomic, assign) float  axisLeftLineWidth;
@property (nonatomic, strong) NSString* fontName;
@property (nonatomic, assign) CGPoint contentScroll;
@property (nonatomic, assign) NSInteger xAxisFontSize;
@property (nonatomic, strong) UIColor*  xAxisFontColor;
@property (nonatomic, assign) NSInteger numberOfVerticalElements;

@property (nonatomic, strong) UIColor * horizontalLinesColor;
@property (nonatomic, assign) float  axisLineWidth;
@property (nonatomic, assign) float  horizontalLineInterval;
@property (nonatomic, assign) float  horizontalLineWidth;
@property (nonatomic, assign) float  pointerInterval;
@property (nonatomic, assign) float  axisBottomLinetHeight;
@property (nonatomic, strong) NSString*  floatNumberFormatterString;
-(void)addData:(NSDictionary *)dic;
@end
