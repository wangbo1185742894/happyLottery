//
//  OptimizeItemModel.m
//  happyLottery
//
//  Created by 王博 on 2018/2/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "OptimizeItemModel.h"

@implementation OptimizeItemModel

-(void)setValue:(id)value forKey:(NSString *)key{
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    if ([key isEqualToString:@"bonusOptimizeSingleList"]) {
        NSArray * singleList = [Utility objFromJson:value];
        NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in singleList) {
            BounsOptimizeSingleModel *model = [[BounsOptimizeSingleModel alloc]initWith:itemDic];
            [itemList addObject:model];
        }
        self.bonusOptimizeSingleList = itemList;
    }else{
        [super setValue:strValue forKey:key];
    }
}
@end
