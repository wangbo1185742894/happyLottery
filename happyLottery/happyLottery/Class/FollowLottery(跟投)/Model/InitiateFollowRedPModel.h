//
//  InitiateFollowRedPModel.h
//  happyLottery
//
//  Created by LYJ on 2018/9/13.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

typedef enum{
    
    NORMAL = 0, //普通红包
    RANDOM //随机红包
    
}RedPacketRandomType;

@interface InitiateFollowRedPModel : BaseModel

/** 发单方案号 */
@property(nonatomic,copy)NSString * schemeNo;

/** 发单人卡号 */
@property(nonatomic,copy)NSString * cardCode;

/** 总金额 */
@property(nonatomic,copy)NSString * amount;

/** 单个价格 */
@property(nonatomic,copy)NSString * univalent;

/** 红包个数 */
@property(nonatomic,copy)NSString * totalCount;

/** 红包类型 */
@property(nonatomic,assign)RedPacketRandomType randomType;


-(NSMutableDictionary*)submitParaDicScheme;

@end
