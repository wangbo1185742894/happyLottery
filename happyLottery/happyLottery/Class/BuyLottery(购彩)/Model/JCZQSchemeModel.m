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
@end
