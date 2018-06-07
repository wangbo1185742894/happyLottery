//
//  CFLineChartView.m
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFLineChartView.h"

static CGRect myFrame;
static int count;   // 点个数，x轴格子数
static int yCount;  // y轴格子数
static CGFloat everyX;  // x轴每个格子宽度
static CGFloat everyY;  // y轴每个格子高度
static CGFloat maxY;    // 最大的y值
static CGFloat allH;    // 整个图表高度
static CGFloat allW;    // 整个图表宽度
#define kMargin 30
@interface CFLineChartView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation CFLineChartView

+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
    CFLineChartView *lineChartView = [[NSBundle mainBundle] loadNibNamed:@"CFLineChartView" owner:self options:nil].lastObject;
    lineChartView.frame = frame;
    
    myFrame = frame;
    
    return lineChartView;
}


#pragma mark - 计算

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    // 移除多余的值，计算点个数
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    count = (int)self.xValues.count;
    
    everyX = (CGFloat)(CGRectGetWidth(myFrame) - kMargin * 2) / count;
    
    // y轴最多分5部分
    yCount = count <= 5 ? count : 5;
    
    everyY =  (CGRectGetHeight(myFrame) - kMargin * 2) / yCount;
    
    maxY = CGFLOAT_MIN;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    
    allH = CGRectGetHeight(myFrame) - kMargin * 2;
    allW = CGRectGetWidth(myFrame) - kMargin * 2;
}

#pragma mark - 画X、Y轴
- (void)drawXYLine{
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(kMargin, kMargin / 2.0 - 5)];
    
    [path addLineToPoint:CGPointMake(kMargin, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
    
    // 加箭头
//    [path moveToPoint:CGPointMake(kMargin - 5, kMargin/ 2.0 + 4)];
//    [path addLineToPoint:CGPointMake(kMargin, kMargin / 2.0 - 4)];
//    [path addLineToPoint:CGPointMake(kMargin + 5, kMargin/ 2.0 + 4)];
    
//    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin - 5)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = RGBCOLOR(180, 180, 180).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.0;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - 添加label
- (void)drawLabels{
    
    //Y轴
    for(int i = 0; i <= yCount; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kMargin  + everyY * i - everyY / 2, kMargin - 1, everyY)];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:11];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = [NSString stringWithFormat:@"%d", (int)(maxY / yCount * (yCount - i)) ];
//        if (i == 0) {
//            [self.bgView addSubview:lbl];
//            lbl.text = [NSString stringWithFormat:@"%.1f",maxY];
//        }
//        if (i == yCount - 1) {
//            lbl.mj_y =  kMargin  + everyY * yCount +1 ;
//            [self.bgView addSubview:lbl];
//            lbl.text = [NSString stringWithFormat:@"0.0"];
//            
//        }
        
    }
    
    // X轴
    for(int i = 1; i <= count; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kMargin + everyX * i - everyX / 2, CGRectGetHeight(myFrame) - kMargin, everyX, kMargin)];
        
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:12];
        //lbl.backgroundColor = [UIColor brownColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i - 1]];
        
        [self.bgView addSubview:lbl];
    }
    
}


#pragma mark - 画网格
- (void)drawLines{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 横线
    for (int i = 0; i < yCount; i ++) {
        [path moveToPoint:CGPointMake(kMargin , kMargin + everyY * i)];
        [path addLineToPoint:CGPointMake(kMargin + allW ,  kMargin + everyY * i)];
    }
    // 竖线
    for (int i = 1; i <= count; i ++) {
        [path moveToPoint:CGPointMake(kMargin + everyX * i, kMargin)];
        [path addLineToPoint:CGPointMake( kMargin + everyX * i,  kMargin + allH)];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.bgView.layer addSublayer:layer];
    
}


#pragma mark - 画点
- (void)drawPointsWithPointType:(PointType)pointType{
    // 画点
    switch (pointType) {
        case PointType_Rect:
            
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                layer.frame = CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5);
                layer.backgroundColor = SystemGreen.CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            break;
            
        case PointType_Circel:
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                
                UIBezierPath *path = [UIBezierPath
                                      
                                      //    方法1                          bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                                      
                                      //    方法2
                                      bezierPathWithRoundedRect:CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5) cornerRadius:2.5];
                
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = SystemGreen.CGColor;
                layer.fillColor = SystemGreen.CGColor;
                [self.bgView.layer addSublayer:layer];
            }

            break;
    }
}

