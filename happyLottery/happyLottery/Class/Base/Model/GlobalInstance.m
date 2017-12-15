//
//  GlobalInstance.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GlobalInstance.h"

static GlobalInstance *instance = NULL;

@interface GlobalInstance()

@end

@implementation GlobalInstance

+ (GlobalInstance *) instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalInstance alloc]init];
    });
    return instance;
}

- (id)init{
    if (instance == NULL) {
        self = [super init];
        instance = self;
    }
    return instance;
}

@end
