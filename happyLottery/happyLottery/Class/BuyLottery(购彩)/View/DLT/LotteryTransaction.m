//
//  LotteryTransaction.m
//  Lottery
//
//  Created by AMP on 5/27/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//
#import "LotteryTransaction.h"
#import "LotteryXHSection.h"
typedef enum {
    NORMAL,
    DOUBLE,
    DANTUO
} DltBetType;
typedef enum {
    General,
    Additional,
    Zodiac
} DltPlayType;



@interface LotteryTransaction() {
    NSMutableArray *bets;
    int betsTotalCount;
    int betsCostTotalAmount;
    NSMutableAttributedString *betDescAttributedString;
    NSMutableAttributedString *touZhuSummaryAS;
    NSMutableAttributedString *touZhuZJSummaryAS;
    int orderAmount;
    int orderAmountZJ;
}
@end

@implementation LotteryTransaction
@synthesize beiTouCount;
@synthesize qiShuCount;
@synthesize needZhuiJia;

- (void) addBet: (LotteryBet*) bet {
    if (nil == bets) {
        bets = [NSMutableArray array];
        betsTotalCount = 0;
        betsCostTotalAmount = 0;
    }
    [bets addObject: bet];
    betsTotalCount += [bet getBetCount];
    betsCostTotalAmount += [bet getBetCost];
    betDescAttributedString = nil;
    touZhuSummaryAS = nil;
    touZhuZJSummaryAS = nil;
}

- (void) removeBet: (LotteryBet *) bet {
    [bets removeObject: bet];
    betsTotalCount -= [bet getBetCount];
    betsCostTotalAmount -= [bet getBetCost];
    betDescAttributedString = nil;
    touZhuSummaryAS = nil;
    touZhuZJSummaryAS = nil;
}

- (void) removeAllBets {
    [bets removeAllObjects];
    betsTotalCount = 0;
    needZhuiJia = NO;
    betsCostTotalAmount = 0;
    betDescAttributedString = nil;
    touZhuSummaryAS = nil;
    touZhuZJSummaryAS = nil;
}

//- (NSUInteger) betCount {
//    if (nil != bets) {
//        return [bets count];
//    }
//    return 0;
//}

- (NSUInteger)totalbetNoteCount{
    NSUInteger n=0;
    for (LotteryBet * bet in bets) {
        n+=[bet getBetCount];
    }
    return n;
}

- (NSArray *) allBets {
    return bets;
}

- (void) setQiShuCount:(int) count {
    qiShuCount = count;
    touZhuSummaryAS = nil;
    touZhuZJSummaryAS = nil;
}

- (void) setBeiTouCount:(int) count {
    beiTouCount = count;
    for (LotteryBet * bet in bets) {
        bet.beiTouCount = count;
    }
    
    touZhuSummaryAS = nil;
    touZhuZJSummaryAS = nil;
}

- (void)setNeedZhuiJia:(BOOL)needZhuiJia_{
    needZhuiJia =  needZhuiJia_;
    for (LotteryBet * bet in bets) {
        bet.needZhuiJia = needZhuiJia;
    }
}
- (NSAttributedString *) getAttributedSummaryText {
    if (nil == betDescAttributedString) {
        NSMutableDictionary *attributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
        attributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
        attributeDic[NSForegroundColorAttributeName] = TextCharColor;
        
        NSMutableDictionary *normalAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
        normalAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
        normalAttributeDic[NSForegroundColorAttributeName] = TEXTGRAYCOLOR;
        
        betDescAttributedString = [[NSMutableAttributedString alloc] init];
        
        [betDescAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", betsTotalCount] attributes: attributeDic]];
        [betDescAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryBetUnit attributes: normalAttributeDic]];
        [betDescAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @" %d", betsCostTotalAmount] attributes: attributeDic]];
        [betDescAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    }
    return betDescAttributedString;
}

- (int) getBetsTotalCount {
    
    return betsTotalCount;
}

- (int) getBetsCostTotalAmount {
    
    return betsCostTotalAmount;
}

