//
//  YinLanPayManage.m
//  Lottery
//
//  Created by Yang on 15/9/7.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "YinLanPayManage.h"
#define TNModel  @"00"

@implementation YinLanPayManage

- (void) yanlianPay:(NSString *)tn viewController:(UIViewController *)vc{
    [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"wxe640eb18da420c3b" mode:TNModel viewController:vc];
}

@end
