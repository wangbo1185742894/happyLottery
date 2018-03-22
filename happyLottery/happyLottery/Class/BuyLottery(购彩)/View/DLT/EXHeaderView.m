//
//  EXHeaderView.m
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "EXHeaderView.h"

#define cellH 20

@implementation EXHeaderView

-(CGSize)remakerViewFram:(int)baseNumMaxValue_{
    baseNumMaxValue =baseNumMaxValue_;
    CGSize size = CGSizeMake(baseNumMaxValue * cellH, cellH * 4);
    return size;
}

-(CGSize)remakerViewFram:(int)baseNumMaxValue_ isPL:(BOOL)isPL_;{
    
    baseNumMaxValue =baseNumMaxValue_;
    CGSize size = CGSizeMake(baseNumMaxValue  * cellH + cellH, cellH * 4);
    isPL = isPL_;
    return size;
}

- (void)drawRect:(CGRect)rect {

    int num_w_h = cellH;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);//标记
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, SEPCOLOR.CGColor);
  

    // 所有竖线
    
    
        for (int i=0; i<baseNumMaxValue + 1; i++) {
            float x = cellH * i;
            CGContextMoveToPoint(context, x, 0);
            CGContextAddLineToPoint(context,x, num_w_h);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                    NSForegroundColorAttributeName:TEXTGRAYCOLOR};
    
    if (isPL == YES) {
        for(int i=0;i<baseNumMaxValue;i++){
            NSString * numString = [NSString stringWithFormat:@"%d",i];
            CGRect num_frame = CGRectMake(num_w_h*i,2, num_w_h, num_w_h);
            [numString drawInRect:num_frame withAttributes:attributes];
        }
    }else{
        for(int i=0;i<baseNumMaxValue;i++){
            NSString * numString = [NSString stringWithFormat:@"%d",i+1];
            CGRect num_frame = CGRectMake(num_w_h*i,2, num_w_h, num_w_h);
            [numString drawInRect:num_frame withAttributes:attributes];
        }
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
    self.backgroundColor = [UIColor whiteColor];
}

@end
