//
//  DLTChaseSchemeDetail.h
//  happyLottery
//
//  Created by 王博 on 2018/3/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface DLTChaseSchemeDetail : BaseModel
@property(nonatomic,copy)NSString * palyType;
@property(nonatomic,copy)NSString * chaseSchemeNo;
@property(nonatomic,copy)NSString * totalCatch;
@property(nonatomic,copy)NSString * winStopStatus;
@property(nonatomic,copy)NSString * catchContent;
@property(nonatomic,copy)NSString * batType;
@property(nonatomic,copy)NSString * lotteryName;
@property(nonatomic,copy)NSString * beginIssue;
@property(nonatomic,copy)NSString * sumIssue;
@property(nonatomic,copy)NSString * tempList;
@property(nonatomic,copy)NSString * createTime;
@end

@interface DLTChaseOrderDetail :BaseModel



@end

