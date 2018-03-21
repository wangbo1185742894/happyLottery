//
//  LotteryPhaseInfoView.h
//  Lottery
//
//  Created by AMP on 5/25/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBaseView.h"
#import "Lottery.h"
#import "LotteryManager.h"
#import "LotteryTimeCountdownView.h"

@protocol LotteryPhaseInfoViewDelegate <LotteryBaseViewDelegate>

-(void)getLotteryRoundFinish;

@end

@interface LotteryPhaseInfoView : LotteryBaseView <LotteryBaseViewDelegate, LotteryManagerDelegate> {
    
    LotteryManager *lotteryMan;
//    LotteryTimeCountdownView * timeCountdownView;
    
}
@property (nonatomic , strong) LotteryTimeCountdownView* timeCountdownView;
@property (nonatomic , weak) id<LotteryPhaseInfoViewDelegate>delegate;

- (void) drawWithLottery: (Lottery *) lottery;
- (void) drawWithLotterypl: (Lottery *) lotteryTMP;
- (NSString *)timeSting;
- (void) showCurRoundInfo;

@end
