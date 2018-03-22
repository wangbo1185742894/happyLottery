//
//  OrderBetsListView.m
//  Lottery
//
//  Created by Yang on 15/6/24.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "OrderBetsListView.h"
#import "LotteryBetObj.h"

@interface OrderBetsListView()
@end

#define BetBaseCellH  30

@implementation OrderBetsListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)betListSpread{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.size.height = _betsLisHeight;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        if(finished){
            
        }
    }];
}
-(void)betListCowered{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        if(finished){
            self.alpha = 0;
        }
    }];
}


- (UILabel *)lable:(CGRect)fram textColor:(UIColor *)color text:(NSString *)text textAligment:(int)aligment{

    UILabel * lable = [[UILabel alloc] initWithFrame:fram];
    lable.textColor = color;
    lable.textAlignment = aligment;
    lable.numberOfLines  = 0;
    lable.text = text;
    lable.backgroundColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:13];
    return lable;
}
- (UIView *) forJingCaiBetItemView:(LotteryBetObj *)betObj cury:(float)y{
    UIView * subContent = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.frame.size.width-20, 0)];

        float curY = 0;
    for (int i =0; i<betObj.betCotent.count; i++) {
        NSDictionary * matchInfo = betObj.betCotent[i];
        UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, CGRectGetWidth(subContent.frame), 25)];
        titleView.backgroundColor = [UIColor grayColor];
        curY += titleView.frame.size.height;
        [subContent addSubview:titleView];
        float titleLbSpading = 0.5;
        float titleLbW = (CGRectGetWidth(titleView.frame)-4*titleLbSpading) / 3.0;
        float titleLbH = CGRectGetHeight(titleView.frame) - 2*titleLbSpading;
        [titleView addSubview:[self lable:CGRectMake(titleLbSpading, titleLbSpading, titleLbW, titleLbH) textColor:[UIColor redColor] text:[NSString stringWithFormat:@"第%d关",i+1] textAligment:NSTextAlignmentCenter]];
        [titleView addSubview:[self lable:CGRectMake(titleLbSpading*2+titleLbW, titleLbSpading, titleLbW, titleLbH) textColor:TEXTGRAYCOLOR text:matchInfo[@"lineId"] textAligment:NSTextAlignmentCenter]];
        /*matchid->lineId*/
        
        NSString * playType = [betObj playTypeNameWithCode:matchInfo[@"value"]];
        [titleView addSubview:[self lable:CGRectMake(titleLbSpading*3+titleLbW*2, titleLbSpading, titleLbW, titleLbH) textColor:TEXTGRAYCOLOR text:playType  textAligment:NSTextAlignmentCenter]];
        
        float ratio = CGRectGetWidth(subContent.frame) /3.0;
        [subContent addSubview:[self lable:CGRectMake(0, curY, ratio*2, 20) textColor:RGBCOLOR(98, 175, 46) text:matchInfo[@"clash"] textAligment:NSTextAlignmentLeft]];
        curY+= 20;
        
      NSString * betNumString = [betObj xiaBiaoChaiFen:matchInfo[@"value"] matchKey:matchInfo[@"matchKey"]];
        
        
        //竞彩结果
        NSString * resultString;
        float betNumLbW;
        if(betObj.lotteryNumDic && !(betObj.lotteryNumDic.count == 0)){
            resultString = [betObj lotteryResultString:matchInfo[@"matchKey"] playType:matchInfo[@"value"]];
        }
        if(resultString == nil)
        {
            betNumLbW = betObj.lotteryNumDic?CGRectGetWidth(subContent.frame):CGRectGetWidth(subContent.frame);
        }
        else
        {
            betNumLbW = betObj.lotteryNumDic?CGRectGetWidth(subContent.frame)*2/3.0:CGRectGetWidth(subContent.frame);
        }
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGRect rect_textLb = [betNumString boundingRectWithSize:CGSizeMake(betNumLbW+12, MAXFLOAT)
            options:NSStringDrawingUsesLineFragmentOrigin
         attributes:attributes
            context:nil];
        float titleH;
        if (rect_textLb.size.height > 20) {
            titleH = rect_textLb.size.height;
        }else{
            titleH = 20;
        }
        [subContent addSubview:[self lable:CGRectMake(0, curY, betNumLbW, titleH) textColor:TEXTGRAYCOLOR text:betNumString textAligment:NSTextAlignmentLeft]];
        
        //竞彩结果
        if(betObj.lotteryNumDic && !(betObj.lotteryNumDic.count == 0)){
            NSString * resultString = [betObj lotteryResultString:matchInfo[@"matchKey"] playType:matchInfo[@"value"]];
            if(resultString != nil)
            {
                [subContent addSubview:[self lable:CGRectMake(ratio*2+5, curY+(titleH-20)/2.0, ratio, 20) textColor:[UIColor redColor] text:[NSString stringWithFormat:@"比赛结果:%@",resultString] textAligment:NSTextAlignmentLeft]];
            }
        }

        curY += titleH;
    }
    
    CGRect fram = subContent.frame;
    fram.size.height = curY+5;
    subContent.frame = fram;
    
    return subContent;
}

