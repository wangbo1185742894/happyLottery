//
//  EXPingCeView.m
//  Test
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 Yang. All rights reserved.
//

#import "EXPingCeView.h"

#define cellH  20

@implementation EXPingCeView


-(CGSize)remakeFram:(int)baseNumMaxValue_{
    
    baseNumMaxValue =baseNumMaxValue_;
    CGSize size = CGSizeMake(baseNumMaxValue * cellH, cellH * 4);
    return size;
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
     num_w_h = cellH;

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    
//    CGContextSetGrayStrokeColor(context,0.2,0.3);
//    CGContextSetRGBStrokeColor(context, 153/255.0, 153/255.0, 153/255.0, 1);
    CGContextSetStrokeColorWithColor(context, SEPCOLOR.CGColor);
    //趋势颜色！！！
    //RGBCOLOR(253, 139, 82);出现次数字体颜色   254 241 235
    //RGBCOLOR(137, 186, 106)；最大连出字体颜色  245 255 238
    //RGBCOLOR(45, 113, 194); 最大遗漏字体颜色  240 249 255
    //RGBCOLOR(228, 102, 90)； 出现概率字体颜色  255 246 243
    
//            float y = cellH * i;
//            CGContextMoveToPoint(context, 0, y);
//            CGContextAddLineToPoint(context,baseNumMaxValue * num_w_h, y);
//    所有的横线都是用背景色空出来的
    for (int i=0; i< 4+1; i++) {
        
       
        
        CGRect backFrame = CGRectMake(0, cellH * i , baseNumMaxValue * cellH, cellH-SEPHEIGHT);
        
        if (i == 0) {
            
             backFrame = CGRectMake(0, cellH * i + SEPHEIGHT , baseNumMaxValue * cellH, cellH-2*SEPHEIGHT);
            CGContextSetRGBFillColor(context, 254/255.0, 241/255.0, 235/255.0, 1);
            CGContextFillRect(context, backFrame);
            CGContextStrokePath(context);
            
        }else if (i == 1){
    
            CGContextSetRGBFillColor(context, 245/255.0, 255/255.0, 238/255.0, 1);
            CGContextFillRect(context, backFrame);
                        CGContextStrokePath(context);
            
        }else if (i == 2){
           
            CGContextSetRGBFillColor(context, 240/255.0, 249/255.0, 255/255.0, 1);
            CGContextFillRect(context, backFrame);
                        CGContextStrokePath(context);
            
        }else if (i == 3){
//
            CGContextSetRGBFillColor(context, 255/255.0, 246/255.0, 243/255.0, 1);
            CGContextFillRect(context, backFrame);
                        CGContextStrokePath(context);
            
        }
        

    
    }
    
   
    
        // 所有竖线
    for (int i=0; i<baseNumMaxValue+1; i++) {
        float x = cellH * i;
        CGContextMoveToPoint(context, x, 0);
        CGContextAddLineToPoint(context,x, num_w_h * 4);
       
        

    }
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //RGBCOLOR(253, 139, 82);出现次数字体颜色   254 241 235
    //RGBCOLOR(137, 186, 106)；最大连出字体颜色  245 255 238
    //RGBCOLOR(45, 113, 194); 最大遗漏字体颜色  240 249 255
    //RGBCOLOR(228, 102, 90)； 出现概率字体颜色  255 246 243
    
    CGFloat offset = 2.5;
    [self drawInfoToCanvas:_appearTimeDic textColor:RGBCOLOR(253, 139, 82) originY:0+offset];
    [self endStroke:context];
    
    [self drawInfoToCanvas:_maxLianchuDic textColor:RGBCOLOR(137, 186, 106) originY:cellH+offset];
    [self endStroke:context];
    
    [self drawInfoToCanvas:_maxYilouDic textColor:RGBCOLOR(45, 113, 194) originY:cellH*2+offset];
    [self endStroke:context];
    
    [self drawInfoToCanvas:_appearPositinDic textColor:RGBCOLOR(228, 102, 90) originY:cellH*3+offset];
    [self endStroke:context];

}


-(void)drawInfoToCanvas:(NSDictionary *)infoDic textColor:(UIColor *)color originY:(float)y{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                          NSParagraphStyleAttributeName: paragraphStyle,
                                          NSForegroundColorAttributeName:color};
    for(int i=0;i<baseNumMaxValue;i++){
        NSString * num = infoDic[[NSString stringWithFormat:@"%d",i+1]];
        if (nil == num) {
            num = @"0";
        }
        CGRect num_frame = CGRectMake(num_w_h*i,y, num_w_h, num_w_h);
        [num drawInRect:num_frame withAttributes:attributes];
    }
}

-(void)endStroke:(CGContextRef)context{

    CGContextStrokePath(context);
}

@end
