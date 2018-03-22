//
//  LotteryExtrendViewController.h
//  Lottery
//
//  Created by Yang on 7/1/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Lottery.h"

@interface LotteryExtrendViewController : BaseViewController

@property (nonatomic , strong) Lottery * lottery;

@property (nonatomic , strong) NSString * timeString;

@end
