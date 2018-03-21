 //
//  LotteryTimeCountdownView.m
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryTimeCountdownView.h"

@implementation LotteryTimeCountdownView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(UILabel *)lb:(CGRect)fram text:(NSString *)text{
    UILabel * lable = [[UILabel alloc] initWithFrame:fram];
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = text;
    lable.textColor = TEXTGRAYCOLOR;

    return lable;
}

-(UILabel *)lbpl:(CGRect)fram text:(NSString *)text{
    UILabel * lable = [[UILabel alloc] initWithFrame:fram];
    lable.font = [UIFont systemFontOfSize:11];
    lable.text = text;
    lable.textColor = [UIColor whiteColor];
    
    return lable;
}

- (NSString *)getTimeString{ 
    NSString * timeString = [NSString stringWithFormat:@"%d,%d,%d",(int)hour,(int)minute,(int)second];
    return timeString;
}

- (void) addSubView{
    if (_timeCutType ==TimeCutTypePlayPage && self.isP3P5 ==NO) {
//        float timeLb_w = 100;
//        timeLb = [self lb:CGRectMake(self.frame.size.width-timeLb_w - 8, 0, timeLb_w, self.frame.size.height) text:nil];
//        timeLb.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:timeLb];
//        timeLb.minimumScaleFactor = 9;
//        UILabel * titleLb =[self lb:CGRectMake(timeLb.frame.origin.x - 60, 0, 60, self.frame.size.height) text:TextTimeCountDownTitle];
//        [self addSubview:titleLb];
//        UIImageView * imgVflag = [[UIImageView alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x -20, self.frame.size.height/4, 20, self.frame.size.height/2)];
//        imgVflag.image = [UIImage imageNamed:@"clock.png"];
//        [self addSubview:imgVflag];
        // 排列3排列5的时间栏
        timeLb = [self lbpl:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) text:nil];
        timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLb];
        
    }else if (self.isP3P5){
        // 排列3排列5的时间栏
        timeLb = [self lbpl:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) text:nil];
        timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLb];
        
    }else if(_timeCutType ==TimeCutTypeExtrendPage){
        timeLb = [self lb:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) text:nil];
        timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLb];
        timeLb.minimumScaleFactor = 9;
        imageFlag = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-95, 5, 20, 20)];
        imageFlag.image = [UIImage imageNamed:@"clock.png"];
        [self addSubview:imageFlag];
    }
}
- (NSTimer *)updataTimer{
    if (!updataTimer) {
        return nil;
    }
    return updataTimer;
}
- (void)startTimeCountdown:(LotteryRound *)round{
    self.curRound = round;
    if (!round) {
        [self showTime];
        return;
    }
    if (_timeCutType ==TimeCutTypeExtrendPage) {
        if (_timeString) {
            NSArray * timeArray = [_timeString componentsSeparatedByString:@","];
            hour = [timeArray[0] intValue];
            minute = [timeArray[1] intValue];
            second = [timeArray[2] intValue];
            [self showTime];
//            if (!updataTimer) {
            [updataTimer invalidate];
                updataTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataTimeAppear) userInfo:nil repeats:YES];
//            }
            
        }else{
            hour = 0;
            minute = 0;
            second = 0;
            [self showTime];
        }
    }else{
        if (round.abortDay > 0 || round.abortHour > 0 || round.abortMinute > 0 || round.abortSecond > 0) {
            hour = round.abortDay * 24 + round.abortHour;
            minute = round.abortMinute;
            second = round.abortSecond;
            [self showTime];
            [updataTimer invalidate];
            updataTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataTimeAppear) userInfo:nil repeats:YES];
        }else if (round.abortDay == 0 && round.abortHour == 0 && round.abortMinute == 0 && round.abortSecond == 0){
            if ([self.delegate respondsToSelector:@selector(timeCountDownView:didFinishTimeStr:)]) {
//                NSAttributedString *a = [[NSAttributedString alloc]initWithString:@"该期已停止销售"];
                [self.delegate timeCountDownView:self didFinishTimeStr:@"该期已停止销售"];
            }
        }
    }
}

- (void)updataTimeAppear{
    NSLog(@"10981 : timer 活着");
    if (second != 0) {
        second -- ;
    }else{
        if (minute != 0) {
            minute -- ;
            second = 59;
        }else{
            if (hour != 0) {
                hour --;
                minute = 59;
                second = 59;
            }else{
                [updataTimer invalidate];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RoundTimeDownFinish" object:nil];
            }
        }
    }
    [self showTime];
}

- (void) showTime {
    if (timeLb == nil) {
        [self addSubView];
    }
    if (!_curRound) {
        if (_timeCutType ==TimeCutTypeExtrendPage) {
            timeLb.text = @"距期号:未获得本次期号 00期00时00分00秒";
        }else if (self.isP3P5){
            timeLb.text = @"00时00分00秒";
        }else{
            timeLb.text = @"00时00分00秒";
        }
    }else{
        
//        if (self.isP3P5) {
            NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] init];
            
            NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
            textAttrsDictionary[NSForegroundColorAttributeName] = [UIColor whiteColor];
            
            NSMutableDictionary *numberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
            numberAttrsDictionary[NSForegroundColorAttributeName] = TextTimeColor;
        
        
        
            if (_timeCutType == TimeCutTypePlayPage) {
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: [self getTimeString:hour] attributes: numberAttrsDictionary]];
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"时" attributes: textAttrsDictionary]];
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: [self getTimeString:minute] attributes: numberAttrsDictionary]];
                
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"分" attributes: textAttrsDictionary]];
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: [self getTimeString:second] attributes: numberAttrsDictionary]];
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"秒" attributes: textAttrsDictionary]];
            }else{
                NSMutableDictionary *timeAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
                timeAttrsDictionary[NSForegroundColorAttributeName] = TextTimeColor;
                
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"第%@期",_curRound.issueNumber]  attributes:timeAttrsDictionary]];
                
                NSString * timeStr = [NSString stringWithFormat:@"%@时%@分%@秒",[self getTimeString:hour],[self getTimeString:minute],[self getTimeString:second]];
                [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: timeStr attributes: numberAttrsDictionary]];
                
            }
        
            timeLb.attributedText = timeString;
    }
    
    if (_timeCutType ==TimeCutTypeExtrendPage) {
        NSString * textString;
        if (!_curRound) {
            textString = @"距期号:未获得本次期号 00期00时00分00秒";
        }else{
            textString =  [NSString stringWithFormat:@"距期号:%@ %@时%@分%@秒",_curRound.issueNumber,[self getTimeString:hour],[self getTimeString:minute],[self getTimeString:minute]];
        }

        NSDictionary *attributes = @{NSFontAttributeName:timeLb.font};
        CGRect rect_textLb = [textString boundingRectWithSize:CGSizeMake(MAXFLOAT, timeLb.frame.size.height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
        float flagImgX = (self.frame.size.width - rect_textLb.size.width)/2.0-20;
        CGRect frame = imageFlag.frame;
        frame.origin.x = flagImgX;
        imageFlag.frame = frame;
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(timeCountDownView:didFinishTimeStr:)]) {
        [self.delegate timeCountDownView:self didFinishTimeStr:timeLb.attributedText.string];
    }

}

-(NSString *) getTimeString:(NSUInteger)time
{
    NSString * timeStr = time>9?[NSString stringWithFormat:@"%d",(int)time]:[NSString stringWithFormat:@"0%d",(int)time];
    return timeStr;
}

@end