-(NSInteger)betCost{
    if (self.needZhuiJia) {
        return orderAmountZJ;
    }else{
        return orderAmount;
    }
}




- (NSString*) forceZeroFromInt: (int) number {
    NSString *forceStr = @"";
    if (number < 10) {
        forceStr = @"0";
    }
    return [NSString stringWithFormat: @"%@%d", forceStr, number];
}

/*
 1. 倍投的话，相当于多投了一注，所以价格加倍，但是注数保持不变
 2. 追期的话，相同的下注再买一期，价格加倍
 3. 追加投注，没注加1块，倍投的话注数按照 注数*倍投数算*期数
 */
- (NSAttributedString *) getTouZhuSummaryText {
    //    if (touZhuZJSummaryAS == nil) {
    NSMutableDictionary *redAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    redAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    redAttributeDic[NSForegroundColorAttributeName] = TextCharColor;
    
    
    NSMutableDictionary *blueAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    blueAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    blueAttributeDic[NSForegroundColorAttributeName] = TextCharColor;
    
    NSMutableDictionary *normalAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    normalAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    normalAttributeDic[NSForegroundColorAttributeName] = TEXTGRAYCOLOR;
    
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] init];
    
    //注数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: betsTotalCount] attributes: redAttributeDic]];
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryBetUnit attributes: normalAttributeDic]];
    
    //倍数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: self.beiTouCount] attributes: blueAttributeDic]];
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryBeiUnit attributes: normalAttributeDic]];
    
    //期数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: self.qiShuCount] attributes: blueAttributeDic]];
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryQiUnit attributes: normalAttributeDic]];
    
    //总计
    int totalAmount = betsCostTotalAmount*self.beiTouCount*self.qiShuCount;
    orderAmount = totalAmount;
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@", TextTouZhuSummaryTotal] attributes: normalAttributeDic]];
    
    touZhuSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    
    totalAmount = totalAmount+([self getBetsTotalCount] * self.beiTouCount * self.qiShuCount);
    //        totalAmount += self.beiTouCount*self.qiShuCount*betsTotalCount;
    orderAmountZJ = abs (totalAmount);
    touZhuZJSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    
    [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    //    }
    NSAttributedString *descStr = touZhuSummaryAS;
    if (self.needZhuiJia) {
        descStr = touZhuZJSummaryAS;
    }
    return descStr;
}

- (NSAttributedString *) getTouZhuSummaryText1 {
    NSMutableDictionary *redAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    redAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    redAttributeDic[NSForegroundColorAttributeName] = SystemGreen;
    
    NSMutableDictionary *blueAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    blueAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    blueAttributeDic[NSForegroundColorAttributeName] = SystemGreen;
    
    NSMutableDictionary *normalAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    normalAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    normalAttributeDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] init];
    
    //注数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: betsTotalCount] attributes: redAttributeDic]];
    self.betCount = betsTotalCount;
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryBetUnit attributes: normalAttributeDic]];
    
    //倍数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: self.beiTouCount] attributes: blueAttributeDic]];
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryBeiUnit attributes: normalAttributeDic]];
    
    //期数
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: self.qiShuCount] attributes: blueAttributeDic]];
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryQiUnit attributes: normalAttributeDic]];
    
    //总计
    int totalAmount = betsCostTotalAmount*self.beiTouCount*self.qiShuCount;
    orderAmount = totalAmount;
    
    //    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@", TextTouZhuSummaryTotal] attributes: normalAttributeDic]];
    
    touZhuSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    //    [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    
    totalAmount = totalAmount+([self getBetsTotalCount] * self.beiTouCount * self.qiShuCount);
    
    orderAmountZJ = abs (totalAmount);
    touZhuZJSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    //    [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    
    //    [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    //    [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    //    }
    NSAttributedString *descStr = touZhuSummaryAS;
    if (self.needZhuiJia) {
        descStr = touZhuZJSummaryAS;
    }
    return descStr;
}

