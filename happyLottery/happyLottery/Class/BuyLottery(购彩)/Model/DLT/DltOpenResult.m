//
//  DltOpenResult.m
//  happyLottery
//
//  Created by 王博 on 2018/3/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "DltOpenResult.h"

@implementation DltOpenResult

-(LotteryRound *)transport{
    LotteryRound *round = [[LotteryRound alloc]init];
    round.startTime = self.startTime;
    round.stopTime = self.stopTime;
    round.mainRes = [[[self.openResult componentsSeparatedByString:@"#"] firstObject] stringByReplacingOccurrencesOfString:@"," withString:@" "];
    round.subRes = [[[self.openResult componentsSeparatedByString:@"#"] lastObject] stringByReplacingOccurrencesOfString:@"," withString:@" "];
    round.issueNumber = self.issueNumber;
    return round;
}

@end
