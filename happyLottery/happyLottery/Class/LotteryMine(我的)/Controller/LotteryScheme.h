//
//  LotteryScheme.h
//  Lottery
//
//  Created by 王博 on 17/4/24.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryScheme : NSObject

@property(nonatomic,strong)NSString
* sysBaodiCopies,
* trOpenResult,
* sysBaodiCost,
* baodiCost,
* baodiCopies,
* trDisplay,
* allSchedule,
* ticketUnit,
* putOff,
* ticketStatus,
* followCount,
* minSubCost,
* surplusCopies,
* lottery,
* betContent,
* schemeNO,
* trTicketStatus,
* secretType,
* ticketTime,
* issueNumber,
* betSource,
* sponsorCost,
* memberName,
* deadLine,
* subCopies,
* sysBaodiTurnCopies,
* version,
* sysBaodiRefCopies,
* sponsorCopies,
* cardCode,
* printCount,
* schedule,
* ticketCount,
* trSchemeStatus,
* units,
* copies,
* schemeType,
* ticketCost,
* multiple,
* subscribedCost,
* trSchedule,
* won,
* winCount,
* schemeStatus,
* bonus,
* winningStatus,
* unitId,
* surplusCost,
* betCost,
* createTime,
* trSchemeType,
* baodiTurnCopies,
* trWinningStatus,
* trLotteryName,
* drawCount,
* baodiRefCopies,
* iconName,
* commissionRate,
* trCommission,
* _id,
* trTotalPrize,
* maxPrize,//(最大可中金额);
* attentCount;//(人气)

-(id)initWith:(NSDictionary*)dic;

-(CGFloat )getHeight;

-(NSString*)getSecretTypes;

-(NSString *)getSchemeState;

-(BOOL)isShowBetContent;
    
-(float)getInfoHeight;


@end
