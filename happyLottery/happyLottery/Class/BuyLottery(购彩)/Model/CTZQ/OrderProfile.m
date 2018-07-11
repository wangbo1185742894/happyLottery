//
//  OrderProfile.m
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "OrderProfile.h"

@implementation OrderProfile

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isZhuiHao = NO;
        self.isHeMai = NO;
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }
    if ([key isEqualToString:@"openResult"]) {
        key = @"trOpenResult";
    }
    [super setValue:strValue forKey:key];
}

-(void)setPropertys:(NSDictionary *)orderInfo{
    self.addtional = orderInfo[@"addtional"];
    self.cardtype = orderInfo[@"cardtype"];
    self.issueNumber = [NSString stringWithFormat:@"%@",orderInfo[@"issueNumber"]];
    self.lotteryType = orderInfo[@"lotteryType"];
    self.orderNumber = [NSString stringWithFormat:@"%@",orderInfo[@"orderNumber"]];
    self.orderStatus = orderInfo[@"orderStatus"];
    self.orderTime = orderInfo[@"orderTime"];
    self.orderbonus = [NSString stringWithFormat:@"%@",orderInfo[@"orderBonus"]];
    self.ordercount = [NSString stringWithFormat:@"%@",orderInfo[@"orderCount"]];
    self.winningStatus = [NSString stringWithFormat:@"%@",orderInfo[@"winningStatus"]];
    
    //0928
    self.beginIssue = [NSString stringWithFormat:@"%@",orderInfo[@"beginIssue"]];//开始期号
    self.catchContent = [NSString stringWithFormat:@"%@",orderInfo[@"catchContent"] ];//选择号码
    self.catchIndex = orderInfo[@"catchIndex"];
    self.catchSchemeId = [NSString stringWithFormat:@"%@",orderInfo[@"catchSchemeId"]];//单号
    self.catchStatus = orderInfo[@"catchStatus"];//追号状态 0追号中 1已停追 2已取消
    self.catchType = orderInfo[@"catchType"];
    self.createTime = orderInfo[@"createTime"];//下单时间
    
    NSString *lotterytype = [NSString stringWithFormat:@"%@",orderInfo[@"lotteryCode"]];
    self.lottery =lotterytype;//x115
    
    self.modifyTime = orderInfo[@"modifyTime"];
    self.orderBonus = [NSString stringWithFormat:@"%@",orderInfo[@"orderBonus"]];//投注金额
    self.totalCatch = orderInfo[@"totalCatch"];//追期数
    self.winStatus = [NSString stringWithFormat:@"%@",orderInfo[@"winStatus"]];
    self.winStopStatus = [NSString stringWithFormat:@"%@",orderInfo[@"winStopStatus"]];//中奖停追
    self.playType = [NSString stringWithFormat:@"%@",orderInfo[@"playType"]];
    self.bonus = [NSString stringWithFormat:@"%@",orderInfo[@"bonus"]];
    
    //10.16
    self.payStatus = [NSString stringWithFormat:@"%@",orderInfo[@"payStatus"]];
    self.subscription = [NSString stringWithFormat:@"%@",orderInfo[@"subscription"]];
    self.lotteryNumber = [NSString stringWithFormat:@"%@",orderInfo[@"lotteryNumber"]];
    //10.18
    self.mutiple = [NSString stringWithFormat:@"%@",orderInfo[@"mutiple"]];
    self.units = [NSString stringWithFormat:@"%@",orderInfo[@"units"]];
    //11.09
    self.openResult = [NSString stringWithFormat:@"%@",orderInfo[@"openResult"]];
    //11.10
    self.remark = [NSString stringWithFormat:@"%@",orderInfo[@"remark"]];
    self.ticketRemark = [NSString stringWithFormat:@"%@",orderInfo[@"ticketRemark"]];
    //11.10 足球
    self.passModel = [NSString stringWithFormat:@"%@",orderInfo[@"passModel"]];
    self.passType = [NSString stringWithFormat:@"%@",orderInfo[@"passType"]];
    //11.12
    self.typebet = [NSString stringWithFormat:@"%@",orderInfo[@"betType"]];
    
}

