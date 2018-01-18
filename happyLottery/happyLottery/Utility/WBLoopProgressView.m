//
//  LoopProgressView.m
//  头像蒙板
//
//  Created by CUG on 16/1/29.
//  Copyright © 2016年 CUG. All rights reserved.
//

#import "WBLoopProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define ViewWidth self.frame.size.width   //环形进度条的视图宽度
#define ProgressWidth 9               //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth-5  //环形进度条的半径
#define RGBA(r, g, b, a)   [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0)

@interface WBLoopProgressView()
{
    CAShapeLayer *arcLayer;
    UILabel *label1;
    NSTimer *progressTimer;
    UILabel *label2;
}
@property (nonatomic,assign)CGFloat i;

@end

@implementation WBLoopProgressView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    _i=0;
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(progressContext, ProgressWidth);
    
    CGContextSetRGBStrokeColor(progressContext, 245.0/255.0, 245.0/255.0, 245.0/255.0, 1);
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, xCenter, yCenter, Radius,  M_PI*0.95,M_PI * 2.05, 0);
  
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    CGContextSetLineWidth(progressContext, 1);
    CGContextSetRGBStrokeColor(progressContext, 18.0/255.0, 199.0/255.0, 146.0/255.0, 1);
    CGContextAddArc(progressContext, xCenter, yCenter, Radius + 13,  M_PI*0.95,M_PI * 2.05, 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    //    //绘制环形进度环
    CGFloat to = M_PI * 0.95 + self.progress * M_PI * 1.1; // - M_PI * 0.5为改变初始位置
    
    // 进度数字字号,可自己根据自己需要，从视图大小去适配字体字号
    int fontNum = ViewWidth/6;
    int weight = ViewWidth - ProgressWidth*2;
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, weight, ViewWidth/6+ 7)];
    label1.center = CGPointMake(xCenter, yCenter - 6);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:30];
    label1.textColor = self.color1 != nil ? self.color1 : RGB(51, 51, 51);
    label1.text = @"0%";
    [self addSubview:label1];
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius startAngle:M_PI*0.95 endAngle:to clockwise:YES];
    [path moveToPoint:CGPointMake(cos(M_PI*0.95)  * Radius  + xCenter,  sin(M_PI*0.95) * Radius+ yCenter) ];
    for (int i = 0; i < 11; i++) {
        if (i == 10) {
               [path moveToPoint:CGPointMake(cos(M_PI*0.95 + M_PI * (0.11*i -0.01))  * (Radius - 9) + yCenter,  sin(M_PI*0.95 + M_PI * (0.11*i -0.01)) * (Radius - 9) + xCenter)];
              [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius-9 startAngle:M_PI*0.95 + M_PI * 0.11*i endAngle:M_PI*0.95 + M_PI * 0.11*i clockwise:YES];
        }else{
               [path moveToPoint:CGPointMake(cos(M_PI*0.95 + M_PI * 0.11*i)  * (Radius - 9) + yCenter,  sin(M_PI*0.95 + M_PI * 0.11*i) * (Radius - 9) + xCenter)];
             [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius-9 startAngle:M_PI*0.95 + M_PI * 0.11*i endAngle:M_PI*0.95 + M_PI * 0.11*i + 0.02 clockwise:YES];
        }
       
       

    }
    arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;//46,169,230
    
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor=RGB(18, 199, 146).CGColor;
    arcLayer.lineWidth=ProgressWidth;
//    arcLayer.lineCap = @"round";
    arcLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:arcLayer];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self drawLineAnimation:arcLayer];
    });
    
    if (self.progress > 1) {
        NSLog(@"传入数值范围为 0-1");
        self.progress = 1;
    }else if (self.progress < 0){
        NSLog(@"传入数值范围为 0-1");
        self.progress = 0;
        return;
    }
    
    if (self.progress > 0) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
    }
    
}

-(void)newThread
{
    @autoreleasepool {
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

//NSTimer不会精准调用  虚拟机和真机效果不一样
-(void)timeLabel
{
    _i += 0.01;
    dispatch_async(dispatch_get_main_queue(), ^{
        label1.text = [NSString stringWithFormat:@"%.0f%%",_i*100.0];
    });
    
    
    if (_i >= self.progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            label1.text = [NSString stringWithFormat:@"%.0f%%",self.progress*100];
        });
        
        [progressTimer invalidate];
        progressTimer = nil;
        
    }
    
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.progress;//动画时间
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

@end
