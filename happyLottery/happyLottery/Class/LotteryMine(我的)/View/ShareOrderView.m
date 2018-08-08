//
//  DeleteOrderView.m
//  happyLottery
//
//  Created by LYJ on 2018/7/6.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ShareOrderView.h"


@implementation ShareOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ShareOrderView" owner:nil options:nil]lastObject];
    }
    self.frame = frame;
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.62);
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 12;
    return self;
}

- (IBAction)actionToClose:(id)sender {
    self.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@1  forKey:KshareOrderIntroduce];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
