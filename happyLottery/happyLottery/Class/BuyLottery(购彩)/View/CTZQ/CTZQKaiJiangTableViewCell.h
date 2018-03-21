//
//  CTZQKaiJiangTableViewCell.h
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"
#import "LotteryRound.h"

@interface CTZQKaiJiangTableViewCell : UITableViewCell

@property (nonatomic ,strong)Lottery * lottery;
@property (nonatomic ,strong)LotteryRound * curround;

- (void) updataInfo:(LotteryRound *)round;
- (void) setCellLottery: (Lottery *) lottery ;

@end
