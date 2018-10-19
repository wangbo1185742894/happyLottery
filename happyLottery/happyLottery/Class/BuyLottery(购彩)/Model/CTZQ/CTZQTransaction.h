//
//  CTZQTransaction.h
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTZQMatch.h"
#import "Lottery.h"
#import "BaseTransaction.h"

typedef enum {
    CTZQBetTypeSingle = 1<<0,//单式
    CTZQBetTypeDouble = 1<<1,//复式
    CTZQBetTypeDan = 1<<2  // 胆拖
}CTZQBetType;

@interface CTZQTransaction : BaseTransaction


@property CTZQPlayType ctzqPlayType;
@property (nonatomic , strong) NSString * curPlayCode;
@property (nonatomic , strong) NSMutableArray * cBetArray;
@property(nonatomic,strong)NSArray *allBet;
@property (nonatomic , strong) NSString * beitou;
@property(strong,nonatomic)NSString *isBackClean;//1 返回清空  0 返回不清空
@property CTZQBetType cBetType;
@property(nonatomic,strong)Lottery *lottery;
@property NSMutableString *TZNum;

@end
