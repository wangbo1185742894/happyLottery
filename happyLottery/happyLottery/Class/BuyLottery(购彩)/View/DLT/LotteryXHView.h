//
//  LotteryXuanHaoView.h
//  Lottery
//
//  Created by AMP on 5/21/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBaseView.h"
#import "Lottery.h"
#import "XHNumberView.h"
#import "LotteryBet.h"
#import "XHSectionRandomView.h"
#import "NumberSelectView.h"

typedef enum {
    //显示机选结果
    RandomBetStatusShow,
    //直接添加机选结果
    RandomBetStatusAdd
} RandomBetStatus;

@protocol LotteryXHViewDelegate <LotteryBaseViewDelegate>
- (void) betInfoUpdated;
- (void) addedNewRandomBet;
- (BOOL) isExceedAmountLimit;


@end

@interface LotteryXHView : LotteryBaseView <XHNumberViewDelegae, XHSectionRandomViewDelegate>
@property (nonatomic)BOOL isEableSelect; //  当金额超过2w时不可选择
@property (nonatomic, strong) LotteryBet *lotteryBet;
@property (nonatomic, weak) id<LotteryXHViewDelegate> delegate;
@property RandomBetStatus randomStatus;
@property (nonatomic, strong) NumberSelectView *numberSelectView;

- (void) drawWithLottery: (Lottery *) lottery;
- (NSArray *) selectedNumbers;
- (void) clearAllSelection;
- (void) addRandomBet;
-(void)rebuyShowNum:(NSArray *)selectArray;
-(void)rebuyDLTnum:(NSArray *)seletArray;

@end
