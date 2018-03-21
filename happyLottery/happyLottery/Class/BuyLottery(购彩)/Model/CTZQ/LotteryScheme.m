//
//  LotteryScheme.m
//  Lottery
//
//  Created by 王博 on 17/4/24.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "LotteryScheme.h"

@implementation LotteryScheme

-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    //    value = [NSString stringWithFormat:@"%@",value];
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        self._id = strValue;
    }else if([key isEqualToString:@"trCommission"]){
    
     self.trCommission = [NSString stringWithFormat:@"%@",[value integerValue]<0?@"0":value];
    }else{
        
        [super setValue:strValue forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}
-(float)getInfoHeight{

    NSDictionary  *betcontent =[Utility objFromJson:self.betContent];
    float height = 80;
    if ([[betcontent allKeys]containsObject:@"passTypes"]) {
        NSArray *passTypes =  (NSArray*)betcontent[@"passTypes"];
        
        if (passTypes.count %6 == 0) {
            height += passTypes.count/6 * 21;
        }else{
            height += (passTypes.count/6) *15 +21;
        }
    }else{
        height += 21;
    }
    
    return height;
}
    
-(CGFloat )getHeight{

    if ([self.lottery isEqualToString:@"JCLQ"] ||[self.lottery isEqualToString:@"JCZQ"] ) {
        @try {
            return [self getJCLQCellHeight];
        } @catch (NSException *exception) {
            return 30;
        }
        
        
    }else if([self.lottery isEqualToString:@"X115"]){
    
        @try {
            return [self getX115CellHeight];
        } @catch (NSException *exception) {
            return 30;
        }
    }else if([self.lottery isEqualToString:@"DLT"]){
        
        @try {
            return [self getDLTCellHeight];
        } @catch (NSException *exception) {
            return 30;
        }
    }else if([self.lottery isEqualToString:@"PL3"] || [self.lottery isEqualToString:@"PL5"]){
        @try {
            return [self getPLCellHeight];
        } @catch (NSException *exception) {
            return 30;
        }
        
    }else{
        return 160;
    
    }
}


-(CGFloat)getPLCellHeight{
    
    NSArray * betcontent = [Utility objFromJson: self.betContent ];
    float Theight = 40 + 0.5;
    if (self.betContent.length == 0) {
        return 50;
    }
    for (NSDictionary *betDic in betcontent) {
        
        
        NSString *betStr = [self getPlNumberStr:betDic];
        
        
        CGFloat height = [betStr boundingRectWithSize:CGSizeMake(KscreenWidth - 100, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.height;
        
        
        if (betStr == nil) {
            return 50;
        }
        
        height = height > 35?height:35;
        
        Theight += height + 0.5;
    }
    
    return Theight;
}


-(NSString *)getPlNumberStr:(NSDictionary *)itemDic{
    
    
    NSString *itemStr = @"";
    
    if ([@"Group3" isEqualToString:itemDic[@"playType"]] || [@"Group6" isEqualToString:itemDic[@"playType"]]) {
        NSArray *groupList = itemDic[@"groupList"];
        itemStr = [groupList componentsJoinedByString:@","];
        
    }
    if ([@"P3Direct" isEqualToString:itemDic[@"playType"]]) {
        NSArray *area1List = itemDic[@"area3List"];
        NSArray *area2List = itemDic[@"area4List"];
        NSArray *area3List = itemDic[@"area5List"];
        itemStr = [NSString stringWithFormat:@"%@|%@|%@",[area1List componentsJoinedByString:@","],[area2List componentsJoinedByString:@","],[area3List componentsJoinedByString:@","]];
        
        
    }
    if ([@"P5Direct" isEqualToString:itemDic[@"playType"]]) {
        NSArray *area1List = itemDic[@"area1List"];
        NSArray *area2List = itemDic[@"area2List"];
        NSArray *area3List = itemDic[@"area3List"];
        NSArray *area4List = itemDic[@"area4List"];
        NSArray *area5List = itemDic[@"area5List"];
        itemStr = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",[area1List componentsJoinedByString:@","],[area2List componentsJoinedByString:@","],[area3List componentsJoinedByString:@","],[area4List componentsJoinedByString:@","],[area5List componentsJoinedByString:@","]];
        
    }
    return  itemStr;
    
}


-(CGFloat)getX115CellHeight{
    
    NSArray * betcontent = [Utility objFromJson: self.betContent ];
    float Theight = 40 + 0.5;
    if (self.betContent.length == 0) {
        return 50;
    }
    for (NSDictionary *betDic in betcontent) {
        
        
        NSArray *betRows = betDic[@"betRows"];
        
        
        if (betRows == nil || betRows.count == 0) {
            return 50;
        }
        
        float height = betRows.count == 1?35.0:35;
        
        Theight += height + 0.5;
    }
    
    return Theight;
}



-(CGFloat)getJCLQCellHeight{
  
    float height = 50 + 30;
    
    
    NSDictionary  *betcontent =[Utility objFromJson:self.betContent];
    
    if (![betcontent isKindOfClass:[NSDictionary class]]||self.betContent.length == 0) {
        return 60;
    }
    
    NSArray *matchs = betcontent[@"betMatches"];
    for (NSDictionary *dic in matchs) {
        NSArray *betPlayTypes =dic[@"betPlayTypes"];
        
        NSInteger num = 0;
        for (NSDictionary *dic in betPlayTypes) {
            NSArray *options = dic[@"options"];
            num += options.count;
        }
        if (num == 1) {
            height += 30.5;
        }else{
            height += (num *20 +0.5);
        }
    }
    if ( [self.schemeType isEqualToString:@"BUY_SELF"]) {
    
    }else{
        if ([[betcontent allKeys]containsObject:@"passTypes"]) {
            NSArray *passTypes =  (NSArray*)betcontent[@"passTypes"];
            
            if (passTypes.count %7 == 0) {
                height += passTypes.count/7 *20;
            }else{
                height += (passTypes.count/7 + 1) *18;
            }
        }else{
            height += 20;
        }
    }
    return height;
}


-(CGFloat)getDLTCellHeight{
    NSArray * betcontent = [Utility objFromJson: self.betContent ];
    
    float height = 40;
    if (self.betContent.length == 0) {
        return 50;
    }
    for (NSDictionary *betDic in betcontent) {
        //加载红区数字
        NSArray *redList = betDic[@"redList"];
        if (redList == nil || redList.count == 0) {
           
            return 50;
        }
        NSArray *redDanList = betDic[@"redDanList"];
        NSArray *blueList = betDic[@"blueList"];
        NSArray *blueDanList = betDic[@"blueDanList"];
        NSString *redTitle = [self titleNumber:redList andDan:redDanList];
        NSString *blueTitle = [self titleNumber:blueList andDan:blueDanList];
        float singHeight = [self getHeightredTitle:redTitle blueTitle:blueTitle];
        height += singHeight + 0.5;
    }
    return height + 0.5;
}
-(float)getHeightredTitle:(NSString*)redTitle blueTitle:(NSString *)blueTitle{
    float redHeight = [redTitle boundingRectWithSize:CGSizeMake(80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:13]} context:nil].size.height;
    
    float blueHeight = [blueTitle boundingRectWithSize:CGSizeMake(300 - 80 - 150 , 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{@"UIFont":[UIFont systemFontOfSize:13]} context:nil].size.height;
    
    if (redHeight> blueHeight) {
        
        return redHeight >35?redHeight:35;
        
    }else{
        
        return blueHeight>35?blueHeight:35;
        
    }
}

-(NSString *)titleNumber:(NSArray*)tuoArray andDan:(NSArray *)danArray{
    
    NSMutableString *title = [[NSMutableString alloc]initWithCapacity:0];
    if ([self isEnble:danArray]) {
        [title appendString:[NSString stringWithFormat:@"[胆：%@]\n",[danArray componentsJoinedByString:@","]]];
    }
    if ([self isEnble:tuoArray]) {
        [title appendString:[NSString stringWithFormat:@"%@",[tuoArray componentsJoinedByString:@","]]];
    }
    
    
    return title;
}

-(BOOL)isEnble:(NSArray *)array{
    
    if (array.count != 0 && array != nil) {
        return YES;
    }else{
        
        return NO;
    }
}

-(NSString*)getSecretTypes{
    
    NSDictionary *schemeTypes  = @{@"FULL_PUBLIC":@"完全公开",@"DRAWN_PUBLIC":@"开奖后公开",@"FOLLOW_PUBLIC":@"参与者公开",@"FULL_SECRET":@"保密"};
    return schemeTypes[self.secretType];
}

-(BOOL)isShowBetContent{

    
    if (self.betContent == nil || self.betContent.length == 0) {
        return NO;
    }else{
    
        return YES;
    }
//    NSString *cardCode =[NSString stringWithFormat:@"%@",[GlobalInstance instance].curUser.username];
//    if ([self.cardCode isEqualToString:cardCode]) {
//        return YES;
//    }else if ([self.secretType isEqualToString:@"FULL_SECRET"]) {
//        return NO;
//    }else if([self.secretType isEqualToString:@"DRAWN_PUBLIC"]){
//    
//        if ([self.winningStatus isEqualToString:@"已开奖"]||[self.winningStatus isEqualToString:@"已派奖"]) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }else if([self.secretType isEqualToString:@"FOLLOW_PUBLIC"]){
//        for (TogetherSub*sub in self.trTogetherSubs) {
//            if ([sub.cardCode isEqualToString:cardCode]) {
//                return YES;
//            }
//        }
//        return NO;
//    }else{
//        return YES;
//    }
}

-(NSString *)getSchemeState{

    NSString *state;
    if ([self.schemeStatus isEqualToString:@"INIT"]) {
        state = @"待支付";
    }else if([self.schemeStatus isEqualToString:@"CANCEL"]){
        if ([self.ticketStatus isEqualToString:@"TICKET_FAILED"]) {
            
            state = @"方案失败";
        }else{
            
            state = @"方案失败";
        }
    }else if([self.schemeStatus isEqualToString:@"REPEAL"]){
            state = @"方案撤销";
    }else{
        if ([self.schemeType isEqualToString:@"BUY_TOGETHER"]) {
            if ([self.schemeStatus isEqualToString:@"UN_FULL"]) {
                state = self.trSchemeStatus;
            }else{
                if (![self.trTicketStatus isEqualToString:@"出票成功"]) {
                    if ([self.trTicketStatus isEqualToString:@"委托中"]||[self.trTicketStatus isEqualToString:@"委托成功"]) {
                        state = @"出票中";
                    }else{
                        
                        state = self.trTicketStatus;
                    }
                    
                }else{
                    
                    if ([self.trWinningStatus isEqualToString:@"已派奖"] || [self.trWinningStatus isEqualToString:@"已开奖"]) {
                        if ([self.won boolValue] == YES) {
                            state = @"已中奖";
                        }else{
                            
                            state = @"未中奖";
                        }
                    }else{
                        state = @"待开奖";
                    }
                    
                }
            }
        }else{
            if (![self.trTicketStatus isEqualToString:@"出票成功"]) {
                if ([self.trTicketStatus isEqualToString:@"委托中"]||[self.trTicketStatus isEqualToString:@"委托成功"] ) {
                    state = @"出票中";
                }else{
                    
                    state = self.trTicketStatus;
                }
            }else{
                
                if ([self.trWinningStatus isEqualToString:@"已派奖"] || [self.trWinningStatus isEqualToString:@"已开奖"]) {
                    if ([self.won boolValue]  == YES) {
                        state = @"已中奖";
                    }else{
                        
                        state = @"未中奖";
                    }
                }else{
                    state = @"待开奖";
                }
                
            }
        }
        
    }
    return state;

}

@end
