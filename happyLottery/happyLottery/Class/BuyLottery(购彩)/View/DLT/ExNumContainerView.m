//
//  ExNumContainerView.m
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "ExNumContainerView.h"
#import "LotteryRound.h"

#define cellH  20
#define num_w_h 20

#define BACKGROUNDCOLOR

@implementation ExNumContainerView

-(CGSize)remakerViewFram:(NSArray *)source{
    highLightfram = CGRectZero;
    self.source = source;
    NSUInteger sourceCount = _source.count;
    Frame_height = cellH * sourceCount;  // 总高度
        Frame_width =  cellH * _baseNumMaxValue;  // 总宽度
    if(self.superview){
        float widht = CGRectGetWidth(self.superview.frame);
        if (widht > Frame_width) {
            Frame_width = widht;
        }
    }
    CGSize size= CGSizeMake(Frame_width, Frame_height);
    return size;
}


- (void)drawRect:(CGRect)rect {
    
    NSString  * imageName;
    // lc  替换图片
    if ([_lottery.identifier isEqualToString:@"DLT"] && _dltSectionType == DltSectionTypeAfter) {
        imageName = @"blueBall";
    }else{
        imageName = @"redBall";
    }
    NSUInteger sourceCount = _source.count;
    
    NSMutableArray * tempSourceArray = [NSMutableArray arrayWithCapacity:_source.count];
    if ([_lottery.identifier isEqualToString:@"DLT"]) {
        
        [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LotteryRound * round = (LotteryRound *)obj;
            if (_dltSectionType == DltSectionTypeNotSet || _dltSectionType == DltSectionTypeFront) {
                [tempSourceArray addObject:round.mainRes];
            }else{
                [tempSourceArray addObject:round.subRes];
            }
        }];
    }else if ([_lottery.identifier isEqualToString:@"PL3"] ||[_lottery.identifier isEqualToString:@"PL5"]){
        [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (_index == -1) {
                LotteryRound * round = (LotteryRound *)obj;
                [tempSourceArray addObject:round.mainRes];
            }else{
                LotteryRound * round = (LotteryRound *)obj;
                NSArray *tempArray = [round.mainRes componentsSeparatedByString:@" "];
                [tempSourceArray addObject:tempArray[_index]];
            }
           
        }];
        
    }else if ([_lottery.identifier isEqualToString:@"X115"]){
        if (_x115PlayType == x115PlayTypeQianYi) {
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                NSArray * numArray = [round.mainRes componentsSeparatedByString:@" "];
                [tempSourceArray addObject:numArray[0]];
            }];
        }else if (_x115PlayType == x115PlayTypeQianEr){
            
            NSRange rang;
            if (_x115SectionType == X115SectionTypeWan) {
                rang = NSMakeRange(0, 2);
            }else if (_x115SectionType == X115SectionTypeQian){
                
                rang = NSMakeRange(3, 2);
            }else{
                
            }
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                NSString * stringToDraw = [round.mainRes substringWithRange:rang];
                [tempSourceArray addObject:stringToDraw];
            }];
        }else if (_x115PlayType == x115PlayTypeQianSan){
            NSRange rang;
            if (_x115SectionType == X115SectionTypeWan) {
                rang = NSMakeRange(0, 2);
            }else if (_x115SectionType == X115SectionTypeQian){
                rang = NSMakeRange(3, 2);
            }else if (_x115SectionType == X115SectionTypeBai){
                rang = NSMakeRange(6, 2);
            }else{
                
            }
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                //格式化开奖号码
                NSString *betCountStr = [NSString stringWithFormat: @"%@", round.mainRes];
                NSArray *betnumArray = [betCountStr componentsSeparatedByString:@" "];
                NSString *betNumStr = @"";
                for (int i=0; i<betnumArray.count; i++) {
                    NSString *tempstr;
                    if([betnumArray[i] intValue] < 10)
                    {
                        tempstr = [NSString stringWithFormat:@"0%d",[betnumArray[i] intValue]];
                    }
                    else
                    {
                        tempstr = [NSString stringWithFormat:@"%@",betnumArray[i]];
                    }
                    betNumStr = [betNumStr stringByAppendingString:tempstr];
                    betNumStr = [betNumStr stringByAppendingString:@" "];
                }

                NSString * numString =[betNumStr substringWithRange:rang];
//              NSString * numString =[round.mainRes substringWithRange:rang];
                [tempSourceArray addObject:numString];
            }];
        }else if (_x115PlayType == x115PlayTypeQianErZu){
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                NSString * numString = [round.mainRes substringToIndex:5];
                [tempSourceArray addObject:numString];
            }];
        }else if (_x115PlayType == x115PlayTypeQianSanZu){
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                NSString * numString = [round.mainRes substringToIndex:8];
                [tempSourceArray addObject:numString];
            }];
        }else if (_x115PlayType == x115PlayTypeDefualt){
            [_source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryRound * round = (LotteryRound *)obj;
                [tempSourceArray addObject:round.mainRes];
            }];
        }
    }
    
    self.sourceToDraw = [NSMutableArray arrayWithArray:tempSourceArray];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context,self.bounds);
    CGContextBeginPath(context);//标记
    
