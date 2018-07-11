//
//  JCZQSchemeModel.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "JCZQSchemeModel.h"
#import "JCLQSchemeModel.h"

@implementation JCZQSchemeModel

-(id)initWith:(NSDictionary *)dic{
    
    if ([super initWith:dic]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{

    if ([key isEqualToString:@"list"]) {
        if (value != nil) {
            NSMutableArray *schemeList = [NSMutableArray arrayWithCapacity:0];
            NSArray *listArray = [Utility objFromJson:value];
            for (NSDictionary *itemDic in listArray) {
                JCZQSchemeItem *itemModel = [[JCZQSchemeItem alloc]initWith:itemDic];
                [schemeList addObject:itemModel];
            }
            self.list = schemeList;
        }
    } else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation JCZQSchemeItem
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"trOpenResult"]) {
        self.trDltOpenResult = value;
        
        NSMutableArray *trOpenResult = [[NSMutableArray  alloc]initWithCapacity:0];
        NSArray *resArray = [Utility objFromJson:value];
        
        for (NSDictionary *item in resArray) {
            if ([self.lottery isEqualToString:@"JCLQ"]) {
                JCLQOpenResult *result = [[JCLQOpenResult alloc]initWith:item];
                [trOpenResult addObject:result];
            }else{
                OpenResult *result = [[OpenResult alloc]initWith:item];
                [trOpenResult addObject:result];
            }
        }
        self.trOpenResult = trOpenResult;
    }else if([key isEqualToString:@"followListDtos"]){
        NSMutableArray *schemeList = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [Utility objFromJson:value];
        for (NSDictionary *itemDic in listArray) {
            FollowListModel *itemModel = [[FollowListModel alloc]initWith:itemDic];
            [schemeList addObject:itemModel];
        }
        self.followListDtos = schemeList;
    }else if([key isEqualToString:@"passType"]){
        self.passType =[Utility objFromJson:value];
    } else{
        
        
        [super setValue:value forKey:key];
    }
}
-(NSString *)getSchemeImgState{
    
    NSString *state;
    if ([self.schemeStatus isEqualToString:@"INIT"]) {
        state = @"unpaid";
    }else if([self.schemeStatus isEqualToString:@"CANCEL"]){
        state = @"failure";
    }else if([self.schemeStatus isEqualToString:@"REPEAL"]){
        state = @"failure";
    }else {
        if ([self.ticketStatus isEqualToString:@"FAIL_TICKET"]) {
            state = @"failure";
            
        }else if ([self.ticketStatus isEqualToString:@"WAIT_PAY"]) {
            state = @"unpaid";
            
        }else if ([self.ticketStatus isEqualToString:@"SUC_TICKET"]) {
            
            if ([self.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
                
                state = @"wait_lottery";
                
            }else{
                
                if ([self.won boolValue]) {
                    
                    state = @"winning";
                 
                    
                }else{
                    state = @"losing_lottery";
                }
            }
            
        }else{
            if ([self.costType isEqualToString:@"CASH"]) {
                state = @"schemeticket";
            }else{
                state = @"wait_lottery";
            }
            
        }
    }
    return state;
}

-(NSString *)getSchemeState{
    
    NSString *state;
    if ([self.schemeStatus isEqualToString:@"INIT"]) {
        state = @"待支付";
    }else if([self.schemeStatus isEqualToString:@"CANCEL"]){
        state = @"方案取消";
    }else if([self.schemeStatus isEqualToString:@"REPEAL"]){
        state = @"已退款";
    }else{
        
            if ([self.ticketStatus isEqualToString:@"FAIL_TICKET"]) {
                state = @"已退款";
               
            }else if ([self.ticketStatus isEqualToString:@"WAIT_PAY"]) {
                state = @"待支付";
                
            }else if ([self.ticketStatus isEqualToString:@"SUC_TICKET"]) {

                    if ([self.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
                        
                        state = @"待开奖";
                        
                    }else{
                        
                        if ([self.won boolValue]) {
                           if([self.winningStatus isEqualToString:@"BIG_GAIN_TICKET"]){
                                state = @"已中奖(已取票)";
                           }else if(![self.winningStatus isEqualToString:@"SEND_PRIZE"])  {
                               state = @"已中奖(派奖中)";
                           }else{
                                state = @"已中奖";
                            }
                            
                        }else{
                            state = @"未中奖";
                        }
                    }
            }else{
                if ([self.costType isEqualToString:@"CASH"]) {
                state = @"出票中";
                }else{
                    state = @"待开奖";
                }
                
            }
    }
    return state;
    
}


-(NSString *)getLotteryByName{
    return  [BaseModel getLotteryByName:self.lottery];
}

-(CGFloat )getGYJCellHeight{

    NSArray * selectArray = [[Utility objFromJson:self.betContent] firstObject][@"number"];
    return selectArray.count * 30 + 80;
    
}

-(CGFloat)getJCZQCellHeight{
    float height = 0;
    NSInteger rownum;
    if (KscreenHeight == 568) {
        rownum = 5;
    }else{
        rownum = 7;
    }
    
    if ([self.schemeStatus isEqualToString:@"CANCEL"]||[self.schemeStatus isEqualToString:@"REPEAL"] || [self.schemeStatus isEqualToString:@"INIT"]) {
        return height + 168;
    }else{
        return height + 187;
    }
}

-(NSString *)lotteryIcon{
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
        return @"icon_guanyajun.png";
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

@end

@implementation OpenResult

@end

@implementation JcBetContent

@end