- (NSAttributedString *) getTouZhuSummaryText2 {
    NSMutableDictionary *redAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    redAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    redAttributeDic[NSForegroundColorAttributeName] = SystemGreen;
    
    NSMutableDictionary *blueAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    blueAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    blueAttributeDic[NSForegroundColorAttributeName] = SystemGreen;
    
    NSMutableDictionary *normalAttributeDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    normalAttributeDic[NSFontAttributeName] = [UIFont boldSystemFontOfSize: 14];
    normalAttributeDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] init];
    
    //总计
    int totalAmount = betsCostTotalAmount*self.beiTouCount*self.qiShuCount;
    if (self.costType == CostTypeSCORE) {
        totalAmount *= 100;
    }else{
        
    }
    orderAmount = totalAmount;
    [descAttributedString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@", TextTouZhuSummaryTotal] attributes: normalAttributeDic]];
    
    touZhuSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    
    totalAmount =  totalAmount / 2 * 3 ;//totalAmount+([self getBetsTotalCount] * self.beiTouCount * self.qiShuCount);
    
    orderAmountZJ = abs (totalAmount);
   
    touZhuZJSummaryAS = [[NSMutableAttributedString alloc] initWithAttributedString: descAttributedString];
    [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: [self forceZeroFromInt: totalAmount] attributes: redAttributeDic]];
    
    if (self.costType == CostTypeSCORE) {
        [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: @"积分" attributes: normalAttributeDic]];
        [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: @"积分" attributes: normalAttributeDic]];
    }else{
        [touZhuSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
        [touZhuZJSummaryAS appendAttributedString: [[NSAttributedString alloc] initWithString: TextTouZhuSummaryCurrencyUnit attributes: normalAttributeDic]];
    }
 
    //    }
    NSAttributedString *descStr = touZhuSummaryAS;
    if (self.needZhuiJia) {
        descStr = touZhuZJSummaryAS;
    }
    return descStr;
}
/*
 single("单式","101"),
 multiple("复式","102"),
 dantuo("单式","103");
 
 {
 "betSource": "iphone",
 "bonus": "",
 "catchOnOrderNum": "",
 "issueNumber": "",
 "lottList": [
 {
 "addtional": 1,
 "bonus": 3.0,
 "count": 1,
 "lotteryType": "DLT",
 "number": "02,14,17,33,34#08,10",
 "orderNumber": "",
 "orderStatus": 1,
 "playType": 101,
 "playTypeName": "单式"
 }
 ],
 "lotteryNumbers": "",
 "lotteryType": "DLT",
 "multiple": 1,
 "orderNumber": "",
 "orderStatus": 1,
 "orderTime": "2015-05-22 16:03:46",
 "orderbonus": 3.0,
 "ordercount": 1,
 "saleChannelNo": "A000",
 "saleChannelType": "channel_C00",
 "user": "88888888888888",
 "winningStatus": 0,
 "addtional": 1
 }
 
 * betSource: 客户端描述，iphone请求值为 "iphone"
 * bonus: 每注的单价
 * catchOnOrderNum：追加订单号, 投注无此信息，为空
 * issueNumber: 当前期编号
 * lottList: 每注信息
 *      addtional: 是否追加，1：追加；0：不追加
 *      bonus: 此注价格
 *      lotteryType: 彩票类型描述
 *      number: 奖注号码，格式：红胆号$红选号# 蓝胆号$蓝选号
 *      orderNumber： 订单号，投注为空
 *      orderStatus： 订单出票未出票状态，传0
 *      playType: 下注类型标号
 *      playTypeName： 下注类型描述
 *      count：？
 * lotteryNumbers： 开奖号，投注时为空
 * lotteryType：彩票类型描述
 * multiple： 倍投数
 * orderNumber： 订单号，投注为空
 * orderStatus： 订单出票未出票状态，传0
 * orderTime：提交时间，格式为 “2015-05-22 16:03:46”
 * orderBonus：订单总价，包含倍投， 追期和追加
 * orderCount：？
 * saleChannelNo：传空
 * saleChannelType：传空
 * user：卡号
 * winningStatus：为0
 * addtional：是否追加
 */

