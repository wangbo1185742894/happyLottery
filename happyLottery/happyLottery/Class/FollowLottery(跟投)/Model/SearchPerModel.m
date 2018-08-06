//
//  SearchPerModel.m
//  happyLottery
//
//  Created by LYJ on 2018/8/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SearchPerModel.h"

@implementation SearchPerModel

-(NSString *)nickName{
    if (_nickname == nil || _nickname.length == 0) {
        NSString *itemNmae  = [_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return  itemNmae;
    }else{
        return _nickname;
    }
}

@end
