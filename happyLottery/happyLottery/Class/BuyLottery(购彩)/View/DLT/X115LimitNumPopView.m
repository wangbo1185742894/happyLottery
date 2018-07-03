//
//  X115LimitNumPopView.m
//  Lottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "X115LimitNumPopView.h"

@implementation X115LimitNumPopView

-(id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"X115LimitNumPopView" owner:nil options:nil
                 ] lastObject];
    }
    self.frame = frame;
    return self;
}

-(void)setLabLimitInfoText:(NSString *)text{
    if ([text isEqualToString:@"DLT"]) {
        self.labLimitInfo.hidden = YES;
        self.labDltLimitInfo.hidden = NO;
    }else{
        self.labLimitInfo.hidden = NO;
        self.labDltLimitInfo.hidden = YES;
    }
    
}

- (IBAction)actionGoonBuy:(id)sender {
    [self.delegate goonBuy];
    [self removeFromSuperview];
}


@end
