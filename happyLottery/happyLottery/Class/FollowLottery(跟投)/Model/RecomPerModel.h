//
//  RecomPerModel.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface RecomPerModel : BaseModel

@property(nonatomic,copy)NSString * personName;
@property(nonatomic,copy)NSString * personImageName;
@property(nonatomic,copy)NSString * personInfo;


-(id)initWithDic:(NSDictionary *)dic;

@end
