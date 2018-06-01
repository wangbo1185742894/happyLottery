//
//  MyAgentInfoModel.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyAgentInfoModel.h"

@implementation MyAgentTotalModel

@end

@implementation MyAgentInfoModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"agentTotalList"]) {
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *itemDic in value) {
            MyAgentTotalModel *mdoel = [[MyAgentTotalModel alloc]initWith:itemDic];
            [itemArray addObject:mdoel];
        }
        self.agentTotalList = itemArray;
        return;
    }
    [super  setValue:value forKey:key];
}
@end
