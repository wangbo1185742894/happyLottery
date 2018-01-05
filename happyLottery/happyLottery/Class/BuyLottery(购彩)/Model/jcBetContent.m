//
//  jcBetContent.m
//  Lottery
//
//  Created by onlymac on 2017/10/30.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "jcBetContent.h"

@implementation jcBetContent
-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"betPlayTypes"]) {
//        NSDictionary *dic = value[0];
//        self.options = [NSMutableArray arrayWithArray:dic[@"options"]];
//        self.playType = [NSString stringWithFormat:@"%@",dic[@"playType"]];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:value];
        self.betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic  in arr) {
            YCbetPlayTypes *model = [[YCbetPlayTypes alloc]initWith:dic];
            [self.betPlayTypes addObject:model];
        }
    }else{
        [super setValue:value forKey:key];
    }
   
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}
@end
