//
//  FeedBackHistory.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedBackHistory.h"

@implementation FeedBackHistory
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        key = @"_id";
    }if ([key isEqualToString:@"version"]) {
        key = @"_version";
    }
    [super setValue:value forKey:key];
}
@end
