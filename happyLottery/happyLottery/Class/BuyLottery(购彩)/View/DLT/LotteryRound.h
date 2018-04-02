//
//  LotteryRound.h
//  Lottery
//
//  Created by YanYan on 6/11/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryRound : BaseModel

/*
 {
     addbonusmoney = "";
     allowPayment = 1;
     bonusCode = "";
     closeMinute = "-10";
     gameName = DLT;
     gameStatus = 1;
     number = 15065;
     startTime = "2015-06-10 20:30:30";
     status = 1;
     stopTime = "2015-06-13 20:30:30";
 }
 */

@property (nonatomic) NSUInteger abortDay;
@property (nonatomic) NSUInteger abortHour;
@property (nonatomic) NSUInteger abortMinute;
@property (nonatomic) NSUInteger abortSecond;


@property (nonatomic, strong) NSString *allowPayment;
@property (nonatomic, strong) NSString *gameStatus;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *lotteryCode;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *stopTime;
@property (nonatomic, strong) NSString *serverTime;
//@property (nonatomic, strong) NSString *status;
//@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *sellStatus;
@property (nonatomic, strong) NSString *issueNumber;
@property (nonatomic, strong) NSString *mainRes;
@property (nonatomic, strong) NSString *subRes;
@property (nonatomic, strong) NSString *closeMinute;
@property (nonatomic, strong) NSString *closeSecond;

- (BOOL)isExpire;
-(void)changeServerTime;
-(NSString *)getTimeStr;


@end
