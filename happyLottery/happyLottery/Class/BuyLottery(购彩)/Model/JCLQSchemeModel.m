//
//  JCZQSchemeModel.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "JCLQSchemeModel.h"

@implementation JCLQSchemeModel

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
                JCLQSchemeItem *itemModel = [[JCLQSchemeItem alloc]initWith:itemDic];
                [schemeList addObject:itemModel];
            }
            self.list = schemeList;
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation JCLQSchemeItem
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"trOpenResult"]) {
        
        NSMutableArray *trOpenResult = [[NSMutableArray  alloc]initWithCapacity:0];
        NSArray *resArray = [Utility objFromJson:value];
        for (NSDictionary *item in resArray) {
            JCLQOpenResult *result = [[JCLQOpenResult alloc]initWith:item];
            [trOpenResult addObject:result];
        }
        self.trOpenResult = trOpenResult;
    }else{
        
        
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
        state = @"方案撤销";
    }else{
        
            if ([self.ticketStatus isEqualToString:@"FAIL_TICKET"]) {
                state = @"出票失败";
               
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

-(CGFloat)getJCLQCellHeight{
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
        return @"daletou.png";
    }
    if ([self.lottery isEqualToString:@"SFC"] || [self.lottery isEqualToString:@"RJC"]) {
        return @"shengfucai.png";
    }
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        return @"footerball.png";
    }
    if ([self.lottery isEqualToString:@"JCGYJ"]) {
        return @"Championship.png";
    }
    if ([self.lottery isEqualToString:@"JCGJ"]) {
        return @"first.png";
    }
    if ([self.lottery isEqualToString:@"SSQ"]) {
        return @"shuangseqiu.png";
    }
    if ([self.lottery isEqualToString:@"JCLQ"]) {
        return @"basketball.png";
    }
    if ([self.lottery isEqualToString:@"SX115"]){
        
        return @"shiyixuanwu.png";
        
    }
    if ([self.lottery isEqualToString:@"SD115"]){
        
        return @"sdx115.png";
    }
    return @"";
}

@end

@implementation JCLQOpenResult

@end

@implementation JlBetContent

@end
