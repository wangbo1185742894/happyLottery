//
//  OptimizeItemModel.h
//  happyLottery
//
//  Created by 王博 on 2018/2/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "BounsOptimizeSingleModel.h"

@interface OptimizeItemModel : BaseModel
@property(nonatomic,assign)NSInteger multiple;
@property(nonatomic,copy)NSString * forecastBonus;
@property(nonatomic,copy)NSString * passType;
@property(nonatomic,copy)NSArray<BounsOptimizeSingleModel *> * bonusOptimizeSingleList;
@end
