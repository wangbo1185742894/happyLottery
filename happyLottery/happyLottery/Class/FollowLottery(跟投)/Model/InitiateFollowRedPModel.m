//
//  InitiateFollowRedPModel.m
//  happyLottery
//
//  Created by LYJ on 2018/9/13.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "InitiateFollowRedPModel.h"

@implementation InitiateFollowRedPModel


-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] = self.cardCode;
    submitParaDic[@"schemeNo"] = self.schemeNo;
    submitParaDic[@"amount"] = self.amount;
    submitParaDic[@"univalent"] =self.univalent;
    submitParaDic[@"totalCount"] = self.totalCount;
    submitParaDic[@"randomType"] = @(self.randomType);
    return submitParaDic;
}

@end
