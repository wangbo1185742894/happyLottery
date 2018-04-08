//
//  JCLQTransaction.h
//  Lottery
//
//  Created by 王博 on 16/8/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCLQMatchModel.h"
#import "BaseTransaction.h"

typedef enum{
    JCLQGuanTypeDanGuan,
    JCLQGuanTypeGuoGuan
} JCLQGuanType;

//typedef enum {
//    JCLQPlayTypeHHTZ,
//    JCLQPlayTypeSF,
//    JCLQPlayTypeRFSF,
//    JCLQPlayTypeSFC,
//    JCLQPlayTypeDXF
//}JCLQPlayType;

@interface JCLQTransaction :BaseTransaction

@property (nonatomic , strong) NSMutableArray * selectItems;
@property(nonatomic,strong)NSMutableArray*matchSelectArray;

@property(nonatomic,assign)NSString *playType;

@property(nonatomic,assign)JCLQGuanType guanType;
@property(nonatomic,strong)JCZQProfile *curProfile;


@property (nonatomic , strong) NSString * beitou;
@property (nonatomic , strong) NSString * chuanFa;

//过关方式 zwl

@property(nonatomic,assign)float maxCount;
@property (nonatomic , strong) NSString * mostBounds;
@property (nonatomic , assign) NSInteger maxChuanNumber;
- (void)getBetCount;

- (NSMutableDictionary *)submitParamDic;

- (id )lottData;
- (NSInteger)betCost;

@end
