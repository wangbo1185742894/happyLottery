//
//  CFLineChartView.h
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//
//  本linechartview支持给出x、y值对
//

#import <UIKit/UIKit.h>

// 线条类型
typedef NS_ENUM(NSInteger, LineChartType) {
    LineChartType_Straight, // 折线
    LineChartType_Curve     // 曲线
};
// 点类型
typedef NS_ENUM(NSInteger, PointType) {
    PointType_Rect,   // 方形
    PointType_Circel   // 圆形
};

@interface CFLineChartView : UIView
// x轴值
@property (nonatomic, copy) NSArray *xValues;

// y轴值
@property (nonatomic, copy) NSArray *yValues;

// 是否显示方格
@property (nonatomic, assign) bool isShowLine;
// 是否显示点
@property (nonatomic, assign) bool isShowPoint;
// 是否显示柱状图
@property (nonatomic, assign) bool isShowPillar;
// 是否显示数据
@property (nonatomic, assign) bool isShowValue;

// 初始化折线图所在视图
+ (instancetype)lineChartViewWithFrame:(CGRect)frame;
// 绘制折线图
- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType)pointType;
@end
