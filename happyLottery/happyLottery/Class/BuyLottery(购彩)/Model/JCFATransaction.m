//
//  JCFATransaction.m
//  Lottery
//
//  Created by onlymac on 2017/11/1.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "JCFATransaction.h"

@implementation JCFATransaction
-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    
    submitParaDic[@"channelCode"] = CHANNEL_CODE;
    submitParaDic[@"schemeType"] = @(self.schemeType);
    submitParaDic[@"secretType"] =@(self.secretType);
    submitParaDic[@"costType"] = @(self.costType);
    
    submitParaDic[@"cardCode"] =[[[GlobalInstance instance] curUser] cardCode];
    submitParaDic[@"maxPrize"]  = @(self.maxPrize);
    submitParaDic[@"lottery"] =@(9);
    
    submitParaDic[@"issueNumber"] = @"2018";
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%ld",(long)self.betCount];
    
    submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"betSource"] = self.betSource;
    
    submitParaDic[@"copies"] = @"1";
    submitParaDic[@"sponsorCopies"] = @"1";
    submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"schemeSource"] = @(self.schemeSource);
    return submitParaDic;
}

- (id)lottDataScheme{
    NSMutableArray *passTypes = [NSMutableArray arrayWithCapacity:0];
    NSString * chuanFaString;
        chuanFaString = @"P2_1";
    [passTypes addObject:chuanFaString];

    NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];

  
    
   
    for (jcBetContent  *model in self.yuceScheme.jcBetContent) {
         NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
          NSMutableArray * betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        for (YCbetPlayTypes *model1 in model.betPlayTypes) {
            mDic[@"playType"] = model1.playType;
            mDic[@"options"] = model1.options;
        }
        
        [betPlayTypes addObject:mDic];
        NSDictionary *dicMatches = @{@"dan":@NO,
                                     @"matchId": model.matchId,
                                     @"clash":model.clash,
                                     @"matchKey":model.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
        [betMatches addObject:dicMatches];
    }
    NSDictionary *betContent  = @[@{
                                  @"betMatches":betMatches,
                                  @"passTypes":passTypes,
                                  @"multiple":@(self.beiTou)
                                  }];
    return betContent;

}
@end
