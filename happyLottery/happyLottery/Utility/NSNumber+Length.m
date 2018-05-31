//
//  NSMutableParagraphStyle+Length.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "NSNumber+Length.h"

@implementation NSNumber (Length)
//解决服务端犯神经 一会传字符型  一会传number型
-(NSInteger)length{
    NSString *item = [NSString stringWithFormat:@"%@",self];
    return item.length;
}

@end
