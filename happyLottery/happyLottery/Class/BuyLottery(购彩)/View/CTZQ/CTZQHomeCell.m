//
//  CTZQHomeCell.m
//  Lottery
//
//  Created by 王博 on 16/3/24.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQHomeCell.h"

@implementation CTZQHomeCell

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CTZQHomeCell" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

-(void)setTaget:(id)target action:(SEL)action{

    [self.btnBack addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

@end
