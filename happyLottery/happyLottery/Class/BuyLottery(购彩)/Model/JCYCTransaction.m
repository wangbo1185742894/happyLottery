//
//  JCYCTransaction.m
//  Lottery
//
//  Created by 王博 on 2017/10/19.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "JCYCTransaction.h"

@implementation JCYCTransaction

-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] =[[[GlobalInstance instance] curUser] cardCode];
    
    submitParaDic[@"channelCode"] = @"TBZ";
    submitParaDic[@"costType"] = @(self.costType);
    
    submitParaDic[@"maxPrize"]  = @(100);
    submitParaDic[@"lottery"] =@(9);
    submitParaDic[@"schemeType"] =@(self.schemeType);
    submitParaDic[@"issueNumber"] = @"2018";
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%ld",(long)self.betCount];
    submitParaDic[@"multiple"] =@(self.beiTou);
    submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"betSource"] = self.betSource;
    submitParaDic[@"SecretType"] = @(self.secretType);
    submitParaDic[@"copies"] = @"1";
    submitParaDic[@"sponsorCopies"] = @"1";
    submitParaDic[@"minSubCost"] =[NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"sponsorCost"] = [NSString stringWithFormat:@"%ld",(long)self.betCost];
    submitParaDic[@"schemeSource"] =@(self.schemeSource);
    return submitParaDic;
}


- (id)lottDataScheme{
    NSMutableArray *passTypes = [NSMutableArray arrayWithCapacity:0];
    NSString * chuanFaString;
    if ([self.shortCutModel.spfSingle boolValue] == YES || self.shortCutModel.jcPairingMatchDto == nil) {
            chuanFaString = @"P1";
    }else{
           
            chuanFaString = @"P2_1";
    }
    [passTypes addObject:chuanFaString];
    
    
    NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];

    NSMutableArray * betPlayTypes = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * options = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (JcForecastOptions * ops in self.shortCutModel.forecastOptions) {
        
        
        if ([ops.forecast boolValue] == YES)  {
            mDic[@"playType"] = @"1";
            [options addObject:ops.options];
            mDic[@"options"] = options;
            
        }
       
    }
    
    NSString *clash = [NSString stringWithFormat:@"%@VS%@",self.shortCutModel.homeName,self.shortCutModel.guestName];
        

    [betPlayTypes addObject:mDic];
    NSDictionary *dicMatches = @{@"dan":@NO,
                                     @"matchId": self.shortCutModel.lineId,
                                     @"clash":clash,
                                     @"matchKey":self.shortCutModel.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
    [betMatches addObject:dicMatches];
    
    if (self.shortCutModel.jcPairingMatchDto != nil) {
        
        
        
        NSMutableArray * betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        
        NSDictionary *dicMatche1;
        for (JcPairingOptions * ops in self.shortCutModel.jcPairingMatchDto.options) {
            
            NSMutableArray *option1 = [[NSMutableArray alloc]init];
            NSMutableArray *option2 = [[NSMutableArray alloc]init];
            NSMutableArray *option3 = [[NSMutableArray alloc]init];
            NSMutableArray *option4 = [[NSMutableArray alloc]init];
            NSMutableArray *option5 = [[NSMutableArray alloc]init];
      

                
                switch ([ops.playType integerValue]) {
                    case 1:
                        [option1 addObject:ops.options];
                        
                        break;
                    case 2:
                        [option2 addObject:ops.options];
                        break;
                    case 3:
                        [option3 addObject:ops.options];
                        break;
                    case 4:
                        [option4 addObject:ops.options];
                        break;
                    case 5:
                        [option5 addObject:ops.options];
                        break;
                        
                    default:
                        break;
                }
            
            if (option1.count > 0) {
                NSDictionary * dic = @{@"options":option1,@"playType":@"1"};
                [betPlayTypes addObject:dic];
            }
            if (option2.count > 0) {
                NSDictionary * dic = @{@"options":option2,@"playType":@"2"};
                [betPlayTypes addObject:dic];
            }
            if (option3.count > 0) {
                NSDictionary * dic = @{@"options":option3,@"playType":@"3"};
                [betPlayTypes addObject:dic];
            }
            if (option4.count > 0) {
                NSDictionary * dic = @{@"options":option4,@"playType":@"4"};
                [betPlayTypes addObject:dic];
            }
            if (option5.count > 0) {
                NSDictionary * dic = @{@"options":option5,@"playType":@"5"};
                [betPlayTypes addObject:dic];
            }
            
        dicMatche1 = @{@"dan":@NO,
                                     @"matchId": self.shortCutModel.jcPairingMatchDto.lineId,
                                     @"clash":[NSString stringWithFormat:@"%@VS%@",self.shortCutModel.jcPairingMatchDto.homeName,self.shortCutModel.jcPairingMatchDto.guestName],
                                     @"matchKey":self.shortCutModel.jcPairingMatchDto.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
       
       }
        
        if (dicMatche1 != nil) {
            
            [betMatches addObject:dicMatche1];
        }
    }
    
    NSDictionary *betContent  = @{
                                  @"betMatches":betMatches,
                                  @"passTypes":passTypes
                                  };
    
    
    return betContent;
    
}

@end
