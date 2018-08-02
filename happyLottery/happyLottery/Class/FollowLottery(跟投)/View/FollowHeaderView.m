//
//  FollowHeaderView.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowHeaderView.h"

@interface FollowHeaderView()


@property (weak, nonatomic) IBOutlet UIImageView *imgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgDisLeft;

@end

@implementation FollowHeaderView

-(id)initWithFrame:(CGRect)frame{
    if(self  = [super initWithFrame:frame]){
        self  = [[[NSBundle mainBundle] loadNibNamed:@"FollowHeaderView" owner:nil options:nil] lastObject];
    }
    return  self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    self.imgDisLeft.constant = self.btnGenDan.selected?self.btnGenDan.mj_x:self.btnNotice.mj_x;
    self.btnGenDan.titleLabel.font = self.btnGenDan.selected?[UIFont boldSystemFontOfSize:14.0]:[UIFont systemFontOfSize:14.0];
    self.btnNotice.titleLabel.font = self.btnNotice.selected?[UIFont boldSystemFontOfSize:14.0]:[UIFont systemFontOfSize:14.0];
    [super setFrame:frame];
}


- (IBAction)actionGenDan:(UIButton *)sender {
    self.btnGenDan.selected = NO;
    self.btnNotice.selected = NO;
    self.imgDisLeft.constant = sender.mj_x;
    [UIView animateWithDuration:0.5 animations:^{
        [self.imgBottom.superview layoutIfNeeded];
    }];
    sender.selected = YES;
    self.btnGenDan.titleLabel.font = self.btnGenDan.selected?[UIFont boldSystemFontOfSize:14.0]:[UIFont systemFontOfSize:14.0];
    self.btnNotice.titleLabel.font = self.btnNotice.selected?[UIFont boldSystemFontOfSize:14.0]:[UIFont systemFontOfSize:14.0];
    if (sender == self.btnGenDan) {
        [self.delegate actionToGD];
    } else {
        [self.delegate actionToNotice];
    }
}

@end
