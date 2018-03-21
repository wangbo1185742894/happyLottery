//
//  CTZQWinHistoryTableViewCell.h
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryRound.h"

@interface CTZQWinHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labMatchDate;


- (void)cellFillInfo:(LotteryRound *)round;
@end
