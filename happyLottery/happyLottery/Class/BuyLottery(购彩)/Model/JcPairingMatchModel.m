//
//  jcPairingMatchDto.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "JcPairingMatchModel.h"

@implementation JcPairingMatchModel


-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if([key isEqualToString:@"options"]){
        NSArray *items = value;
        NSMutableArray *marray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary *dic in items) {
            JcPairingOptions *mode = [[JcPairingOptions alloc]initWith:dic];
            [marray addObject:mode];
        }
        self.options = marray;
    }else{
    
        NSString *strValue = [NSString stringWithFormat:@"%@",value];
        
        [super setValue:strValue forKey:key];
    }
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}

@end
