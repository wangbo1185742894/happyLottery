
//
//  JCZQMatchModel.m
//  happyLottery
//
//  Created by 王博 on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQMatchModel.h"

@implementation JCZQMatchModel

-(id)initWith:(NSDictionary*)dic{
    if ([super initWith:dic]) {
        _SPF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
        _RQSPF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
        _JQS_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];
        _BQC_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        _BF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        _isSelect = NO;
    }
    return self;
}

-(void)cleanAll{
    _SPF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
    _RQSPF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0"]];
    _JQS_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];
    _BQC_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    _BF_SelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    _isSelect = NO;
    [self refreshPrize];
    
}

-(void)refreshPrize{
    [_matchBetArray removeAllObjects];
    _odd_SPF_Select = @"";
    _odd_RQSPF_Select = @"";
    _odd_BF_Select = @"";
    _odd_JQS_Select = @"";
    _odd_BQC_Select = @"";
    _odd_max_zuhe_HHGG = nil;
    _odd_SPF_Select_min = @"";
    _odd_RQSPF_Select_min = @"";
    _odd_BF_Select_min = @"";
    _odd_JQS_Select_min = @"";
    _odd_BQC_Select_min = @"";
    _odd_min_zuhe_HHGG = nil;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }
    [super setValue:value forKey:key];
    
}

-(BOOL )isSelect{
    if ([self selectItemNum] == 0) {
        return NO;
    }else{
        
        return YES;
    }
}

-(NSDictionary *)getJCZQTitle{
     return  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiCode" ofType:@"plist"]];
}

-(NSInteger)selectItemNum{
    NSInteger selectNum = 0;
    
    selectNum  += [self getSinglePlayTypeNum:self.SPF_SelectMatch];
    selectNum  += [self getSinglePlayTypeNum:self.RQSPF_SelectMatch];
    selectNum  += [self getSinglePlayTypeNum:self.BQC_SelectMatch];
    selectNum  += [self getSinglePlayTypeNum:self.JQS_SelectMatch];
    selectNum  += [self getSinglePlayTypeNum:self.BF_SelectMatch];
    
    return selectNum;
    
}

-(NSInteger)getSinglePlayTypeNum:(NSArray *)itemArray{
    NSInteger selectNum = 0;
    for (NSString *str in itemArray) {
        if ([str integerValue] == 1) {
            selectNum ++ ;
        }
    }
    return selectNum;
}

-(void)getNumberPlayTypeNum:(NSArray *)itemArray andBaseIndex:(NSInteger )baseIndex{
    
    for (int i = 0; i < itemArray.count; i ++) {
        if ([itemArray[i] integerValue] == 1) {
            [_matchBetArray addObject:@(baseIndex + i)];
        }
    }
}

-(NSString *)getTouzhuAppearTitleByTypeAndSp:(NSString *)type{
    NSDictionary *titleDic = [self getJCZQTitle][type];
    NSString *title;
    @try {
        if ([type isEqualToString:@"SPF"]) {
            title = [self getTitleForm:titleDic andSp:self.SPF_OddArray andSelectArray:self.SPF_SelectMatch andIndex:100];
        }else if ([type isEqualToString:@"RQSPF"]) {
            title = [self getTitleForm:titleDic andSp:self.RQSPF_OddArray andSelectArray:self.RQSPF_SelectMatch andIndex:200];
        }else if ([type isEqualToString:@"BF"]) {
            title = [self getTitleForm:titleDic andSp:self.BF_OddArray andSelectArray:self.BF_SelectMatch andIndex:300];
        }else if ([type isEqualToString:@"BQC"]) {
            title = [self getTitleForm:titleDic andSp:self.BQC_OddArray andSelectArray:self.BQC_SelectMatch andIndex:400];
        }else if ([type isEqualToString:@"JQS"]) {
            title = [self getTitleForm:titleDic andSp:self.JQS_OddArray andSelectArray:self.JQS_SelectMatch andIndex:500];
        }
    } @catch (NSException *exception) {
        title = @"";
    }
    return title;

}

-(NSMutableString *)getTitleForm:(NSDictionary *)titleDic andSp:(NSArray *)spArray andSelectArray:(NSArray *)selectArray andIndex:(NSInteger )baseIndex{
    NSMutableString *tit = [NSMutableString string];
    if (spArray != nil) {
        NSMutableString *tit = [NSMutableString string];
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i] integerValue] == 1) {
                  [tit appendString:[NSString stringWithFormat:@"%@%@,",titleDic[[NSString stringWithFormat:@"%ld",baseIndex + i]][@"appear"],spArray[i]]];
            }
        }
    }else{
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i ] integerValue]==  1) {
                 [tit appendString:[NSString stringWithFormat:@"%@,",titleDic[[NSString stringWithFormat:@"%ld",baseIndex + i]][@"appear"]]];
            }
           
        }
    }
    return tit;
    
    
}

-(NSString *)getTouzhuAppearTitleByTypeNoSp:(NSString *)type{
    
    NSDictionary *titleDic = [self getJCZQTitle][type];
    NSString *title;
    @try {
        if ([type isEqualToString:@"SPF"]) {
            title = [self getTitleForm:titleDic andSp:nil andSelectArray:self.SPF_SelectMatch andIndex:100];
        }else if ([type isEqualToString:@"RQSPF"]) {
            title = [self getTitleForm:titleDic andSp:nil andSelectArray:self.RQSPF_SelectMatch andIndex:200];
        }else if ([type isEqualToString:@"BF"]) {
            title = [self getTitleForm:titleDic andSp:nil andSelectArray:self.BF_SelectMatch andIndex:300];
        }else if ([type isEqualToString:@"BQC"]) {
            title = [self getTitleForm:titleDic andSp:nil andSelectArray:self.BQC_SelectMatch andIndex:400];
        }else if ([type isEqualToString:@"JQS"]) {
            title = [self getTitleForm:titleDic andSp:nil andSelectArray:self.JQS_SelectMatch andIndex:500];
        }
    } @catch (NSException *exception) {
        title = @"";
    }
   
    return title;
    
}

-(CGFloat)getHeight{
    float curY = 8;
    NSString *titleSelect;
    if ([self getTouzhuAppearTitleByTypeNoSp:@"SPF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"SPF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"RQSPF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"RQSPF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"BQC"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"BQC"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"JQS"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"JQS"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"BF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"BF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    return curY + 10;
}

-(NSMutableArray *)matchBetArray{
    if (_matchBetArray == nil) {
        _matchBetArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self getNumberPlayTypeNum:self.SPF_SelectMatch andBaseIndex:100];
    [self getNumberPlayTypeNum:self.RQSPF_SelectMatch andBaseIndex:200];
    [self getNumberPlayTypeNum:self.BF_SelectMatch andBaseIndex:300];
    [self getNumberPlayTypeNum:self.BQC_SelectMatch andBaseIndex:400];
    [self getNumberPlayTypeNum:self.JQS_SelectMatch andBaseIndex:500];
    return  _matchBetArray;
}

@end
