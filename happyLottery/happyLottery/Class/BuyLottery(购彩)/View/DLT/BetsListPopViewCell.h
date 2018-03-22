//
//  BetsListPopViewCell.h
//  Lottery
//
//  Created by AMP on 5/28/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryBet.h"

@protocol BetsListPopViewCellDelegate;
@interface BetsListPopViewCell : UITableViewCell {
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<BetsListPopViewCellDelegate> delegate;
@property (nonatomic, strong)UILabel *downLine;
+ (CGFloat) cellHeight: (LotteryBet *) bet withFrame: (CGRect) frame;
- (void) updateWithBet: (LotteryBet *) bet;
@end

@protocol BetsListPopViewCellDelegate <NSObject>
@optional
- (void) removeBetAction: (NSIndexPath *) indexPath;

@end
