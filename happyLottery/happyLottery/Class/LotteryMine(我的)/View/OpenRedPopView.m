//
//  OpenRedPopView.m
//  Lottery
//
//  Created by 王博 on 2017/7/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "OpenRedPopView.h"

@implementation OpenRedPopView

-(id)initWithFrame:(CGRect)frame{

    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OpenRedPopView" owner:nil options:nil] lastObject];
    }
    self.viewContent.layer.cornerRadius = 10;
    self
    .viewContent.layer.masksToBounds = YES;
    self.frame  = frame;
    return self;
}
- (IBAction)actinoTobuy:(id)sender {
    
    [self.delegate openPopToBuy];
}
- (IBAction)actionClose:(UIButton *)sender {
    
    [self removeFromSuperview];
    
}
- (IBAction)actionLookCaijin:(id)sender {
    
    [self.delegate openPopToLook];
}



@end
