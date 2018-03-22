//
//  LotteryBetsPopView.h
//  Lottery
//
//  Created by AMP on 5/28/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBaseView.h"
#import "LotteryTransaction.h"
#import "BetsListPopViewCell.h"

@protocol LotteryBetsPopViewDelegate <LotteryBaseViewDelegate>
- (void) betTransactionUpdated;
- (void) betListPopViewHide;
- (void) touzhuSureAction;
@end

@interface LotteryBetsPopView : LotteryBaseView <UITableViewDataSource, UITableViewDelegate, BetsListPopViewCellDelegate>

@property (nonatomic, weak) id<LotteryBetsPopViewDelegate> delegate;

@property BOOL meShown;

- (void) initUI;
- (void) refreshBetListView: (LotteryTransaction *) transaction;
- (void) hideMe;
//清空列表
- (void) removeBetsAction: (NSArray*)indexPaths;
@end
