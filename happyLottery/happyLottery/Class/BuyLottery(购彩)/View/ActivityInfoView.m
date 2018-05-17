//
//  ActivityInfoView.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ActivityInfoView.h"

@implementation ActivityInfoView

-(id)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        self  = [[[NSBundle mainBundle]loadNibNamed:@"ActivityInfoView" owner:nil options:nil ] lastObject];
    }
    return self;
}

-(void)setStartBtnTarget:(id)target andAction:(SEL)action{
    [self.btnStart addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end
