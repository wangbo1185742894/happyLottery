//
//  LotteryWinHistoryHeadView.h
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"

@interface LotteryWinHistoryHeadView : UIView

//lc
- (void) lsetUpWithLottey:(Lottery *)lottery withViewRatio:(NSString *)ratio;

- (void) setUpWithLottey:(Lottery *)lottery withViewRatio:(NSString *)ratio;

@end
