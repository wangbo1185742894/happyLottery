//
//  LotteryXHProfile.h
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {

     BetCalculationTypeMixture = 500,  //   排列组合，类似大乐透， 11选5的任选二，
     BetCalculationTypeFixedBallKind,    //  固定球种选择，类似11选5的  任选胆拖系列
}BetCalculationType;


@interface LotteryXHProfile : NSObject

@property (nonatomic, strong) NSString *profileID;
@property(nonatomic,strong)NSString *playType;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *percentage;
@property (nonatomic, strong) NSString *betCalculation;
@property (nonatomic, strong) NSString *betMinNum;          //
@property (nonatomic, strong) NSString *randomTotalNum;     // 随机数综合

@property float percent;
//if YES, same number could be selected between different XHSection
@property (nonatomic, strong) NSNumber *couldRepeat;        // 注数计算是否可重复
@property (nonatomic, strong) NSNumber *couldRepeatSelect;  // 是否可重复选择
@property (nonatomic, strong) NSArray *details;


@end