- (NSMutableDictionary *) submitParamDic {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"betSource"] = @"2";
    paramDic[@"bonus"] = @"0";
    paramDic[@"catchOnOrderNum"] = @"1";
    paramDic[@"issueNumber"] = self.lottery.currentRound.issueNumber;
    paramDic[@"lotteryNumbers"] = @"";
    //        paramDic[@"lotteryNumbers"] = @"";
    paramDic[@"lotteryType"] = self.lottery.identifier;
    paramDic[@"multiple"] = [NSNumber numberWithInteger: self.beiTouCount];
    //    paramDic[@"orderNumber"] = @"";
    paramDic[@"orderStatus"] = @"1";
    paramDic[@"orderTime"] = [Utility timeStringFromFormat: @"yyyy-MM-dd HH:mm:ss" withDate: [NSDate date]];
    paramDic[@"orderbonus"] = [NSNumber numberWithInt:self.needZhuiJia?orderAmountZJ:orderAmount];
    paramDic[@"ordercount"] = [NSNumber numberWithInt: betsTotalCount];
    //    paramDic[@"saleChannelNo"] = @"";
    //    paramDic[@"saleChannelType"] = @"";
    
    //  paramDic[@"user"] = [[[GlobalInstance instance]curUser]username];
    NSString* struser = [NSString stringWithFormat:@"%@",[GlobalInstance instance].curUser.cardCode];
    paramDic[@"cardCode"] = struser;
    
    paramDic[@"winningStatus"] = @"0";
    paramDic[@"addtional"] = self.needZhuiJia?@"1":@"0";
    return paramDic;
}

