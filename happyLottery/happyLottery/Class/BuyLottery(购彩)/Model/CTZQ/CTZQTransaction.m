//
//  CTZQTransaction.m
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQTransaction.h"
#import "CTZQBet.h"

@implementation CTZQTransaction
- (instancetype)init{
    if (self = [super init]) {
        _beitou = @"1";
    }
    return self;
}



-(NSMutableDictionary*)submitParaDicScheme{
    
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] =[GlobalInstance instance].curUser.cardCode;
    if (self.ctzqPlayType == CTZQPlayTypeRenjiu) {
        submitParaDic[@"lottery"] = @(6);
    }else if(self.ctzqPlayType == CTZQPlayTypeShiSi){
        submitParaDic[@"lottery"] = @(5);
    }
    
    submitParaDic[@"schemeType"] = @(self.schemeType);
    submitParaDic[@"issueNumber"] = self.lottery.currentRound.issueNumber;
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%d",self.betCount];
    submitParaDic[@"multiple"] =self.beitou;
    NSString *betcost;
    if (self.costType == CostTypeCASH) {
        betcost  =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    }else if (self.costType == CostTypeSCORE){
        betcost =[NSString stringWithFormat:@"%ld",(long)self.betCost * 100];
    }
    submitParaDic[@"betCost"] =betcost;
    submitParaDic[@"betSource"] = @"2";
    
    submitParaDic[@"channelCode"] = CHANNEL_CODE;
    submitParaDic[@"costType"] = @(self.costType);
      submitParaDic[@"SecretType"] =@(self.secretType);
    submitParaDic[@"schemeSource"] = @(self.schemeSource);;
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        submitParaDic[@"minSubCost"] =betcost;
        submitParaDic[@"sponsorCost"] = betcost;
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

/*\"betMatches\": [
{
    \"dan\": true,
    \"matchId\": 1,
    \"options\": [
    \"3\",
    \"1\",
    \"0\"
    ]
},*/
- (id)lottDataScheme{
    NSMutableArray * betMatches = [NSMutableArray arrayWithCapacity:0];
    for (CTZQBet *bet  in self.cBetArray) {
        CTZQMatch *match = bet.cMatch;
        NSMutableArray *selectPlay = [NSMutableArray arrayWithCapacity:0];
        if ([match.selectedS isEqualToString:@"1"]) {
            [selectPlay addObject:@"3"];
        }
        if ([match.selectedP isEqualToString:@"1"]) {
            [selectPlay addObject:@"1"];
        }
        if ([match.selectedF isEqualToString:@"1"]) {
            [selectPlay addObject:@"0"];
        }
        NSDictionary *tempDic = @{@"dan":[match.danTuo isEqualToString:@"1"]?@YES:@NO,
                                  @"matchId":match.id_,
                                  @"options":selectPlay
                                  };
        [betMatches addObject:tempDic];
    }
    return  @[@{@"betMatches":betMatches,@"multiple":self.beitou}];
}
@end
