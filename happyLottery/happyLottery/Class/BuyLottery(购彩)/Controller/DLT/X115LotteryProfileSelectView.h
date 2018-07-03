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
#import "LotteryProfileSelectCellView.h"

@protocol X115LotteryProfileSelectViewDelegate <LotteryBaseViewDelegate>
@optional
- (void) userDidSelectLotteryProfile;
- (void) userCancelLottertProfileSelection;
@end

@interface X115LotteryProfileSelectView : LotteryBaseView <X115LotteryProfileSelectViewDelegate> {
    UIScrollView *scrollViewContent_;
    Lottery *curLottery;
    LotteryProfileSelectCellView *selectedCellView;
}
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, weak) id<X115LotteryProfileSelectViewDelegate> delegate;
@property BOOL meShown;

- (void) initUIWithLottery: (Lottery *) lottery resource:(NSString *)vcResourceName;
- (void) showMe;
- (void) hideMe;
@end
