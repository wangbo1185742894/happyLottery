//
//  LotteryWinNumHistoryViewController.h
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lottery;
@interface LotteryWinNumHistoryViewController : BaseViewController

@property (nonatomic , strong) Lottery *lottery;

//lc
@property (nonatomic , assign) BOOL isFromOpenLottery;
- (void)showTrend:(UIButton *)sender;

@end