- (NSString *)descToAppear{
    
    NSString * stateString;
    //普通订单返回_winningStatus为int
    if([self.trBonus integerValue] >0 || self.trOpenResult.length > 0)
    {
         stateString = @"已中奖";
    }
    else if([self.trBonus integerValue] <=0 || self.trOpenResult.length > 0)
    {
        stateString = @"未中奖";
    }
    return @"";
}
//_winStatus    __NSCFString *    @"WAIT_LOTTERY"    0x00000001c463ca40@"WAIT_LOTTERY"  NOT_LOTTERY  LOTTERY
- (NSString *)WINST{
    NSString *catchString;
    if ([_winStatus isEqualToString:@"WAIT_LOTTERY"]) {
        catchString = @"追号中";
    }
    if ([_winStatus isEqualToString:@"NOT_LOTTERY"]) {
        catchString = @"已中奖";
    }
    if ([_winStatus isEqualToString:@"LOTTERY"]) {
        catchString = @"未中奖";
    }
    
    return catchString;
}

//11.23 add
- (NSString *)catchResult{
//    NSString *catchString;
    //    WAITDO("待追号 "),
    //    /**已追号*/
    //    CATCHED("已追号"),
    //    /**已取消*/
    //    CANCLE("已取消")
    if ([_itemStatus isEqualToString:@"WAITDO"]) {
        return @"待追号";
    }
    
    if ([_itemStatus isEqualToString:@"CATCHED"]) {
        return @"已追号";
    }
    
    if ([_itemStatus isEqualToString:@"CANCEL"]) {
        return @"撤销追号";
    }
    if ([_chaseStatus isEqualToString:@"CATCHSTOP"]) {
        return @"已停追";
    }
    return @"追号中";
//    switch ([_catchStatus intValue]) {
//        case 0:
//            catchString = @"追号中";
//            break;
//        case 1:
//            catchString = @"中奖停追";
//            break;
//        case 2:
//            catchString = @"追号完成";
//            break;
//        case 3:
//            catchString = @"撤销追号";
//            break;
//        default:
//            catchString = @"";
//            break;
//    }
//    return catchString;
}

-(NSString *)chaseStatus{
    //    NSString *catchString;
    //    WAITDO("待追号 "),
    //    /**已追号*/
    //    CATCHED("已追号"),
    //    /**已取消*/
    //    CANCLE("已取消")
    if ([_chaseStatus isEqualToString:@"WAITDO"]) {
        return @"待追号";
    }
    
    if ([_chaseStatus isEqualToString:@"CATCHED"]) {
        return @"已追号";
    }
    if ([_chaseStatus isEqualToString:@"CANCEL"]) {
        return @"撤销追号";
    }
    if ([_chaseStatus isEqualToString:@"CATCHSTOP"]) {
        return @"已停追";
    }
    return @"追号中";
    //    switch ([_catchStatus intValue]) {
    //        case 0:
    //            catchString = @"追号中";
    //            break;
    //        case 1:
    //            catchString = @"中奖停追";
    //            break;
    //        case 2:
    //            catchString = @"追号完成";
    //            break;
    //        case 3:
    //            catchString = @"撤销追号";
    //            break;
    //        default:
    //            catchString = @"";
    //            break;
    //    }
    //    return catchString;
}


