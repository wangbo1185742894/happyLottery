//
//  CTZQWinHistoryViewController.h
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"

@interface CTZQWinHistoryViewController : BaseViewController
@property (nonatomic , strong) Lottery * lottery;

//lc
@property (nonatomic , assign) BOOL isFromOpenLottery;

@end
