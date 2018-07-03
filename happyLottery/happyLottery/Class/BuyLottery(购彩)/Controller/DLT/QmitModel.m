//
//  QmitModel.m
//  Lottery
//
//  Created by only on 16/11/10.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "QmitModel.h"

@implementation QmitModel

-(id)initWith:(NSDictionary*)dic{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        _isSelect = @"0";
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{

//    value = [NSString stringWithFormat:@"%@",value];
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"id"]) {
        self.ID = strValue;
    }else if([key isEqualToString:@"ltype"]){
        self.ltype = [NSString stringWithFormat:@"%ld",[value integerValue]-1];
    }else{
        
        [super setValue:strValue forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end
