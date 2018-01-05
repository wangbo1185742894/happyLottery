//
//  BaseTransaction.m
//  Lottery
//
//  Created by 王博 on 17/4/12.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseTransaction.h"



@implementation BaseTransaction

-(NSDictionary*)X115PlayType{

    return @{@"201":@"TopOne",
             @"202":@"EitherTwo",
             @"203":@"EitherThree",
             @"204":@"EitherFour",
             @"205":@"EitherFive",
             @"206":@"EitherSix",
             @"207":@"EitherSenven",
             @"208":@"EitherEight",
             @"212":@"EitherTwoTowed",
             @"213":@"EitherThreeTowed",
             @"214":@"EitherFourTowed",
             @"215":@"EitherFiveTowed",
             @"216":@"EitherSixTowed",
             @"217":@"EitherSenvenTowed",
             @"220":@"TopTwoDirect",
             @"230":@"TopThreeDirect",
             @"221":@"TopTwoGroup",
             @"231":@"TopThreeGroup",
             @"222":@"TopTwoGroupTowed",
             @"232":@"TopThreeGroupTowed",
             @"229":@"TopTwoDirectDouble",
             @"239":@"TopThreeDirectDouble",
             @"502":@"LeTwo",
             @"503":@"LeThree",
             @"504":@"LeFour",
             @"505":@"LeFive"

             };
}

-(NSString *)getLotteryNumWithEnname:(NSString *)name{

    for (NSString *num in [[self X115PlayType] allKeys]) {
        if ([[[self X115PlayType] objectForKey:num ]isEqualToString:name]) {
            return num;
        }
    }
    return nil;
}




-(NSArray*)schemeTypes{

    return  @[@"BUY_SELF",@"BUY_TOGETHER",@"BUY_CHASE",@"BUY_REC"];
}
///** 完全公共 */
//FULL_PUBLIC("完全公开"),
//
///** 开奖后公告 */
//DRAWN_PUBLIC("开奖后公开"),
//
///** 完全保密 */
//FULL_SECRET("完全保密"),
//
///** 跟单人公开 */
//FOLLOW_PUBLIC("跟单人公开");
-(NSArray *)secretTypes{
    return @[@"FULL_PUBLIC",@"DRAWN_PUBLIC",@"FOLLOW_PUBLIC",@"FULL_SECRET"];
}


-(NSString*)betSource{

    return @"2";
}

@end
