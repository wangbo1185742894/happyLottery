//
//  OpenLotteryResultHeaderView.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OpenLotteryResultHeaderView.h"

@implementation OpenLotteryResultHeaderView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"OpenLotteryResultHeaderView" owner:nil options:nil] lastObject];
        
    }
    self.frame = frame;
    return self;

}

@end
