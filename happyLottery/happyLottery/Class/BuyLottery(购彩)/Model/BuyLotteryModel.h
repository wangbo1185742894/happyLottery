//
//  BuyLotteryModel.h
//  happyLottery
//
//  Created by LYJ on 2018/10/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface BuyLotteryModel : BaseModel

 /** 彩种 */
@property (nonatomic,copy) NSString *lotteryCode;

/** 彩种名称  */
@property (nonatomic,copy) NSString *lotteryName;

/**   是否开售 true 开售  */
@property (nonatomic,copy) NSString * sell;

/** 彩种说明  */
@property (nonatomic,copy) NSString *remark;

/** 彩种首页排序  */
@property (nonatomic,copy) NSString * rank;

/** 首页是否显示*/
@property (nonatomic,copy) NSString *showHome;

/** 彩种图片名称*/
@property (nonatomic,copy) NSString *lotteryImageName;

@end
