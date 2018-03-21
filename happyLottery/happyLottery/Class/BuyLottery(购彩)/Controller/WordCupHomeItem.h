//
//  WordCupHomeItem.h
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface WordCupHomeItem : BaseModel
@property(nonatomic,copy)NSString * guanKey;
@property(nonatomic,copy)NSString * yaKey;
@property(nonatomic,copy)NSString * imgGuanKey;
@property(nonatomic,copy)NSString * imgYaKey;
@property(nonatomic,copy)NSString * groupIndex;
@property(nonatomic,copy)NSString * _id;
@property(nonatomic,copy)NSString * probability;
@property(nonatomic,copy)NSString * odds;
@property(nonatomic,copy)NSString * clash;//队名
@property(nonatomic,copy)NSString * indexNumber;
@property(nonatomic,copy)NSString * sellStatus;
@property(nonatomic,copy)NSString * createTime;

@property(nonatomic,assign)BOOL isSelect;

-(id)initWithDic:(NSDictionary *)dic;

@end