- (NSArray *) lottData {
    NSMutableArray *betsParams = [NSMutableArray array];
    for (LotteryBet *bet in bets) {
        NSMutableDictionary *betDic = [NSMutableDictionary dictionary];
        betDic[@"addtional"] = self.needZhuiJia?@"1":@"0";
        float bonus = [bet getBetCost]*self.beiTouCount;
        betDic[@"bonus"] = [NSNumber numberWithInt: bonus];
        betDic[@"lotteryType"] = self.lottery.identifier;
        
        NSNumber * playType = [NSNumber numberWithInt: [bet betType]];
        switch ([bet betType]) {
            case 212:
                playType = [NSNumber numberWithInt:202];
                break;
            case 213:
                playType = [NSNumber numberWithInt:203];
                break;
            case 214:
                playType = [NSNumber numberWithInt:204];
                break;
            case 215:
                playType = [NSNumber numberWithInt:205];
                break;
            case 216:
                playType = [NSNumber numberWithInt:206];
                break;
            case 217:
                playType = [NSNumber numberWithInt:207];
                break;
            case 222:
                playType = [NSNumber numberWithInt:221];
                break;
            case 232:
                playType = [NSNumber numberWithInt:231];
                break;
            case 229:
                playType = [NSNumber numberWithInt:220];
                break;
            case 239:
                playType = [NSNumber numberWithInt:230];
                break;
            default:
                break;
        }
        if ([self.lottery.identifier isEqualToString:@"SX115"] || [self.lottery.identifier  isEqualToString:@"SD115"]) {
            NSString * playTypeName = [bet betTypeDesc];
            betDic[@"playTypeName"] = playTypeName;
            
            betDic[@"playType"] = playType;
            if (bet.orderBetPlayType) {
                betDic[@"playType"] = bet.orderBetPlayType;
            }
            //            if([GlobalInstance instance].lotttypefromorder)
            //            {
            //                betDic[@"playType"] =[GlobalInstance instance].lotttypefromorder;
            //                [GlobalInstance instance].lotttypefromorder = nil;
            //            }
        }
        else if([self.lottery.identifier isEqualToString:@"DLT"]||[self.lottery.identifier isEqualToString:@"SSQ"])
        {
            if ([bet needZhuiJia]) {
                betDic[@"playType"] = [NSNumber numberWithInt:Additional];
            }
            else
            {
                betDic[@"playType"] = [NSNumber numberWithInt:General];
            }
            NSString * BetTypeName = [bet betTypeDesc];
            betDic[@"playTypeName"] = BetTypeName;
            NSNumber *num;
            if([BetTypeName isEqualToString:@"胆拖"])
            {
                num = [NSNumber numberWithInt:DANTUO];
                betDic[@"betType"] = num;
            }
            else if([BetTypeName isEqualToString:@"复式"])
            {
                num = [NSNumber numberWithInt:DOUBLE];
                betDic[@"betType"] = num;
            }
            else
            {
                num = [NSNumber numberWithInt:NORMAL];
                betDic[@"betType"] = num;
            }
            
            //            if([GlobalInstance instance].lotttypefromorder)
            //            {
            //                betDic[@"playType"] =[GlobalInstance instance].lotttypefromorder;
            //            }
            
            
        }
        NSInteger betCount = [bet getBetCount];
        betDic[@"count"] =  [NSString stringWithFormat:@"%ld",(long)betCount];
        
        NSDictionary *bettypedic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"BetType" ofType: @"plist"]];
        
        //212 213 214 215 216 217 222 232
        /*增加参数betType,表示单复式或胆托*/
        if ([self.lottery.identifier isEqualToString:@"SX115"] ||  [self.lottery.identifier  isEqualToString:@"SD115"]) {
            if([bet betType] == 212 || [bet betType] == 213 || [bet betType] == 214 || [bet betType] == 215 || [bet betType] == 216 || [bet betType] == 217 || [bet betType] == 222 || [bet betType] == 232)
            {
                NSNumber *num = [bettypedic objectForKey:@"Towed"];
                betDic[@"betType"] = num;
            }
            else if([bet betType] == 229 || [bet betType] == 239 )
            {
                NSNumber *num = [bettypedic objectForKey:@"Direct"];
                betDic[@"betType"] = num;
            }
            //前一 201 和 任八 208 没有 复式
            else if(betCount > 1 && [bet betType] != 208 && [bet betType] != 201)
            {
                NSNumber *num = [bettypedic objectForKey:@"Double"];
                betDic[@"betType"] = num;
            }
            else
            {
                NSNumber *num = [bettypedic objectForKey:@"Single"];
                betDic[@"betType"] = num;
            }
        }
        betDic[@"orderStatus"] = @"0";
        NSString * number = [bet getBetNumberDesc];
        betDic[@"lotteryNumbers"] = @"";
        
        if ([playType intValue] == 230 || [playType intValue] == 220) {
            // 投注样式如果是前二或前三， 区域间隔为 ,
            
            betDic[@"number"] = [number stringByReplacingOccurrencesOfString:@";" withString:@"#"];
        }else{
            /*将_sectionDataLinkSymbol在plist文件中的值由"＃"改为“;”,这里传值改回“＃”*/
            NSString * number = [bet getBetNumberDesc];
            if ([self.lottery.identifier isEqualToString:@"SX115"] || [self.lottery.identifier  isEqualToString:@"SD115"]) {
                number = [number stringByReplacingOccurrencesOfString:@";" withString:@"#"];
            }
            else
            {
                number = [number stringByReplacingOccurrencesOfString:@";" withString:@"+"];
            }
            betDic[@"number"] = number;
            
        }
        //        NSString * numberfromorder = [GlobalInstance instance].lottdatanumberfromorder;
        //        if(numberfromorder)
        //        {
        //            betDic[@"number"] =  numberfromorder;
        //        }
        [betsParams addObject: betDic];
    }
    
    //    if( [GlobalInstance instance].lotttypefromorder)
    //    {
    //         [GlobalInstance instance].lotttypefromorder = nil;
    //    }
    //    if([GlobalInstance instance].lottdatanumberfromorder)
    //    {
    //        [GlobalInstance instance].lottdatanumberfromorder = nil;
    //    }
    return betsParams;
}

