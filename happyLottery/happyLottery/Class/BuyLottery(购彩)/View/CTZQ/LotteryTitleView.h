//
//  LotteryTitleView.h
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBaseView.h"
#import "Lottery.h"

@protocol LotteryTitleViewDelegate <LotteryBaseViewDelegate>
@optional
- (void) userDidClickTitleView;
@end

@interface LotteryTitleView : LotteryBaseView {
    UILabel *labelLotteryName;
    UILabel *labelLotteryProfileName;
    UIImageView *ivClickIndicator;
    UIButton *actionButton;
}

@property (nonatomic, weak) id<LotteryTitleViewDelegate> delegate;

- (void) updateWithLottery: (Lottery *) lottery;
- (void) shieldClickAction;
@end
