//
//  LotteryWinHistoryCell.h
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"
#import "DltOpenResult.h"

@interface LotteryWinHistoryCell : UITableViewCell{

    UILabel * qihaoLable;
    UILabel * firSectionNumLb;
    UILabel * secSectionNumLb;
}


- (void)setUpWithLottery:(Lottery *)lottery cellHeight:(float)cellH withSizeRatio:(NSString *)ratio;
- (void)cellFillInfo:(DltOpenResult *)round;
//lc
- (void)lsetUpWithLottery:(Lottery *)lottery cellHeight:(float)cellH withSizeRatio:(NSString *)ratio;
- (void)lcellFillInfo:(DltOpenResult *)round;

@end
