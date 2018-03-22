//
//  CTZQBet.h
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTZQMatch.h"
//一场比赛的选择情况；
@interface CTZQBet : NSObject
@property(nonatomic,strong)CTZQMatch*cMatch;// 该场比赛

-(id)initWith:(CTZQMatch *)match;
- (NSComparisonResult)compareBet:(CTZQBet *)bet ;
@end
