//
//  UserInfoBaseModel.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "UserInfoBaseModel.h"

@implementation UserInfoBaseModel

@end

@implementation BonusDetail : UserInfoBaseModel
-(NSString *)get1Name{
    return @"派奖";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.subBonus doubleValue]];
}
-(NSString *)get3Name{
    return @"";
}

-(NSString *)getRemark{
    return @"";
}

-(NSString *)get4Name{
    return self.prizeTime;
}
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n方案号\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n%@\n\n元",[self get1Name],self.schemeNo,self.prizeTime,self.subBonus];
}
@end

@implementation FollowDetail : UserInfoBaseModel
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n方案号\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n%@\n\n元",[self get1Name],self.followSchemeNo,self.createTime,self.commission];
}
-(NSString *)get1Name{
    return @"跟单佣金";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.commission doubleValue]];
}
-(NSString *)get3Name{
    return @"";
}

-(NSString *)getRemark{
    return @"";
}

-(NSString *)get4Name{
    return self.createTime;
}
@end

@implementation HandselDetail : UserInfoBaseModel
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n来源\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n%@\n\n元",[self get1Name],[self getHandselSourceDes],self.createTime,self.amounts];
}

-(NSString *)getHandselSourceDes{
    if ([self.handselSource isEqualToString:@"SCORE_CONVERT"]) {
        return @"积分兑换";
    }
    if ([self.handselSource isEqualToString:@"LUCKY_DRAW"]) {
        return @"抽奖";
    }
    if ([self.handselSource isEqualToString:@"SYSTEM"]) {
        return @"系统赠送";
    }
    if ([self.handselSource isEqualToString:@"ACTIVITY"]) {
        return @"活动";
    }
    return @"系统赠送";
}

-(NSString *)get1Name{
    return @"彩金";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.amounts doubleValue]];
}
-(NSString *)get3Name{
    return self.handselSource;
}

-(NSString *)getRemark{
    return @"";
}

-(NSString *)get4Name{
    return self.createTime;
}
@end

@implementation RechargeDetail : UserInfoBaseModel
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n元",[self get1Name],self.successTime,self.amounts];
}
-(NSString *)get1Name{
    return @"充值";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.amounts doubleValue]];
}
-(NSString *)get3Name{
    return @"";
}

-(NSString *)getRemark{
    return @"";
}

-(NSString *)get4Name{
    return self.successTime;
}
@end

@implementation SubscribeDetail : UserInfoBaseModel
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n彩种\n\n方案号\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    if ([self.useCoupon boolValue] == YES) {
            return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n%@\n\n%@元\n%@元优惠券\n\n合计%@元",[self get1Name],[BaseModel getLotteryByName:self.lotteryType],self.schemeNo,self.subTime,self.realSubAmounts,self.refundAmounts,self.subAmounts];
    }else{
            return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@\n\n%@\n\n%@元\n\n合计%@元",[self get1Name],[BaseModel getLotteryByName:self.lotteryType],self.schemeNo,self.subTime,self.realSubAmounts,self.subAmounts];
    }

}

-(NSString *)get1Name{
    return @"购彩";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.realSubAmounts doubleValue]];
}
-(NSString *)get3Name{
    return [BaseModel getLotteryByName:self.lotteryType];
}

-(NSString *)getRemark{
    if ([self.refundAmounts doubleValue] == 0) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"出票失败，退款%.0f元",[self.refundAmounts doubleValue]];
    }
}
-(NSString *)get4Name{
    return self.subTime;
}
@end

@implementation WithdrawDetail : UserInfoBaseModel

-(NSString *)getLeftTitle{
    //    WAIT_CASH("等待提现"),
    //    /**提现成功*/
    //    CASH_SUCCESS("提现成功"),
    //    /**提现失败*/
    //    CASH_FAILED("提现失败");
    if ([self.orderStatus isEqualToString:@"CASH_FAILED"]) {
        return [NSString stringWithFormat:@"\n类型\n\n状态\n\n金额\n\n时间\n\n备注\n\n"];
    }else{
        return [NSString stringWithFormat:@"\n类型\n\n状态\n\n金额\n\n时间\n\n"];
    }
    
}
-(NSString *)getRightTitle{
    NSString *state;
    if ([self.orderStatus isEqualToString:@"WAIT_CASH"]) {
        state = @"等待提现";
    }else if([self.orderStatus isEqualToString:@"CASH_SUCCESS"]){
        return @"提现成功";
    }else if ([self.orderStatus isEqualToString:@"CASH_FAILED"]){
        return @"提现失败";
    }
    if ([self.orderStatus isEqualToString:@"CASH_FAILED"]) {
        return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@元\n\n%@\n\n%@\n\n",[self get1Name],state,self.amounts,self.createTime,self.remark];
        
    }else if([self.orderStatus isEqualToString:@"CASH_SUCCESS"]){
          return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@元\n\n%@\n\n",[self get1Name],state,self.amounts,self.successTime];
    }else if([self.orderStatus isEqualToString:@"WAIT_CASH"]){
        return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@元\n\n%@\n\n",[self get1Name],state,self.amounts,self.createTime];
    }
    return @"";
}
-(NSString *)get1Name{
//    WAIT_CASH("等待提现"),
//    /**提现成功*/
//    CASH_SUCCESS("提现成功"),
//    /**提现失败*/
//    CASH_FAILED("提现失败");
    if ([self.orderStatus isEqualToString:@"WAIT_CASH"]) {
        return @"提现(等待)";
    }else if([self.orderStatus isEqualToString:@"CASH_SUCCESS"]){
        return @"提现(成功)";
    }else if ([self.orderStatus isEqualToString:@"CASH_FAILED"]){
        return @"提现(驳回)";
    }
    return @"";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.amounts doubleValue]];
}
-(NSString *)get3Name{
    return @"";
}

-(NSString *)getRemark{
    return @"";
}
-(NSString *)get4Name{
    if([self.orderStatus isEqualToString:@"CASH_SUCCESS"]){
        return self.successTime;
    }
    return self.createTime;
}
@end

@implementation AgentCommissionDetail : UserInfoBaseModel
-(NSString *)getLeftTitle{
    return [NSString stringWithFormat:@"\n类型\n\n时间\n\n金额\n\n"];
}
-(NSString *)getRightTitle{
    
        return [NSString stringWithFormat:@"\n%@\n\n%@\n\n%@元\n\n",[self get1Name],self.createTime,self.commission];

    
}
-(NSString *)get1Name{

    return @"圈子返佣";
}
-(NSString *)get2Name{
    return [NSString stringWithFormat:@"%.2f",[self.commission doubleValue]];
}
-(NSString *)get3Name{
    return @"";
}

-(NSString *)getRemark{
    return @"";
}
-(NSString *)get4Name{
   
    return self.createTime;
}
@end