- (NSString *)catchplaytype{
    NSString * catchplaytype;
    if ([self.lotteryCode isEqualToString:@"DLT"]) {
        return @"大乐透";
    }
    if ([self.lotteryCode isEqualToString:@"SSQ"]) {
        return @"双色球";
    }
    switch ([_playType intValue]) {
        case 0:
            if ([_name isEqualToString:@"排列3"] ||[_name isEqualToString:@"排列5"] ) {
                catchplaytype = @"排三直选";
            }else{
            
                catchplaytype = @"前一";
            }
            break;
        case 1:
            if ([_name isEqualToString:@"排列3"] ||[_name isEqualToString:@"排列5"] ) {
                catchplaytype = @"排五直选";
            }else if ([_typebet intValue] == 2) {
                catchplaytype = @"任选二胆拖";//212
            }
            else
            {
                catchplaytype = @"任选二";
            }
            break;
        case 2:
            if ([_name isEqualToString:@"排列3"] ||[_name isEqualToString:@"排列5"] ) {
                catchplaytype = @"排三组三";
            }else if ([_typebet intValue] == 2) {
                catchplaytype = @"任选三胆拖";//213
            }
            else
            {
                catchplaytype = @"任选三";
            }
            break;
        case 3:
            if ([_name isEqualToString:@"排列3"] ||[_name isEqualToString:@"排列5"] ) {
                catchplaytype = @"排三组六";
            }else if ([_typebet intValue] == 2) {
                catchplaytype = @"任选四胆拖";//214
            }
            else
            {
                catchplaytype = @"任选四";
            }
            break;
        case 4:
            if ([_typebet intValue] == 2) {
                catchplaytype = @"任选五胆拖";//215
            }
            else
            {
                catchplaytype = @"任选五";
            }
            break;
        case 5:
            if ([_typebet intValue] == 2) {
                catchplaytype = @"任选六胆拖";//216
            }
            else
            {
                catchplaytype = @"任选六";
            }
            break;
        case 6:
            if ([_typebet intValue] == 2) {
                catchplaytype = @"任选七胆拖";//217
            }
            else
            {
                 catchplaytype = @"任选七";
            }
            break;
        case 7:
            catchplaytype = @"任选八";
            break;
        case 14:
            if ([_typebet intValue] == 5) {
                catchplaytype = @"前二直定位复式";//229
            }else
            {
                catchplaytype = @"前二直选";
            }
            break;
        case 15:
            if ([_typebet intValue] == 5) {
                catchplaytype = @"前三直定位复式";//239
            }else
            {
                catchplaytype = @"前三直选";
            }
            break;
        case 16:
            if ([_typebet intValue] == 2) {
                catchplaytype = @"组二胆拖";//222
            }else
            {
                catchplaytype = @"前二组选";
            }
            break;
        case 17:
            if ([_typebet intValue] == 2) {
                catchplaytype = @"组三胆拖";//232
            }else
            {
                catchplaytype = @"前三组选";
            }
            break;
        case 22:
            catchplaytype = @"乐选二";
            break;
        case 23:
            catchplaytype = @"乐选三";
            break;
        case 24:
            catchplaytype = @"乐选四";
            break;
        case 25:
            catchplaytype = @"乐选五";
            break;
            
        default:
            break;
    }
    return catchplaytype;
}


- (id)lotteryNumberDesc{

    if ([_lotteryType isEqualToString:@"DLT"]||[_lotteryType isEqualToString:@"SSQ"]) {
        if(![_lotteryNumber isEqual:[NSNull null]])
        {
        NSArray * numArray = [_lotteryNumber componentsSeparatedByString:@"#"];
        if (numArray.count < 2) {
            return _lotteryNumber;
        }else{
            
        
            NSMutableAttributedString *lotteryNumString = [[NSMutableAttributedString alloc] init];
            
            NSMutableDictionary *textRedAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
            textRedAttrsDictionary[NSForegroundColorAttributeName] = [UIColor redColor];
            
            [lotteryNumString appendAttributedString: [[NSAttributedString alloc] initWithString: [numArray[0] stringByReplacingOccurrencesOfString:@"," withString:@" "] attributes: textRedAttrsDictionary]];
            
            NSMutableDictionary *textBlueAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
            textBlueAttrsDictionary[NSForegroundColorAttributeName] = [UIColor blueColor];
            [lotteryNumString appendAttributedString: [[NSAttributedString alloc] initWithString: @"  " attributes: textBlueAttrsDictionary]];
            
            [lotteryNumString appendAttributedString: [[NSAttributedString alloc] initWithString: [numArray[1] stringByReplacingOccurrencesOfString:@"," withString:@" "] attributes: textBlueAttrsDictionary]];

            return lotteryNumString;
        }
        }
    }else if([_lotteryType isEqualToString:@"SX115"] || [_lotteryType isEqualToString:@"SD115"]){
        if(![_lotteryNumber isEqual:[NSNull null]])
        {
            NSString * numTring =  [_lotteryNumber stringByReplacingOccurrencesOfString:@"," withString:@" "];
              return numTring;
        }
        return nil;
    }
    return nil;
}
-(id)ZHlotteryNumberDesc
{//@"4"->X115
    if ([_lottery isEqualToString:@"4"]) {
        NSString  * numTring;
        if ([_playType intValue] < 209) {
            
            if ([_typebet intValue] == 2) {
                //任选胆拖
                NSString * string = [NSString stringWithFormat:@"胆:%@",_catchContent];
                NSString * Tring =  [string stringByReplacingOccurrencesOfString:@"#" withString:@" 拖:"];
                numTring = [Tring stringByReplacingOccurrencesOfString:@"," withString:@" "];
            }else
            {
                numTring =  [_catchContent stringByReplacingOccurrencesOfString:@"," withString:@" "];
            }
            
        }else if (([_playType intValue] == 220) || ([_playType intValue] == 230)) {
            
            if ([_typebet intValue] == 2) {
                //229、239
                numTring = _catchContent ;
            }
            else
            {
                numTring = [_catchContent stringByReplacingOccurrencesOfString:@"," withString:@" "];
            }
            
        }
        else if (([_playType intValue] == 221) || ([_playType intValue] == 231)) {
            if ([_typebet intValue] == 2) {
                //222、232
                NSString * string = [NSString stringWithFormat:@"胆:%@",_catchContent];
                NSString * Tring =  [string stringByReplacingOccurrencesOfString:@"#" withString:@" 拖:"];
                numTring = [Tring stringByReplacingOccurrencesOfString:@"," withString:@" "];
            }
            else
            {
                numTring = [_catchContent stringByReplacingOccurrencesOfString:@"," withString:@" "];
            }
            
        }
        return numTring;
}
    return nil;
}