- (UIView *)forDltOrX115BetItemView:(LotteryBetObj *)betObj cury:(float)y{

    UIView * subContent = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 0)];
    float lableH = BetBaseCellH;
//    if ([betObj.lotteryType isEqualToString:@"DLT"]) {
     if ([_lotteryType isEqualToString:@"DLT"]) {
//        NSArray * num_redArray = [betObj.number componentsSeparatedByString:@"#"];
         NSArray * num_redArray = [betObj.number componentsSeparatedByString:@"+"];
         if (num_redArray.count < 2) {
            return nil;
        }else{
            NSString * redString = [num_redArray[0] stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSString * blueString = [num_redArray[1] stringByReplacingOccurrencesOfString:@"," withString:@" "];
            
            if ([redString rangeOfString: @"#"].location != NSNotFound) {
                ;
                redString = [@"[胆:" stringByAppendingString:redString];
                redString = [redString stringByReplacingOccurrencesOfString:@"#" withString:@"]\n"];
            }
            if ([blueString rangeOfString: @"#"].location != NSNotFound) {
                ;
                blueString = [@"[胆:" stringByAppendingString:blueString];
                blueString = [blueString stringByReplacingOccurrencesOfString:@"#" withString:@"]\n"];
            }

            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            
            float lableW = self.frame.size.width-165;
            CGRect rect_red = [redString boundingRectWithSize:CGSizeMake(lableW, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
            CGRect rect_blue = [blueString boundingRectWithSize:CGSizeMake(75, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
            float height = rect_red.size.height > rect_blue.size.height?rect_red.size.height :rect_blue.size.height;
            if (lableH < height) {
                lableH = height+20;
            }
            [subContent addSubview:[self lable:CGRectMake(110, 0, self.frame.size.width - 110 - 85, lableH) textColor:[UIColor redColor] text:redString textAligment:NSTextAlignmentLeft]];

            [subContent addSubview:[self lable:CGRectMake(self.frame.size.width - 80, 0, 75, lableH) textColor:[UIColor blueColor] text:blueString textAligment:NSTextAlignmentLeft]];
        }
    }else{
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGRect rect = [betObj.number boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame)-80, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        if (rect.size.height > lableH) {
            lableH = rect.size.height ;
            [subContent addSubview:[self lable:CGRectMake(110, 0, self.frame.size.width-105, lableH) textColor:[UIColor redColor] text:[betObj.number stringByReplacingOccurrencesOfString:@"," withString:@" "] textAligment:NSTextAlignmentLeft]];
        }
        else
        {
            lableH -= 10;
             [subContent addSubview:[self lable:CGRectMake(110, 0, self.frame.size.width-105, lableH) textColor:[UIColor redColor] text:[betObj.number stringByReplacingOccurrencesOfString:@"," withString:@" "] textAligment:NSTextAlignmentLeft]];
        }
        
    }
    NSString * playName ;
    if (betObj && [betObj.addtional intValue]==1) {
        playName = [NSString stringWithFormat:@"%@(追加)",betObj.playTypeName];
    }else{
        playName = betObj.playTypeName;
    }
    
    UILabel * playNameLb =[self lable:CGRectMake(5, 0, 103, lableH) textColor:RGBCOLOR(153, 102, 51) text:playName textAligment:NSTextAlignmentLeft];
    [subContent addSubview:playNameLb];
    
    CGRect fram = subContent.frame;
    fram.size.height = lableH;
    subContent.frame = fram;
   
    return subContent;
}

- (void)fillContentView:(NSArray *)betArray{
    self.clipsToBounds = YES;
    float cur_y = 5;

    for (LotteryBetObj * betObj in betArray){
        UIView * item ;
        if ([_lotteryType isEqualToString:@"DLT"] || [_lotteryType isEqualToString:@"X115"]) {
            item = [self forDltOrX115BetItemView:betObj cury:cur_y];
        }else if ([_lotteryType isEqualToString:@"JCZQ"]){
           item = [self forJingCaiBetItemView:betObj cury:cur_y];
        }
        [self addSubview:item];
        cur_y += item.frame.size.height;
    }
    
    CGRect frame = self.frame;
    frame.size.height = cur_y;
    self.frame = frame;
    
    _betsLisHeight = cur_y;
}





@end