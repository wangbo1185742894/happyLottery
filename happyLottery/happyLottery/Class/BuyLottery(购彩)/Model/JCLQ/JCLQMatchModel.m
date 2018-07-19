//
//  JCLQMatchModel.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQMatchModel.h"

@implementation JCLQMatchModel

-(id)initWithDic:(NSDictionary *)dic{

    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.SFSelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
        
        self.RFSFSelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
        self.SFCSelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];
        self.DXFSelectMatch = [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
        self.SFOddArray = [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
        self.RFSFOddArray= [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
        self.SFCOddArray= [[NSMutableArray alloc]initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];
        self.DXFSOddArray= [[NSMutableArray alloc]initWithArray:@[@"0",@"0"]];
    }
    return self;

}

-(void)setValue:(id)value forKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }else{
    
         [super setValue:value forKey:key];
    }
   

}
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    NSLog(@"no key :%@",key);
    return;
}

-(NSInteger)sumSelectPlayType:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *str  in array) {
        num = num+ [str integerValue];
    }
    return num;
}

-(NSDictionary *)getJCZQTitle{
    return  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JCLQCode" ofType:@"plist"]];
}

-(NSString *)getTouzhuAppearTitleByTypeNoSp:(NSString *)type{
    
    NSDictionary *titleDic = [self getJCZQTitle][type];
    NSString *title;
    @try {
        if ([type isEqualToString:@"SF"]) {
            title = [self getTitleForm:titleDic andSp:self.SFOddArray andSelectArray:self.SFSelectMatch andIndex:100];
        }else if ([type isEqualToString:@"RFSF"]) {
            title = [self getTitleForm:titleDic andSp:self.RFSFOddArray andSelectArray:self.RFSFSelectMatch andIndex:200];
        }else if ([type isEqualToString:@"DXF"]) {
            title = [self getTitleForm:titleDic andSp:self.DXFSOddArray andSelectArray:self.DXFSelectMatch andIndex:300];
        }else if ([type isEqualToString:@"SFC"]) {
            title = [self getTitleForm:titleDic andSp:self.SFCOddArray andSelectArray:self.SFCSelectMatch andIndex:400];
        }
    } @catch (NSException *exception) {
        title = @"";
    }
    
    return title;
    
}


-(NSMutableString *)getJCLQTitleForm:(NSArray *)titleDic andSp:(NSArray *)spArray andSelectArray:(NSArray *)selectArray andIndex:(NSInteger )baseIndex{
    NSMutableString *tit = [NSMutableString string];
    if (spArray != nil) {
        NSMutableString *tit = [NSMutableString string];
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i] integerValue] == 1) {
                [tit appendString:[NSString stringWithFormat:@"%@%@,",titleDic[i][@"appear"],spArray[i]]];
            }
        }
    }else{
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i ] integerValue]==  1) {
                
                [tit appendString:[NSString stringWithFormat:@"%@,",titleDic[i][@"appear"]]];
            }
        }
    }
    return tit;
}

-(NSMutableString *)getTitleForm:(NSArray *)titleDic andSp:(NSArray *)spArray andSelectArray:(NSArray *)selectArray andIndex:(NSInteger )baseIndex{
    NSMutableString *tit = [NSMutableString string];
    if (spArray != nil) {
        
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i] integerValue] == 1) {
                [tit appendString:[NSString stringWithFormat:@"%@ %@,",titleDic[i][@"appear"],spArray[i]]];
            }
        }
    }else{
        for (int i = 0; i < selectArray .count; i ++ ) {
            if ([selectArray[i ] integerValue]==  1) {
                
                [tit appendString:[NSString stringWithFormat:@"%@,",titleDic[i][@"appear"]]];
            }
        }
    }
    return tit;
}
-(CGFloat)getHeight{
    float curY = 8;
    NSString *titleSelect;
    if ([self getTouzhuAppearTitleByTypeNoSp:@"SF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"SF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"RFSF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"RFSF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"DXF"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"DXF"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
    if ([self getTouzhuAppearTitleByTypeNoSp:@"SFC"] .length != 0) {
        curY += [[self getTouzhuAppearTitleByTypeNoSp:@"SFC"] boundingRectWithSize:CGSizeMake(KscreenWidth - 140, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
    }
 
    return curY + 10;
}


@end
