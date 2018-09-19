//
//  LegWordModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface LegWordModel : BaseModel
@property(nonatomic,strong)NSString *  _id;
/** 小哥名称*/
@property(nonatomic,strong)NSString * legName;
/** 跑腿费 */
@property(nonatomic,strong)NSString * cost;
@property(nonatomic,assign)BOOL  isSelect;
@end

@interface LotteryShopDto : BaseModel
@property(nonatomic,strong)NSString * _id;
/** 门店名称*/
@property(nonatomic,strong)NSString * shopName;
@end
