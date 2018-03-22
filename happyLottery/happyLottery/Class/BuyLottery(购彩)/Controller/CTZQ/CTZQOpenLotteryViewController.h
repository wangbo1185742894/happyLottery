//
//  CTZQOpenLotteryViewController.h
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"
#import "Lottery.h"

@interface CTZQOpenLotteryViewController : BaseViewController

@property(strong,nonatomic)NSMutableArray *matchArray;
@property(strong,nonatomic)Lottery *lottery;
@property (strong, nonatomic)NSString *issueBegin;
@property (strong, nonatomic)NSString *issueSelected;
@property (nonatomic , assign) BOOL isFromOpenLottery;
@end
