//
//  GYJTransaction.h
//  Lottery
//
//  Created by 王博 on 2018/3/13.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "BaseTransaction.h"
#import "WordCupHomeItem.h"

typedef enum : NSUInteger {
    LotteryGYJ =11,
    LotteryGJ,
} LotteryZC;
@interface GYJTransaction : BaseTransaction

@property (nonatomic,assign)LotteryZC playType;
@property  (nonatomic,assign)   NSInteger beiCount;
@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> *selectArray;

@end
