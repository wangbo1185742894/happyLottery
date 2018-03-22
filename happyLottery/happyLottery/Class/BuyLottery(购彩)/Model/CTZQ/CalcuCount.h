//
//  CalcuCount.h
//  CalculateCount
//
//  Created by 王博 on 16/3/8.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTZQMatch.h"

@interface CalcuCount : NSObject

+(NSInteger)calculateCount:(NSArray*)selectBetArray playType:(CTZQPlayType)type  andDanNumber:(NSArray*)dan;

@end
