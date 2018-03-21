//
//  Lottery.m
//  Lottery
//
//  Created by AMP on 5/15/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "Lottery.h"
#import "LotteryXHSection.h"
@implementation Lottery

- (NSString *) textForTanTuoDesc {
    int danHaoCount = 0;
    for (LotteryXHSection *section in self.activeProfile.details) {
        danHaoCount += [section.danHaoCount intValue];
    }
    NSString *danHaoDesc = [NSString stringWithFormat: TextDanHaoDesc, danHaoCount];
    return danHaoDesc;
}
@end
