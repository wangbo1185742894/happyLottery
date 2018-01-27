//
//  JCZQSchemeModel.m
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "JCZQSchemeModel.h"

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
    }else{
        [super setValue:value forKey:key];
    }
    
}

@end

@implementation JCZQSchemeItem
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"trOpenResult"]) {
        NSMutableArray *trOpenResult = [[NSMutableArray  alloc]initWithCapacity:0];
        NSArray *resArray = [Utility objFromJson:value];
        for (NSDictionary *item in resArray) {
            OpenResult *result = [[OpenResult alloc]initWith:item];
            [trOpenResult addObject:result];
        }
        self.trOpenResult = trOpenResult;
    }else{
        
        self.lotteryIcon = @"football";
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
    }else{
        if ([self.ticketStatus isEqualToString:@"FAIL_TICKET"]) {
            state = @"failure";
            
        }else if ([self.ticketStatus isEqualToString:@"WAIT_PAY"]) {
            state = @"unpaid";
            
        }else{
            
            if ([self.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
                
                state = @"wait_lottery";
                
            }else{
                
                if ([self.won boolValue]) {
                    
                    state = @"winning";
                 
                    
                }else{
                    state = @"losing_lottery";
                }
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
                            if (![self.winningStatus isEqualToString:@"SEND_PRIZE"]) {
                                state = @"已中奖(派奖中)";
                            }else if([self.winningStatus isEqualToString:@"BIG_GAIN_TICKET"]){
                                state = @"中奖(已取票)";
                            }else{
                                state = @"已中奖";
                            }
                            
                        }else{
                            state = @"未中奖";
                        }
                    }
            }else{
                state = @"出票中";
            }
    }
    return state;
    
}

-(CGFloat)getJCZQCellHeight{
    float height = 0;
    NSInteger rownum;
    if (KscreenHeight == 568) {
        rownum = 5;
    }else{
        rownum = 7;
    }
    
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        NSDictionary *dic = [Utility objFromJson:self.betContent];

        if ([[dic allKeys] containsObject:@"passTypes"]) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *passTypes = (NSArray*)dic[@"passTypes"];
                
                if (passTypes.count %rownum == 0) {
                    height += passTypes.count/rownum *20;
                }else{
                    height += (passTypes.count/rownum + 1) *18;
                }
            }
        }else{
            if ([dic isKindOfClass:[NSDictionary class]]) {
                height = 20;
            }
        }
    }
    
    if ([self.schemeStatus isEqualToString:@"CANCEL"]||[self.schemeStatus isEqualToString:@"REPEAL"]) {
        return height + 138;
    }else{
        return height + 157;
    }
    
    
}

@end

@implementation OpenResult

@end
