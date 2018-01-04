//
//  JcPairingOptions.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "JcPairingOptions.h"

@implementation JcPairingOptions
-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    //    value = [NSString stringWithFormat:@"%@",value];
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    
    [super setValue:strValue forKey:key];
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"* %@,",key);
}
@end