- (NSString *)couldTouzhu{
    if([self.lottery.activeProfile.couldRepeatSelect boolValue]){
        return nil;
    }else{
        NSString * errorString;
        int betMinNum = [self.lottery.activeProfile.betMinNum intValue];
        
        LotteryXHSection *lotteryXH_Fir = (LotteryXHSection *)self.lottery.activeProfile.details[0];
        LotteryXHSection *lotteryXH_Sec = (LotteryXHSection *)self.lottery.activeProfile.details[1];
        
        NSUInteger selectNumberCount_fir = [lotteryXH_Fir.numbersSelected count];
        NSUInteger selectNumberCount_sec = [lotteryXH_Sec.numbersSelected count];
        
        if ((selectNumberCount_fir  == 0 && selectNumberCount_sec < betMinNum+1) || selectNumberCount_fir+selectNumberCount_sec <betMinNum+1) {
            errorString = [NSString stringWithFormat:TextDanTuoNumLess,betMinNum+1];
        }
        
        return errorString;
    }
}
-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] =[NSString stringWithFormat:@"%@",[GlobalInstance instance].curUser.cardCode];;
    submitParaDic[@"lottery"] = @(self.lottery.type);
    
    submitParaDic[@"issueNumber"] = self.lottery.currentRound.issueNumber;
    submitParaDic[@"units"] = [NSString stringWithFormat:@"%d",[self getBetsTotalCount]];
    submitParaDic[@"multiple"] = [NSString stringWithFormat:@"%d",self.beiTouCount];
    if (self.costType == CostTypeSCORE) {
        submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%d",(needZhuiJia?orderAmountZJ:orderAmount) * 100];
    }else{
        submitParaDic[@"betCost"] =[NSString stringWithFormat:@"%d",needZhuiJia?orderAmountZJ:orderAmount];
    }
    
    submitParaDic[@"schemeType"] = @(self.schemeType);
    submitParaDic[@"channelCode"] = CHANNEL_CODE;
    submitParaDic[@"schemeSource"] = @(0);
    submitParaDic[@"SecretType"] = @(self.secretType);
    submitParaDic[@"betSource"] = @"2";
    submitParaDic[@"costType"] = @(self.costType);
    if (self.schemeType == SchemeTypeZigou) {
        submitParaDic[@"copies"] = @"1";
        submitParaDic[@"sponsorCopies"] = @"1";
        
        submitParaDic[@"minSubCost"] =submitParaDic[@"betCost"];
        submitParaDic[@"sponsorCost"] = submitParaDic[@"betCost"];
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
/*"[
 {
 \"betRows\": [
 [
 2,
 4
 ],
 [
 6
 ],
 [
 8
 ]
 ],
 \"betType\": 5,
 \"multiple\": 0,
 \"playType\": \"TopThreeDirect\",
 \"units\": 0
 }
 ]"*/

//[{\"betType\":2,\"blueDanList\":[1],\"blueList\":[11,12],\"multiple\":0,\"playType\":\"General\",\"redDanList\":[1,2],\"redList\":[3,4,5,6,7],\"units\":0}]
- (id )lottDataScheme{
    
    
    
    NSMutableArray *betsArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *tempDic in [self lottData]) {
        
        
        if ([self.lottery.identifier isEqualToString:@"DLT"]||[self.lottery.identifier isEqualToString:@"SSQ"]) {
            NSString *number = tempDic[@"number"];
            
            NSArray *redList ;
            NSArray *redDanList;
            NSArray *blueList;
            NSArray *blueDanList;
            
            if ([number rangeOfString:@"+"].length > 0) {
                NSArray *array = [number componentsSeparatedByString:@"+"];
                NSString *redStr = array[0];
                NSString *blueStr = array[1];
                
                if ([redStr rangeOfString:@"#"].length >0) {
                    NSArray * array =  [redStr componentsSeparatedByString:@"#"];
                    redDanList = [[array firstObject] componentsSeparatedByString:@","];
                    redList = [[array lastObject] componentsSeparatedByString:@","];
                }else{
                    redList = [redStr componentsSeparatedByString:@","];
                    redDanList = @[];
                }
                
                if ([blueStr rangeOfString:@"#"].length >0) {
                    NSArray * array =  [blueStr componentsSeparatedByString:@"#"];
                    blueDanList = [[array firstObject] componentsSeparatedByString:@","];
                    blueList = [[array lastObject] componentsSeparatedByString:@","];
                }else{
                    blueList = [blueStr componentsSeparatedByString:@","];
                    blueDanList = @[];
                }
            }
            
            NSDictionary *dic = @{@"betType":tempDic[@"betType"],
                                  @"multiple":[NSNumber numberWithInteger: self.beiTouCount],
                                  @"playType":@([tempDic[@"addtional"] integerValue]),
                                  @"units":tempDic[@"count"],
                                  @"blueDanList":blueDanList,
                                  @"blueList":blueList,
                                  @"redDanList":redDanList,
                                  @"redList":redList
                                  };
            
            [betsArray addObject:dic];
            
        }else{
            
            
            NSMutableArray *mSelectNum = [NSMutableArray arrayWithCapacity:0];
            NSString *number = tempDic[@"number"];
            if ([number rangeOfString:@"#"].length > 0) {
                NSArray *tempArray = [number componentsSeparatedByString:@"#"];
                for (NSString * tempStr in tempArray) {
                    NSMutableArray *temp1Array = [NSMutableArray arrayWithCapacity:0];
                    if ([tempStr rangeOfString:@","].length >0) {
                        NSArray *a = [tempStr componentsSeparatedByString:@","];
                        for (NSString *str  in a) {
                            if (![str isEqualToString:@""]) {
                                [temp1Array addObject:str];
                            }
                        }
                    }else{
                        [temp1Array addObject:tempStr];
                    }
                    [mSelectNum addObject:temp1Array];
                }
            }else{
                NSMutableArray *temp1Array = [NSMutableArray arrayWithCapacity:0];
                if ([number rangeOfString:@","].length >0) {
                    NSArray *a = [number componentsSeparatedByString:@","];
                    for (NSString *str  in a) {
                        if (![str isEqualToString:@""]) {
                            [temp1Array addObject:str];
                        }
                    }
                }else{
                    [temp1Array addObject:number];
                }
                [mSelectNum addObject:temp1Array];
                
            }
            
            
            NSString *key = [NSString stringWithFormat:@"%@",tempDic[@"playType"]];
            
            NSDictionary *dic = @{@"betRows":mSelectNum,
                                  @"betType":tempDic[@"betType"],
                                  @"multiple":[NSNumber numberWithInteger: self.beiTouCount],
                                  @"playType":self.X115PlayType[key],
                                  @"units":tempDic[@"count"]
                                  };
            [betsArray addObject:dic];
        }
    }
    
    return betsArray;
}

