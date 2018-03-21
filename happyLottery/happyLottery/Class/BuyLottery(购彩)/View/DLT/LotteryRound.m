//
//  LotteryRound.m
//  Lottery
//
//  Created by YanYan on 6/11/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryRound.h"
#import "Utility.h"

@implementation LotteryRound

- (BOOL)isExpire{
//    self.stopTime = @"2018-01-01 00:00:00";
    if (!self.stopTime) {
        return YES;
    }
    NSTimeInterval  interval = [[GlobalInstance instance] serverTime];
    NSDate * serverDate = [Utility dateFromTI:interval+abs([_closeSecond intValue])];

//  处理服务器端返回self.stopTime，self.startTime多两位“.0”问题
    NSString* timestr = [NSString stringWithFormat:@"%@",self.stopTime];
    NSInteger length = [timestr length];
    NSString *str = [timestr substringFromIndex:length-2];
    if([str isEqualToString:@".0"])
    {
        timestr = [timestr substringToIndex:length-2];
    }
    NSDate * stopDate = [Utility dateFromDateStr:timestr withFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * stopDate = [Utility dateFromDateStr:self.stopTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSComparisonResult result = [stopDate compare:serverDate];
    NSLog(@"stop:[%@] server[%@] [[%@]]",stopDate,serverDate,@(result));
    if (result == NSOrderedDescending) {
        [self roudnAbortTime];
        return NO;
    }else{
        return YES;
    }
}

- (void)setServerTime:(NSString *)serverTime{
    NSInteger length = [serverTime length];
    NSString *str = [serverTime substringFromIndex:length-2];
    if([str isEqualToString:@".0"])
    {
        serverTime = [serverTime substringToIndex:length-2];
    }
    _serverTime = serverTime;
    NSDate * date = [Utility dateFromDateStr:serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval = [Utility timeintervalForDate:date];
    [GlobalInstance instance].serverTime = timeInterval;
    
//    [self changeServerTime];
}

-(void)changeServerTime{

    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDate * date = [Utility dateFromDateStr:_serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nextDay = [NSDate dateWithTimeInterval:1 sinceDate:date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString * date1  = [dateFormatter stringFromDate:nextDay];
        _serverTime = date1;
        NSLog(@"%@",date);
    }];
}

-(NSString *)getTimeStr{
    if ([self.sellStatus isEqualToString:@"WILL_SELL"]) {
        return @"待销售";
    }else if ([self.sellStatus isEqualToString:@"ING_SELL"]){
        if(![self isExpire]){
            NSInteger hour = self.abortDay * 24 + self.abortHour;
            return [NSString stringWithFormat:@"   剩余时间：%ld:%02ld:%02ld",hour,self.abortMinute,self.abortSecond];
        }else{
            return @"待销售";
        }
    }
    return @"待销售";
}

- (void)roudnAbortTime{

     NSDate * date = [Utility dateFromDateStr:_serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval  interval = [Utility timeintervalForDate:date];
    
  
    NSInteger length = [_stopTime length];
    NSString *str = [_stopTime substringFromIndex:length-2];
    if([str isEqualToString:@".0"])
    {
        _stopTime = [_stopTime substringToIndex:length-2];
    }

    NSTimeInterval  stop_interval = [Utility timeintervalForDate:[Utility dateFromDateStr:_stopTime withFormat:@"yyyy-MM-dd HH:mm:ss"]];
    if(interval > (stop_interval - abs([_closeSecond intValue]))){
        self.abortDay = 0;
        self.abortHour = 0;
        self.abortMinute =0;
        self.abortSecond =0;
        return;
    }
    NSDate * serverDate = [Utility dateFromTI:(interval + abs([_closeSecond intValue]))];
    NSDate * stopDate = [Utility dateFromDateStr:self.stopTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    unsigned int unitFlags = kCFCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour | kCFCalendarUnitSecond;
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    sysCalendar.timeZone = timeZone;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:serverDate  toDate:stopDate  options:0];
    
    self.abortDay = [breakdownInfo day]>0?[breakdownInfo day]:0;
    self.abortHour = [breakdownInfo hour]>0?[breakdownInfo hour]:0;
    self.abortMinute = [breakdownInfo minute]>0?[breakdownInfo minute]:0;
    self.abortSecond = [breakdownInfo second]>0?[breakdownInfo second]:0;
}

@end