//    if (!CGRectEqualToRect(highLightfram, CGRectZero)) {
//        [self performSelector:@selector(disableHighLight) withObject:nil afterDelay:0.7];
//        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//        CGContextSetLineWidth(context, 2);
//        CGPoint point_fir = CGPointMake(CGRectGetMinX(highLightfram), CGRectGetMinY(highLightfram));
//        CGPoint point_sec = CGPointMake(CGRectGetMaxX(highLightfram), CGRectGetMinY(highLightfram));
//        CGPoint point_thir = CGPointMake(CGRectGetMaxX(highLightfram), CGRectGetMaxY(highLightfram));
//        CGPoint point_four = CGPointMake(CGRectGetMinX(highLightfram), CGRectGetMaxY(highLightfram));
//        
//        CGContextMoveToPoint(context, point_fir.x, point_fir.y);
//        CGContextAddLineToPoint(context, point_sec.x, point_sec.y);
//        CGContextAddLineToPoint(context, point_thir.x, point_thir.y);
//        CGContextAddLineToPoint(context, point_four.x, point_four.y);
//    }
//    
//    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 0.7);
    CGContextSetGrayStrokeColor(context,0.3	,0.3);
    
    

    //lc 去掉所有线
    // 所有横线
    for (int i=0; i<sourceCount+1; i++) {
        float y = 0 + cellH * i;
        CGContextMoveToPoint(context, 0, y);
        //        CGContextAddLineToPoint(context, Frame_width, y);
        CGContextStrokePath(context);
        CGRect rect = CGRectMake(0, y, Frame_width, cellH);
        if (i % 2 == 0) {
            CGContextSetRGBFillColor(context, 246.0/255.0,246.0/255.0,246.0/255.0, 1.0);
        }
        else{   //lc  将背景颜色 全部 换成一种
            CGContextSetRGBFillColor(context, 255.0/255.0,255.0/255.0,255.0/255.0, 1.0);
        }
        //填充矩形
        CGContextFillRect(context, rect);
        CGContextStrokePath(context);
    }
    CGContextStrokePath(context);
    //  所有竖线
    for (int i=0; i<_baseNumMaxValue+1; i++) {
        float x =  i * num_w_h;
        CGContextMoveToPoint(context, x, 0);
        //        CGContextAddLineToPoint(context, x, Frame_height);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes_nomal = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                        NSParagraphStyleAttributeName: paragraphStyle,
                                        NSForegroundColorAttributeName:TEXTGRAYCOLOR};
    NSDictionary *attributes_Pith = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                       NSParagraphStyleAttributeName: paragraphStyle,
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
        if ([_lottery.identifier isEqualToString:@"PL3"] ||[_lottery.identifier isEqualToString:@"PL5"]) {
            NSMutableDictionary * dicTemp = [NSMutableDictionary dictionaryWithCapacity:_baseNumMaxValue];
            for (int i=0; i<_baseNumMaxValue; i++) {
                [dicTemp setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
            }
            NSMutableDictionary * maxYilouDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * maxLianxuDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            
            NSMutableDictionary * numAppearTimeDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * numPitchLianxuDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * numPitchYilouDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            
            for(int i=0;i<sourceCount;i++){
                NSString *numDes  = _sourceToDraw[i];
                //处理开奖号码格式
                //手动开奖号码格式为1、2、3、4…… 转化为01、02、03……
                NSArray *betnumArray = [numDes componentsSeparatedByString:@" "];
                self.numArr = [NSArray new];
                self.numArr = betnumArray;
                NSString *betNumStr = @"";
                int i;
                if ([_lottery.identifier isEqualToString:@"PL3"]||[_lottery.identifier isEqualToString:@"PL5"] ) {
                    i = 0;
                }else{
                
                    i = 1;
                }
                for (; i<betnumArray.count; i++) {
                    NSString *tempstr;
                    if([betnumArray[i] intValue] < 10)
                    {
                        tempstr = [NSString stringWithFormat:@"0%d",[betnumArray[i] intValue]];
                    }
                    else
                    {
                        tempstr = [NSString stringWithFormat:@"%@",betnumArray[i]];
                    }
                    betNumStr = [betNumStr stringByAppendingString:tempstr];
                    betNumStr = [betNumStr stringByAppendingString:@" "];
                }
                numDes = betNumStr;
                NSMutableArray * numPithArray = [NSMutableArray arrayWithArray:[numDes componentsSeparatedByString:@" "]];
                
                // 内容
                for (int j=0; j<_baseNumMaxValue + 1; j++) {
                    
                    CGFloat imgOffset = 1;
                    
                    
                    CGRect numStringFram = CGRectMake((j-1)*num_w_h, cellH*i+2, num_w_h, num_w_h);
                    
                    CGRect imgFrame = CGRectMake((j-1)*num_w_h+imgOffset, cellH*i+imgOffset, num_w_h-imgOffset*2, num_w_h-imgOffset*2);
                    
                    NSString * key = [NSString stringWithFormat:@"%d",j];
                    BOOL isPith = NO;
                    NSString * toFindString;
                    toFindString = [NSString stringWithFormat:@"0%d",j - 1];
                    if (numPithArray.count != 0 &&  [numDes rangeOfString:[NSString stringWithFormat:@"%@",toFindString]].location != NSNotFound) {
                        UIImage *image = [UIImage imageNamed:imageName];
                        [image drawInRect:imgFrame];
                        [numPithArray removeObjectAtIndex:0];
                        isPith = YES;
                        
                        //  记录出现次数
                        NSString * appear_Times = numAppearTimeDic[key];
                        if (appear_Times) {
                            appear_Times = [NSString stringWithFormat:@"%d",([appear_Times intValue]+1)];
                        }else{
                            appear_Times = @"1";
                        }
                        numAppearTimeDic[key] = appear_Times;
                        // 增加连续出现
                        
                        NSString * appearLianxu_Times = numPitchLianxuDic[key];
                        NSString * new_appearLianxu_Times =[NSString stringWithFormat:@"%d",([appearLianxu_Times intValue]+1)];
                        numPitchLianxuDic[key] = new_appearLianxu_Times;
                        
                        //记录最大遗漏次数
                        NSString * maxYilouTime = maxYilouDic[key];
                        NSString * curYilouTime = numPitchYilouDic[key];
                        NSString * newMaxYilouTime = [curYilouTime intValue] > [maxYilouTime intValue] ?curYilouTime:maxYilouTime;
                        maxYilouDic[key] = newMaxYilouTime;
                        numPitchYilouDic[key] = @"0";
                    }else{
                        // 记录最大连续出现次数
                        NSString * maxAppearTime = maxLianxuDic[key];
                        NSString * curAppearLianxuTime = numPitchLianxuDic[key];
                        NSString * newMaxLianxu = [curAppearLianxuTime intValue] > [maxAppearTime intValue]?curAppearLianxuTime:maxAppearTime;
                        maxLianxuDic[key] = newMaxLianxu;
                        numPitchLianxuDic[key] = @"0";
                        // 增加漏续出现
                        NSString * appearYilou_Times = numPitchYilouDic[key];
                        NSString * newYilou_Times = [NSString stringWithFormat:@"%d",([appearYilou_Times intValue]+1)];
                        numPitchYilouDic[key] = newYilou_Times;
                    }
                    NSString * numString;
                    
                        numString = [NSString stringWithFormat:@"0%d",j - 1];
                    
                    [numString drawInRect:numStringFram withAttributes:isPith?attributes_Pith:attributes_nomal];
                }
            }
            for (int i=0; i<_baseNumMaxValue+1; i++) {
                NSString * key = [NSString stringWithFormat:@"%d",i];
                // 记录最大连续出现次数
                NSString * maxAppearTime = maxLianxuDic[key];
                NSString * curAppearLianxuTime = numPitchLianxuDic[key];
                NSString * newMaxLianxu = [curAppearLianxuTime intValue] > [maxAppearTime intValue]?curAppearLianxuTime:maxAppearTime;
                maxLianxuDic[key] = newMaxLianxu;
                
                //记录最大遗漏次数
                NSString * maxYilouTime = maxYilouDic[key];
                NSString * curYilouTime = numPitchYilouDic[key];
                NSString * newMaxYilouTime = [curYilouTime intValue] > [maxYilouTime intValue] ?curYilouTime:maxYilouTime;
                maxYilouDic[key] = newMaxYilouTime;
                numPitchYilouDic[key] = @"0";
                
            }
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
            NSMutableDictionary * appearPositionDic = [NSMutableDictionary dictionary];
            [[numAppearTimeDic allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString * number = (NSString *)obj;
                NSString * times = numAppearTimeDic[number];
                float n = [times intValue] / (float)sourceCount;
                int position = n * 100;
                appearPositionDic[number] = [NSString stringWithFormat:@"%d",position];
            }];
            
            [self.delegate nowPingceResultWithAppearTime:numAppearTimeDic Lianxu:maxLianxuDic yilou:maxYilouDic appearPropertion:appearPositionDic];
        }else{
            NSMutableDictionary * dicTemp = [NSMutableDictionary dictionaryWithCapacity:_baseNumMaxValue];
            for (int i=1; i<_baseNumMaxValue+1; i++) {
                [dicTemp setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
            }
            NSMutableDictionary * maxYilouDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * maxLianxuDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            
            NSMutableDictionary * numAppearTimeDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * numPitchLianxuDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            NSMutableDictionary * numPitchYilouDic = [NSMutableDictionary dictionaryWithDictionary:dicTemp];
            
            for(int i=0;i<sourceCount;i++){
                NSString *numDes  = _sourceToDraw[i];
                //处理开奖号码格式
                //手动开奖号码格式为1、2、3、4…… 转化为01、02、03……
                NSArray *betnumArray = [numDes componentsSeparatedByString:@" "];
                NSString *betNumStr = @"";
                for (int i=0; i<betnumArray.count; i++) {
                    NSString *tempstr;
                    if([betnumArray[i] intValue] < 10)
                    {
                        tempstr = [NSString stringWithFormat:@"0%d",[betnumArray[i] intValue]];
                    }
                    else
                    {
                        tempstr = [NSString stringWithFormat:@"%@",betnumArray[i]];
                    }
                    betNumStr = [betNumStr stringByAppendingString:tempstr];
                    betNumStr = [betNumStr stringByAppendingString:@" "];
                }
                numDes = betNumStr;
                
                NSMutableArray * numPithArray = [NSMutableArray arrayWithArray:[numDes componentsSeparatedByString:@" "]];
                
                for (int j=1; j<_baseNumMaxValue+1; j++) {
                    
                    CGRect numStringFram = CGRectMake((j-1)*num_w_h, cellH*i+2, num_w_h, num_w_h);
                    CGFloat imgOffset = 1;
                    CGRect imgFrame = CGRectMake((j-1)*num_w_h+imgOffset, cellH*i+imgOffset, num_w_h-imgOffset*2, num_w_h-imgOffset*2);
                    
                    NSString * key = [NSString stringWithFormat:@"%d",j];
                    BOOL isPith = NO;
                    NSString * toFindString;
                    if (j<10) {
                        toFindString = [NSString stringWithFormat:@"0%d",j];
                    }else{
                        toFindString = [NSString stringWithFormat:@"%d",j];
                    }
                    if (numPithArray.count != 0 &&  [numDes rangeOfString:[NSString stringWithFormat:@"%@",toFindString]].location != NSNotFound) {
                        UIImage *image = [UIImage imageNamed:imageName];
                        [image drawInRect:imgFrame];
                        [numPithArray removeObjectAtIndex:0];
                        isPith = YES;
                        
                        //  记录出现次数
                        NSString * appear_Times = numAppearTimeDic[key];
                        if (appear_Times) {
                            appear_Times = [NSString stringWithFormat:@"%d",([appear_Times intValue]+1)];
                        }else{
                            appear_Times = @"1";
                        }
                        numAppearTimeDic[key] = appear_Times;
                        // 增加连续出现
                        
                        NSString * appearLianxu_Times = numPitchLianxuDic[key];
                        NSString * new_appearLianxu_Times =[NSString stringWithFormat:@"%d",([appearLianxu_Times intValue]+1)];
                        numPitchLianxuDic[key] = new_appearLianxu_Times;
                        
                        //记录最大遗漏次数
                        NSString * maxYilouTime = maxYilouDic[key];
                        NSString * curYilouTime = numPitchYilouDic[key];
                        NSString * newMaxYilouTime = [curYilouTime intValue] > [maxYilouTime intValue] ?curYilouTime:maxYilouTime;
                        maxYilouDic[key] = newMaxYilouTime;
                        numPitchYilouDic[key] = @"0";
                    }else{
                        // 记录最大连续出现次数
                        NSString * maxAppearTime = maxLianxuDic[key];
                        NSString * curAppearLianxuTime = numPitchLianxuDic[key];
                        NSString * newMaxLianxu = [curAppearLianxuTime intValue] > [maxAppearTime intValue]?curAppearLianxuTime:maxAppearTime;
                        maxLianxuDic[key] = newMaxLianxu;
                        numPitchLianxuDic[key] = @"0";
                        // 增加漏续出现
                        NSString * appearYilou_Times = numPitchYilouDic[key];
                        NSString * newYilou_Times = [NSString stringWithFormat:@"%d",([appearYilou_Times intValue]+1)];
                        numPitchYilouDic[key] = newYilou_Times;
                    }
                    NSString * numString;
                    if (j<10) {
                        numString = [NSString stringWithFormat:@"0%d",j];
                    }else{
                        numString = [NSString stringWithFormat:@"%d",j];
                    }
                    [numString drawInRect:numStringFram withAttributes:isPith?attributes_Pith:attributes_nomal];
                }
            }
            for (int i=1; i<_baseNumMaxValue+1; i++) {
                NSString * key = [NSString stringWithFormat:@"%d",i];
                // 记录最大连续出现次数
                NSString * maxAppearTime = maxLianxuDic[key];
                NSString * curAppearLianxuTime = numPitchLianxuDic[key];
                NSString * newMaxLianxu = [curAppearLianxuTime intValue] > [maxAppearTime intValue]?curAppearLianxuTime:maxAppearTime;
                maxLianxuDic[key] = newMaxLianxu;
                
                //记录最大遗漏次数
                NSString * maxYilouTime = maxYilouDic[key];
                NSString * curYilouTime = numPitchYilouDic[key];
                NSString * newMaxYilouTime = [curYilouTime intValue] > [maxYilouTime intValue] ?curYilouTime:maxYilouTime;
                maxYilouDic[key] = newMaxYilouTime;
                numPitchYilouDic[key] = @"0";
                
            }
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
            
            
            NSMutableDictionary * appearPositionDic = [NSMutableDictionary dictionary];
            [[numAppearTimeDic allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString * number = (NSString *)obj;
                NSString * times = numAppearTimeDic[number];
                float n = [times intValue] / (float)sourceCount;
                int position = n * 100;
                appearPositionDic[number] = [NSString stringWithFormat:@"%d",position];
            }];
            [self.delegate nowPingceResultWithAppearTime:numAppearTimeDic Lianxu:maxLianxuDic yilou:maxYilouDic appearPropertion:appearPositionDic];

        }
    
    
    
    
}

- (void)disableHighLight{
    highLightfram = CGRectZero;
    [self setNeedsDisplay];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (!CGRectEqualToRect(highLightfram, CGRectZero)) {
        highLightfram = CGRectZero;
        [self.delegate cellChoosed:-1];
        [self setNeedsDisplay];

    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float y = point.y;
    int n = y/cellH ;
    highLightfram = CGRectMake(0, n * cellH, CGRectGetWidth(self.frame), cellH);
    [self setNeedsDisplay];
    [self.delegate cellChoosed:n];
}

@end