-(NSMutableDictionary *)getDLTChaseScheme{
   
    NSDictionary *dataDic = [[self lottData] firstObject];
    NSDictionary *itemDic= @{
                              @"cardCode":[GlobalInstance instance].curUser.cardCode,
                              @"lottery":@(self.lottery.type),
                              @"playType":dataDic[@"playType"],
                              @"betType":dataDic[@"betType"],
                              @"totalCatch":@(self.qiShuCount),
                              @"beginIssue":self.lottery.currentRound.issueNumber,
                              @"winStopStatus":@(self.winStopStatus),
                              @"channelCode":CHANNEL_CODE,
                              @"chaseList":[self getChaseList],
                              @"stopBonus":@5000,
                              @"units":@(self.betCount)
                              };
    return [[NSMutableDictionary alloc]initWithDictionary:itemDic];
}

-(NSMutableArray*)getChaseList{
    NSMutableArray *chaseList = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < self.qiShuCount; i ++) {
        
        NSDictionary *itemDic = @{@"issueNumber":[NSString stringWithFormat:@"%ld",[self.lottery.currentRound.issueNumber integerValue] + i],
                                  @"units":@(self.betCount),
                                  @"multiple":@(self.beiTouCount),
                                  @"cost":@(self.beiTouCount * self.betCount * self.needZhuiJia== YES?3:2)
                                  };
        [chaseList addObject:itemDic];
    }
    return chaseList;
}


@end
