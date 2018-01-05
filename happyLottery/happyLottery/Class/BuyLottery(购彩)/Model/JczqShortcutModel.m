//
//  JczqShortcutDto.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "JczqShortcutModel.h"

@implementation JczqShortcutModel

-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    if ([self.spfSingle boolValue] == YES) {
        self.jcPairingMatchDto = nil;
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{

    if ([key isEqualToString:@"jcPairingMatchDto"]) {
        JcPairingMatchModel * model = [[JcPairingMatchModel alloc]initWith:value];
        self.jcPairingMatchDto = model;
    }else if([key isEqualToString:@"forecastOptions"]){
        NSArray *items = value;
        NSMutableArray *marray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *dic in items) {
            JcForecastOptions *mode = [[JcForecastOptions alloc]initWith:dic];
            [marray addObject:mode];
        }
        self.forecastOptions = marray;
    }else{
        NSString *strValue = [NSString stringWithFormat:@"%@",value];
        
        [super setValue:strValue forKey:key];
    }
   
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}
-(instancetype)copyNojcforecastOptions{
    JczqShortcutModel * model = [[JczqShortcutModel alloc]init];
    model.guestName = self.guestName;
    model. dealLine=self. dealLine;
    model.homeName = self.homeName;
    model.leagueName = self.leagueName;
    model.lineId = self.lineId;
    model.matchKey = self.matchKey;
    model.predictIndex = self.predictIndex;
    model.spfSingle = self.spfSingle;
    model.hotspot = self.hotspot;
    model.jcPairingMatchDto = self.jcPairingMatchDto;
    return model;
    
}



@end
