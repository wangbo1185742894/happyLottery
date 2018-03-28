//
//  EXQiHaoView.m
//  Test
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 Yang. All rights reserved.
//

#import "EXQiHaoView.h"
#import "LotteryRound.h"

#define cellH  20

@implementation EXQiHaoView



-(CGSize)remakerViewFram:(NSArray *)source{
    
    self.source = source;
    qihao_width = 100;
    NSUInteger sourceCount = _source.count;
    Frame_height = cellH * sourceCount;  // 总高度
    CGSize size= CGSizeMake(qihao_width, Frame_height);
    return size;
}

- (void)drawRect:(CGRect)rect {
    NSUInteger sourceCount = _source.count;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);//标记
//    if (!CGRectEqualToRect(highLightFram, CGRectZero)) {
//        [self performSelector:@selector(disableHighLight) withObject:nil afterDelay:0.7];
//        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//        CGContextSetLineWidth(context, 2);
//        CGPoint point_fir = CGPointMake(CGRectGetMaxX(highLightFram), CGRectGetMinY(highLightFram));
//        CGPoint point_sec = CGPointMake(CGRectGetMinX(highLightFram), CGRectGetMinY(highLightFram));
//        CGPoint point_thir = CGPointMake(CGRectGetMinX(highLightFram), CGRectGetMaxY(highLightFram));
//        CGPoint point_four = CGPointMake(CGRectGetMaxX(highLightFram), CGRectGetMaxY(highLightFram));
//
//        CGContextMoveToPoint(context, point_fir.x, point_fir.y);
//        CGContextAddLineToPoint(context, point_sec.x, point_sec.y);
//        CGContextAddLineToPoint(context, point_thir.x, point_thir.y);
//        CGContextAddLineToPoint(context, point_four.x, point_four.y);
//        
//    }
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 0.7);
     CGContextSetRGBStrokeColor(context, 232/255.0, 79/255.0, 42/255.0, 1);
    // 所有横线
    for (int i=0; i<sourceCount+1; i++) {
        float y = cellH * i;
        CGContextMoveToPoint(context, 0, y);
//        CGContextAddLineToPoint(context, qihao_width, y);
        CGContextStrokePath(context);
        CGRect rect = CGRectMake(0, y, qihao_width, cellH);
        if (i % 2 == 0) {
            //lc
            CGContextSetRGBFillColor(context, 246.0/255.0,246.0/255.0,246.0/255.0, 1.0);
        }
        else{
            CGContextSetRGBFillColor(context, 255.0/255.0,255.0/255.0,255.0/255.0, 1.0);
        }
        //填充矩形
        CGContextFillRect(context, rect);
        CGContextStrokePath(context);
    }
    CGContextStrokePath(context);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //lc  修改了字体颜色
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                        NSParagraphStyleAttributeName: paragraphStyle,
                                        NSForegroundColorAttributeName:TEXTGRAYCOLOR};

    for(int i=0;i<sourceCount;i++){
       LotteryRound * round  = _source[i];
        NSString * qihaoString = [NSString stringWithFormat:@"%@ 期",round.issueNumber];
        CGRect qihao_frame = CGRectMake(0, cellH*i, qihao_width, cellH);
        [qihaoString drawInRect:qihao_frame withAttributes:attributes];
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}


- (void)disableHighLight{
    highLightFram = CGRectZero;
    [self setNeedsDisplay];
}


- (void)cellChoose:(int)index{
    if (index == -1) {
        [self setNeedsDisplay];
        return;
    }
    highLightFram = CGRectMake(0, index*cellH, qihao_width, cellH);
    [self setNeedsDisplay];
}
@end
