//
//  JCZQSubCellBqc.m
//  happyLottery
//
//  Created by 王博 on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQSubCellBqc.h"

@implementation JCZQSubCellBqc

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self=  [[[NSBundle mainBundle] loadNibNamed:@"JCZQSubCellBqc" owner:nil options:nil] lastObject];
    }
    return self;
}

@end