- (NSString *)playTypeAndGuanKa:(NSString *)valueCode{
    
    NSString * guanKa = [_guanKaStatue intValue]!=0?@"过关":nil;
    
    if(_betObjArray.count == 0)
    {
        return nil;
    }
    LotteryBetObj *betObj = (LotteryBetObj *)_betObjArray[0];
//    NSString * playTypeName = [betObj playTypeNameWithCode:valueCode?valueCode:_playType];
//    if (valueCode) {
//        return playTypeName;
//    }
    NSString * playTypeName = betObj.playType;
    if (guanKa) {
        NSString * playTypeAndGuanKa;
        if ([playTypeName isEqualToString:@"混合过关"]) {
            playTypeAndGuanKa = [NSString stringWithFormat:@"%@",playTypeName];
        }else
        {
            playTypeAndGuanKa = [NSString stringWithFormat:@"%@%@",playTypeName,guanKa];
        }
        return playTypeAndGuanKa;
    }
    return playTypeName;
}

-(NSString *)iconName{
    if ([self.lottery isEqualToString:@"DLT"]) {
        return @"icon_daletoushouye.png";
    }
    if ([self.lottery isEqualToString:@"SFC"] || [self.lottery isEqualToString:@"RJC"]) {
        return @"icon_shengfucaishouye.png";
    }
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        return @"icon_jingzu.png";
    }
    if ([self.lottery isEqualToString:@"JCGYJ"]) {
        return @"icon_guanyajun.png";
    }
    if ([self.lottery isEqualToString:@"JCGJ"]) {
        return @"first.png";
    }
    if ([self.lottery isEqualToString:@"SSQ"]) {
        return @"icon_shuangseqiu.png";
    }
    if ([self.lottery isEqualToString:@"JCLQ"]) {
        return @"icon_jinglan.png";
    }
    if ([self.lottery isEqualToString:@"SX115"]){
        
        return @"icon_shiyixuanwu.png";
        
    }
    if ([self.lottery isEqualToString:@"SD115"]){
        
        return @"icon_sdx115.png";
    }
    if ([self.lottery isEqualToString:@"PL3"]){
        
        return @"icon_pai3.png";
    }
    if ([self.lottery isEqualToString:@"PL5"]){
        
        return @"icon_paiwu.png";
    }
    return @"";
}
//[13]    (null)    @"catchContent" : @"[{\"betType\":0,\"multiple\":1,\"blueList\":[\"05\",\"07\"],\"redDanList\":[],\"units\":\"1\",\"blueDanList\":[],\"playType\":0,\"redList\":[\"02\",\"03\",\"05\",\"12\",\"32\"]}]"

-(NSString *)orderBonus{
    NSArray * catchContent = [Utility objFromJson: self.catchContent];
    if ([[catchContent firstObject][@"playType"] integerValue] ==0) {
        return [NSString stringWithFormat:@"%ld",[self.catchIndex  integerValue] * 2];
    }else{
        return [NSString stringWithFormat:@"%ld",[self.catchIndex  integerValue] * 3];
    }
    
}
@end
