//
//  GYJTransaction.m
//  Lottery
//
//  Created by 王博 on 2018/3/13.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "GYJTransaction.h"
#import "WordCupHomeItem.h"

@implementation GYJTransaction

-(id)init{
    if ([super init]) {
        self.selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] =[[[GlobalInstance instance] curUser] username];
    submitParaDic[@"lottery"] =self.lottery.identifier;
    submitParaDic[@"schemeType"] = self.schemeTypes[self.schemeType];
    submitParaDic[@"issueNumber"] = self.lottery.currentRound.issueNumber;
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%d",self.betCount];
    submitParaDic[@"multiple"] = [NSString stringWithFormat:@"%d",self.beiCount];
    submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%d",self.betCost];
    submitParaDic[@"SecretType"] =self.secretTypes[self.secretType];
    submitParaDic[@"schemeSource"] = self.schemeSource == nil ?@"BET":self.schemeSource;;
    submitParaDic[@"betSource"] = @"2";
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%d",self.betCost];
        submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%d",self.betCost];
    }else if(self.schemeType == SchemeTypeHemai){
        submitParaDic[@"copies"] = [NSString stringWithFormat:@"%zd",self.copies];
        submitParaDic[@"sponsorCopies"] = [NSString stringWithFormat:@"%zd",self.sponsorCopies];
        submitParaDic[@"commissionRate"] = [NSString stringWithFormat:@"%.2f",self.commissionRate];
        submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%.2f",self.minSubCost];
        submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%.2f",self.sponsorCost];
        submitParaDic[@"baodiCopies"] =[NSString stringWithFormat:@"%ld",(long)self.baodiCopies];
        submitParaDic[@"baodiCost"] = [NSString stringWithFormat:@"%.2f",self.baodiCopies *self.minSubCost];
    }

    return submitParaDic;
}

- (id)lottDataScheme{
    NSMutableArray *betContent = [NSMutableArray arrayWithCapacity:0];
  
    NSMutableArray *nums = [NSMutableArray arrayWithCapacity:0];
    for (WordCupHomeItem *item in self.selectArray) {
        [nums addObject:item.indexNumber];
    }
    
    [betContent addObject:@{@"groupIndex":[self.selectArray firstObject].groupIndex,@"number":nums}];
    return betContent;
}

@end
