//
//  HomeYCModel.m
//  Lottery
//
//  Created by 王博 on 2017/10/24.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "HomeYCModel.h"

@implementation HomeYCModel

-(id)initWithDic:(NSDictionary *)dic{
    
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }else if([key isEqualToString:@"predict"]){
        NSArray *predicts = [Utility objFromJson:value];
        NSMutableArray *mPredicts = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in predicts) {
            JcForecastOptions *ops = [[JcForecastOptions alloc]initWith:itemDic];
            [mPredicts addObject:ops];
        }
        self.predict = mPredicts;
    }else{
        
        NSString *strValue = [NSString stringWithFormat:@"%@",value];
        
        [super setValue:strValue forKey:key];
    }
    
    
}
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    NSLog(@"@property(nonatomic,strong)NSString * %@",key);
    return;
}

-(JczqShortcutModel *)jCZQScoreZhiboToJcForecastOptions{
    JczqShortcutModel *hModel = [[JczqShortcutModel alloc]init];
    
    hModel.leagueName = self.leagueName;
    hModel.dealLine = self.dealLine;
    hModel.matchKey = self.matchKey;
    hModel.homeName = self.homeName;
    hModel.guestName = self.guestName;
    hModel.lineId = self.lineId;
    hModel.forecastOptions = (NSMutableArray *)self.predict;
    hModel.predictIndex  =self.predictIndex;
    hModel.hotspot = self.hotspot;
    hModel.spfSingle = self.spfSingle;
    
    hModel. guestImageUrl = self.guestImageUrl;
    hModel. h5Url = self.h5Url;
    
    hModel. homeImageUrl = self.homeImageUrl;
    hModel.matchResult = self.matchResult;
    
    
    hModel. guestRank = self.guestRank;
    hModel. lottery = self.lottery;
    
    hModel. matchDate = self.matchDate;
    
    hModel. homeRank = self.homeRank;
    hModel.hit = self.hit;
    hModel. startTime = self.startTime;
    hModel. hotspot = self.hotspot;
    return hModel;
    
}


@end
