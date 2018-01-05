//
//  BaseProfile.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface BaseProfile : BaseModel

@property(nonatomic,strong)NSString *ProfileID;
@property(nonatomic,strong)NSString *Desc;
@property(nonatomic,strong)NSString *Amount;
@property(nonatomic,strong)NSString *Title;

@end
