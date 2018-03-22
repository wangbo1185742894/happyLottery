//
//  LotteryTimeCountdownView.h
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryRound.h"

typedef enum {
    TimeCutTypePlayPage,
    TimeCutTypeExtrendPage,
}TimeCutType;
@class LotteryTimeCountdownView;
@protocol LotteryTimeCountdownViewDelegate <NSObject>
- (void)timeCountDownView:(LotteryTimeCountdownView*)timeView didFinishTimeStr:(NSString *)timeStr;
@end

@interface LotteryTimeCountdownView : UIView{

    UILabel * timeLb;
    NSUInteger hour;
    NSUInteger minute;
    NSUInteger second;
    NSTimer * updataTimer;
    
    UIImageView * imageFlag;
}

@property (nonatomic , strong) LotteryRound * curRound;
@property (nonatomic) TimeCutType timeCutType;
@property (nonatomic , strong) NSString * timeString;
@property (nonatomic, weak)id<LotteryTimeCountdownViewDelegate> delegate;
@property (assign ,nonatomic)BOOL isP3P5;
- (NSString *)getTimeString;
- (NSTimer *)updataTimer;
- (void)startTimeCountdown:(LotteryRound *)round;

@end


