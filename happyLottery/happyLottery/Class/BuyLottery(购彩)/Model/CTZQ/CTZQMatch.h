//
//  CTZQMatch.h
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTZQBet;
typedef enum {
    CTZQPlayTypeRenjiu,
    CTZQPlayTypeShiSi
}CTZQPlayType;

@interface CTZQMatch : NSObject
@property (nonatomic , strong) NSString * id_;
@property (nonatomic , strong) NSString * guestName;    //萨克斯城竞技
@property (nonatomic , strong) NSString * homeName;     // 温哥华白帽
@property (nonatomic , strong) NSString * hot;          // 0
@property (nonatomic , strong) NSString * leagueColor;  // #AA1ABD
@property (nonatomic , strong) NSString * leagueName;   // 美国职业大联赛
@property (nonatomic , strong) NSString * matchNum;       // 周日 035
@property (nonatomic , strong) NSString * matchDate;        //  2015-07-15
@property (nonatomic , strong) NSString * matchKey;     //150712035
@property (nonatomic , strong) NSString * openFlag;     //  00000
@property (nonatomic , strong) NSString * startTime;    // 2015-07-13 00:45:00.0
@property (nonatomic , strong) NSString * status;       // 0
@property (nonatomic , strong) NSString * stopBuyTime;  // 2015-7-15 22：30：00.0
@property (nonatomic , strong) NSString * version;// 0

@property (nonatomic , strong) NSString * oddsSNum;
@property (nonatomic , strong) NSString * oddsPNum;
@property (nonatomic , strong) NSString * oddsFNum;
@property (nonatomic , strong) NSString * oddsS;
@property (nonatomic , strong) NSString * oddsP;
@property (nonatomic , strong) NSString * oddsF;

@property (nonatomic , strong) NSString * selectedS;
@property (nonatomic , strong) NSString * selectedP;
@property (nonatomic , strong) NSString * selectedF;

@property (nonatomic , strong) NSString * danTuo;

@property (nonatomic , strong) NSMutableAttributedString *oddsSStr;
@property (nonatomic , strong) NSMutableAttributedString *oddsPStr;
@property (nonatomic , strong) NSMutableAttributedString *oddsFStr;


- (void)matchInfoWith:(NSDictionary *)infoDic;
- (NSComparisonResult)compareMatch:(CTZQMatch *)match;
/*
 homeName; // 主队名称
 guestName; // 客队名称
 leagueName; // 联赛名称 、、欧洲杯预选赛
 matchKey; // 150614022
 status; // 赛事状态(0=正常,1=结束,2=取消)
 handicap; // 让球数
 leagueColor; // 联赛颜色
 id; // 150614022
 startTime; // 比赛开始时间
 matchDate; // 比赛日期
 stopBuyTime; // 比赛截止购买时间
 stopBuyTimes=0;	//比赛截止时间毫秒数，获取赛事后赋值
 hot; // 是否热门赛事
 openFlag; // 赛事支持玩法的二进制值
 */

@end
