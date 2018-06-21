//
//  AgentHeaderView.m
//  happyLottery
//
//  Created by LYJ on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AgentHeaderView.h"

@implementation AgentHeaderView

-(id)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        self  = [[[NSBundle mainBundle]loadNibNamed:@"AgentHeaderView" owner:nil options:nil] lastObject];
    }
    self.frame = frame;
    return self;
}


@end
