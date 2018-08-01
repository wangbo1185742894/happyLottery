//
//  JCZQTranscation.h
//  happyLottery
//
//  Created by 王博 on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JCZQProfile.h"
#import "JCZQMatchModel.h"
#import "BaseTransaction.h"
@class  BounsModelItem;
@interface JCZQTranscation : BaseTransaction


@property(assign,nonatomic)JCZQPlayType playType;
@property(nonatomic,strong)JCZQProfile *curProfile;

@property(nonatomic,strong)NSString *chuanFa;
@property(nonatomic,strong)NSString * beitou;


@property(nonatomic,strong)NSMutableArray *selectItems;

#pragma 投注内容

@property(nonatomic,strong)NSString * cardCode,*channelCode,*lottery,*issueNumber,*recFollowSchemeNo;

@property(nonatomic,assign)NSInteger multiple,chaseCountz,chaseCount;


@property(nonatomic,assign)NSInteger maxChuanNumber;

@property(nonatomic,strong)NSMutableArray <JCZQMatchModel *>*selectMatchArray;


@property(nonatomic,strong)NSString * mostBounds;
@property(nonatomic,strong)NSString * minBounds;

- (NSInteger)hhggHasBetMatchNumWithPlayCode:(NSString *)playCd;

-(NSArray *)getSelectItemAllGroup;

- (void)peilvJiSuanBy:(NSArray <BounsModelItem *>*)array;
- (void)updataBetCount;
@end
