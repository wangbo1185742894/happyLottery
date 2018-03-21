//
//  BetCalculationManage.h
//  Lottery
//
//  Created by Yang on 15/7/3.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotteryNumber.h"
#import "LotteryXHSection.h"
#import "LotteryXHProfile.h"

@interface BetCalculationManage : NSObject{

    NSInteger betCount;
    NSInteger betCost;
}


@property (nonatomic , strong) NSMutableDictionary * betNumbers;


- (NSDictionary *)betCountAndCostCalculationWithLotteryDetail:(NSArray *)lotteryDetails withXHProfile:(LotteryXHProfile *)xhProfile;


//- (int)dltBetNumWithBallNum:(NSString *)numString withType:(NSString *)lotteryType playType:(int)playType;
//- (int)x115BetNumWithBallNum:(NSString *)numString witPlayType:(NSString *)playType;
@end
