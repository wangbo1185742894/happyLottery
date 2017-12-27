//
//  RedPacket.m
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "RedPacket.h"

@implementation RedPacket

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }
    [super setValue:value forKey:key];
}

@end
