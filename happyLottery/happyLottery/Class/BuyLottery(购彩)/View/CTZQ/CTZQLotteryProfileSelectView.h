//
//  LotteryProfileSelectView.h
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBaseView.h"
#import "Lottery.h"
#import "LotteryXHProfile.h"
#import "CTZQLotteryProfileSelectView.h"
#import "LotteryProfileSelectCellView.h"

@protocol CTZQLotteryProfileSelectViewDelegate <LotteryBaseViewDelegate>
@optional
- (void) userDidSelectLotteryProfile;
- (void) userCancelLottertProfileSelection;
@end

@interface CTZQLotteryProfileSelectView : LotteryBaseView <LotteryProfileSelectCellViewDelegate> {
    UIScrollView *scrollViewContent_;
    Lottery *curLottery;
    LotteryProfileSelectCellView *selectedCellView;
}

@property (nonatomic, assign)BOOL ISJCDAN;
@property (nonatomic, assign)BOOL isP3P5;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, weak) id<CTZQLotteryProfileSelectViewDelegate> delegate;
@property BOOL meShown;

- (void) initUIWithLottery: (Lottery *) lottery resource:(NSString *)vcResourceName;
- (void) showMe;
- (void) hideMe;
@end