#pragma mark - 画柱状图
- (void)drawPillar{
    for (int i = 0; i < count; i ++) {
        CGPoint point = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
        
        CGFloat width = everyX <= 20 ? 10: 20;
        
        CGRect rect = CGRectMake(point.x - width / 2, point.y, width, (CGRectGetHeight(myFrame) -  kMargin - point.y));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor yellowColor].CGColor;
        
        [self.bgView.layer addSublayer:layer];

    }
    
}

#pragma mark - 画折线\曲线
- (void)drawFoldLineWithLineChartBack:(LineChartType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // CGFloat allH = CGRectGetHeight(myFrame) - kMargin * 2;
    [path moveToPoint:CGPointMake(kMargin , kMargin + allH)];
    
    CGPoint nowPoint = CGPointMake(kMargin + everyX, kMargin + (1 - [self.yValues[0] floatValue] / maxY) * allH);
    
    // 两个控制点的两个x中点为X值，preY、nowY为Y值；
    
    [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+kMargin)/2, kMargin + allH) controlPoint2:CGPointMake((nowPoint.x+kMargin)/2, kMargin + (1 - [self.yValues[0] floatValue] / maxY) * allH)];
    switch (type) {
        case LineChartType_Straight:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH)];
            }
            break;
        case LineChartType_Curve:
            
            for (int i = 1; i < count; i ++) {
                
                CGPoint prePoint = CGPointMake(kMargin + everyX * i, kMargin + (1 - [self.yValues[i-1] floatValue] / maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
                
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            
            [path addLineToPoint:CGPointMake(kMargin + everyX *_xValues.count , kMargin + allH -1)];
            [path addLineToPoint:CGPointMake(kMargin  , kMargin + allH - 1)];
            
            break;
           
    }
  
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    layer.path = path.CGPath;
//    layer.strokeColor = [UIColor clearColor].CGColor; //.
//    layer.fillColor =RGBCOLOR(215, 250, 240).CGColor;
//    [self.bgView.layer addSublayer:layer];
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bgView.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    //绘制渐变
    [self drawLinearGradient:gc path:path.CGPath startColor:RGBCOLOR(215, 250, 240).CGColor endColor:[UIColor whiteColor].CGColor];
    
    //注意释放CGMutablePathRef
//    CGPathRelease(path.CGPath);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.bgView addSubview:imgView];
    
}
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
#pragma mark - 画折线\曲线
- (void)drawFoldLineWithLineChartType:(LineChartType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // CGFloat allH = CGRectGetHeight(myFrame) - kMargin * 2;
    [path moveToPoint:CGPointMake(kMargin , kMargin + allH)];
    
    CGPoint nowPoint = CGPointMake(kMargin + everyX, kMargin + (1 - [self.yValues[0] floatValue] / maxY) * allH);
    
    // 两个控制点的两个x中点为X值，preY、nowY为Y值；
    
    [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+kMargin)/2, kMargin + allH) controlPoint2:CGPointMake((nowPoint.x+kMargin)/2, kMargin + (1 - [self.yValues[0] floatValue] / maxY) * allH)];
    [path moveToPoint:CGPointMake(kMargin + everyX, kMargin + (1 - [self.yValues.firstObject floatValue] / maxY) * allH)];
    switch (type) {
        case LineChartType_Straight:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH)];
            }
            break;
        case LineChartType_Curve:
            
            for (int i = 1; i < count; i ++) {
        
                CGPoint prePoint = CGPointMake(kMargin + everyX * i, kMargin + (1 - [self.yValues[i-1] floatValue] / maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
                
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            break;
        
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self.bgView.layer addSublayer:layer];
    
}


#pragma mark - 显示数据
- (void)drawValues{
    for (int i = 0; i < count; i ++) {
        CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - 30/2.0-5, nowPoint.y - 20, 30+3, 15)];
        lbl.backgroundColor = SystemGreen;
        lbl.layer.cornerRadius = lbl.mj_h / 2;
        lbl.layer.masksToBounds = YES;
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:lbl];
        
        
    }
    
}

#pragma mark - 整合 画图表
- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType) pointType{
    // 计算赋值
    [self doWithCalculate];
    
    NSArray *layers = [self.bgView.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
    // 画柱状图
    if(self.isShowPillar){
         [self drawPillar];
    }
    
    // 画网格线
    if (self.isShowLine) {
         [self drawLines];
    }
    
    // 画X、Y轴
    [self drawXYLine];
    
    // 添加文字
    [self drawLabels];
    
    
    // 画折线
    [self drawFoldLineWithLineChartType:lineType];
    [self drawFoldLineWithLineChartBack:lineType];
    // 画点
    if (self.isShowPoint) {
        [self drawPointsWithPointType:pointType];
    }
    
    // 显示数据
    if(self.isShowValue){
        [self drawValues];
    }
    
}


@end
