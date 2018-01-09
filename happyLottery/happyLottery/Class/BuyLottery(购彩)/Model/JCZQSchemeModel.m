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
    self.lotteryIcon = @"football";
    [super setValue:value forKey:key];
    
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
                
            }else{
                
                if ([self.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
                   
                    state = @"待开奖";
                    
                }else if ([self.winningStatus isEqualToString:@"NOT_LOTTERY"]) {
                   state = @"未中奖";
                }else{
                    if ([self.won boolValue]) {
                        state = @"已中奖";
                    }else{
                        state = @"未中奖";
                    }
                }
                
            }
    }
    return state;
    
}

-(CGFloat)getJCZQCellHeight{
    float height = 0;
    
    if ([self.lottery isEqualToString:@"JCZQ"]) {
        NSDictionary *dic = [Utility objFromJson:self.betContent];

        if ([[dic allKeys] containsObject:@"passTypes"]) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *passTypes = (NSArray*)dic[@"passTypes"];
                
                if (passTypes.count %7 == 0) {
                    height += passTypes.count/7 *20;
                }else{
                    height += (passTypes.count/7 + 1) *18;
                }
            }
        }else{
            if ([dic isKindOfClass:[NSDictionary class]]) {
                height = 20;
            }
        }
    }
    return height + 177;
}

@end
