//
//  JczqShortcutDto.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JcPairingMatchModel.h"
#import "JcForecastOptions.h"


@interface JczqShortcutModel : NSObject
@property(nonatomic,strong)NSString * guestName,
*dealLine,
*homeName,
*leagueName,
*lineId,
*matchKey,
*predictIndex,
*spfSingle,
* guestImageUrl,
* h5Url,
* homeImageUrl,
* matchResult,
* guestRank,
* lottery,
* status,
* matchDate,
* cardCode,
* homeRank,
* hit,
* startTime,
*hotspot;
@property(assign,nonatomic)BOOL isCollect;
@property(nonatomic,strong)NSMutableArray<JcForecastOptions*> * predict;
@property(nonatomic,strong)NSMutableArray<JcForecastOptions*> *forecastOptions;
@property(nonatomic,strong)JcPairingMatchModel * jcPairingMatchDto;

-(id)initWith:(NSDictionary*)dic;

-(instancetype)copyNojcforecastOptions;

@end
