//
//  LotteryBetObj.h
//  Lottery
//
//  Created by Yang on 15/7/2.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryBetObj : NSObject
@property (nonatomic , strong) NSString * playType;

//大乐透 11选5
@property (nonatomic , strong) NSString * addtional;
@property (nonatomic , strong) NSString * bonus;
@property (nonatomic , strong) NSString * count;
@property (nonatomic , strong) NSString * lotteryType;
@property (nonatomic , strong) NSString * number;
@property (nonatomic , strong) NSString * playTypeName;



// 竞彩

@property (nonatomic , strong) NSString * passType;
@property (nonatomic , strong) NSString * passMode;
@property (nonatomic , strong) NSString * schemeCost;
@property (nonatomic , strong) NSString * units;
@property (nonatomic , strong) NSString * multiple;
@property (nonatomic , strong) NSArray * betCotent;
@property (nonatomic , strong) NSDictionary * wonDetail;
@property (nonatomic , strong) NSDictionary * lotteryNumDic;
@property  int  betCount;
@property (nonatomic , strong) NSDictionary * odds;
@property (nonatomic , strong) id numberDesc;

@property (nonatomic , strong) NSDictionary * dicForWinCodeDic;

- (NSString *)playTypeNameWithCode:(NSString *)codeString;
- (NSString *)xiaBiaoChaiFen:(NSString *)value matchKey:(NSString *)match;
- (NSString *)resultStringForWinInfo:(NSString *)code;
- (NSString *)lotteryResultString:(NSString *)matchKey playType:(NSString *)playType;
@end
