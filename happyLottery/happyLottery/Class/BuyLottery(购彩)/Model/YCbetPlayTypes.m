//
//  YCbetPlayTypes.m
//  Lottery
//
//  Created by onlymac on 2017/11/2.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YCbetPlayTypes.h"

@implementation YCbetPlayTypes
-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"options"]) {
        self.options = [NSMutableArray arrayWithArray:value];
        
    }else if ([key isEqualToString:@"playType"]){
        self.playType = [NSString stringWithFormat:@"%@",value];
    }else{
        [super setValue:value forKey:key];
    }
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}
@end
