//
//  HomeYCModel.h
//  Lottery
//
//  Created by 王博 on 2017/10/24.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JczqShortcutModel.h"
@interface HomeYCModel : NSObject
-(id)initWithDic:(NSDictionary *)dic;


@property(nonatomic,strong)NSString * _id;
@property(nonatomic,strong)NSString * leagueName;
@property(nonatomic,strong)NSString * spfSingle;
@property(nonatomic,strong)NSArray<JcForecastOptions*> * predict;
@property(nonatomic,strong)NSString * dealLine;
@property(nonatomic,strong)NSString * homeName;
@property(nonatomic,strong)NSString * matchKey;
@property(nonatomic,strong)NSString * homeRank;
@property(nonatomic,strong)NSString * lineId;
@property(nonatomic,strong)NSString * guestRank;
@property(nonatomic,strong)NSString * guestName;
@property(nonatomic,strong)NSString * h5Url;
@property(nonatomic,strong)NSString * hotspot;
@property(nonatomic,strong)NSString * lottery;
@property(nonatomic,strong)NSString * matchResult;
@property(nonatomic,strong)NSString * hit;
@property(nonatomic,strong)NSString * matchDate;
@property(nonatomic,strong)NSString * predictIndex;
@property(nonatomic,strong)NSString * startTime;

@property(nonatomic,strong)NSString * guestImageUrl;
@property(nonatomic,strong)NSString * homeImageUrl;

@property(nonatomic,assign)BOOL isCollect;
-(JczqShortcutModel *)jCZQScoreZhiboToJcForecastOptions;
@end
