

//
//  ChongZhiRulePopView.m
//  Lottery
//
//  Created by onlymac on 2017/9/27.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "ChongZhiRulePopView.h"

@implementation ChongZhiRulePopView

-(id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ChongZhiRulePopView" owner:nil options:nil ] lastObject];
    }
    self.frame = frame;
    return self;
}

- (IBAction)actionClose:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)actionRule:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(showRuleBtnPage)]){
        [self removeFromSuperview];
        [self.delegate showRuleBtnPage];
    }
}


@end
