//
//  CTZQOrderProfile.m
//  Lottery
//
//  Created by LC on 16/5/18.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQOrderProfile.h"

@implementation CTZQOrderProfile
//- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
//    betContent;
//    //@property (nonatomic, strong)NSString *betSource;
//    @property (nonatomic, strong)NSString *cardCode;
//    @property (nonatomic, strong)NSString *cost;
//    //@property (nonatomic, strong)NSString *createTime;
//    @property (nonatomic, strong)NSString *id;
//    //@property (nonatomic, strong)NSString *lottery;
//    //@property (nonatomic, strong)NSString *multiple;
//    //@property (nonatomic, strong)NSString *payStatus;
//    @property (nonatomic, strong)NSString *schemeId;
//    //@property (nonatomic, strong)NSString *units;
//    //@property (nonatomic, strong)NSString *winningStatus;
//    @property (nonatomic, strong)NSString *payTime;
//    //@property (nonatomic, strong)NSString *issueNumber;
//}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.betSource = dic[@"betSource"];
        self.cardCode = dic[@"cardCode"];
        self.cost = dic[@"cost"];
        self.orderbonus = self.cost;
        self.createTime = dic[@"createTime"];
        CGFloat time = [self.createTime doubleValue] / 1000;
        self.createTime = [Utility timeStringFromFormat:@"yyyy-MM-dd" withTI:time];
        self.orderTime = self.createTime;
        
        self.id = dic[@"id"];
        self.lottery = dic[@"lottery"];
        self.lotteryType = self.lottery;
        self.multiple = dic[@"multiple"];
        if ([dic[@"payStatus"] isEqualToString:@"NotPaid"]) {
            self.payStatus = @"false";
        }else{
            self.payStatus = @"ture";
        }
//        self.payStatus = dic[@"payStatus"];
        self.schemeId = dic[@"schemeId"];
        self.orderNumber = self.schemeId;
        self.units = dic[@"units"];
        self.winningStatus = dic[@"winningStatus"];
        self.payTime = dic[@"payTime"];
         time = [self.payTime doubleValue] / 1000;
        self.payTime = [Utility timeStringFromFormat:@"yyyy-MM-dd HH:mm:ss" withTI:time];
        self.issueNumber = dic[@"issueNumber"];
        self.betContent = dic[@"betContent"];
        //不是追号
        self.catchSchemeId = @"";
        
    }
    return self;
}

- (NSString *)descFangAnToAppear{
    
//    if(!orderInfo[@"payStatus"]  ){
//        order.orderStatus = @"5";
//        order.stateAppear = orderStateDic[[NSString stringWithFormat:@"%d",[order.orderStatus intValue]]];
//        //                        order.descToAppear
//    }else{
//        
//        if ([order.winStatus isEqualToString:@"LOTTERY"]) {
//            order.orderStatus =@"2";
//            order.stateAppear = orderStateDic[[NSString stringWithFormat:@"%d",[order.orderStatus intValue]]];
//            
//            //                        order.bonus =
//#warning 中奖金额的处理。
//        }else{
//            order.orderStatus =@"3";
//            order.stateAppear = orderStateDic[[NSString stringWithFormat:@"%d",[order.orderStatus intValue]]];
//#warning 未中奖的出票状态显示
//        }
//    }
    
//    if ([self.orderStatus integerValue] == 5) {
//        <#statements#>
//    }
    
    self.descToAppear = [NSString stringWithFormat:@"%@",self.stateAppear];
    return [NSString stringWithFormat:@"%@",self.stateAppear];
}
@end
