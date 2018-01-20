//
//  VersionUpdatingPopView.m
//  Lottery
//
//  Created by onlymac on 2017/9/30.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "VersionUpdatingPopView.h"
#import "AppDelegate.h"

@implementation VersionUpdatingPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"VersionUpdatingPopView" owner:nil options:nil]lastObject];
    }
    self.frame = frame;
    return self;
}
- (IBAction)actionLijigenxin:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lijigenxin)]) {
        [self.delegate lijigenxin];
    }
    
}
- (IBAction)actionGuanbi:(UIButton *)sender {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.versionFlag = true;
    [self removeFromSuperview];
}

@end
