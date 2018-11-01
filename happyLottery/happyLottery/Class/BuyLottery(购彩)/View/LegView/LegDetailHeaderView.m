//
//  LegDetailHeaderView.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegDetailHeaderView.h"

@interface LegDetailHeaderView()


@end

@implementation LegDetailHeaderView

-(id)initWithFrame:(CGRect)frame{
    if(self  = [super initWithFrame:frame]){
        self  = [[[NSBundle mainBundle] loadNibNamed:@"LegDetailHeaderView" owner:nil options:nil] lastObject];
    }
    return  self;
}


@end
