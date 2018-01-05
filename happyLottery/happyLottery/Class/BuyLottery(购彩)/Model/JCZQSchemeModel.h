//
//  JCZQSchemeModel.h
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface JCZQSchemeItem : BaseModel

@property(nonatomic,copy)NSString * betContent;
@property(nonatomic,copy)NSString * betCost;
@property(nonatomic,copy)NSString * units;
@property(nonatomic,copy)NSString * multiple;
@property(nonatomic,copy)NSString * issueNumber;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * lottery;
@property(nonatomic,copy)NSString * costType;
@property(nonatomic,copy)NSString * winningStatus;
@property(nonatomic,copy)NSString * ticketStatus;
@property(nonatomic,copy)NSString * schemeNO;
@property(nonatomic,copy)NSString * won;
@property(nonatomic,copy)NSString * lotteryIcon;
@end

@interface JCZQSchemeModel : BaseModel
@property(nonatomic,copy)NSString * currPage;
@property(nonatomic,copy)NSArray <JCZQSchemeItem *> * list;
@property(nonatomic,copy)NSString * pageSize;
@property(nonatomic,copy)NSString * totalCount;
@property(nonatomic,copy)NSString * totalPage;
@end


