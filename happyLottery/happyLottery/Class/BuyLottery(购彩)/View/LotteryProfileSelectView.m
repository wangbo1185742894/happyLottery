//
//  LotteryProfileSelectView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LotteryProfileSelectView.h"

@interface LotteryProfileSelectView()
@property(nonatomic,strong)NSArray *lotteryProfiles;
@property (weak, nonatomic) IBOutlet UIView *lotteryProfileItemView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *profileSelectArray;

@end

@implementation LotteryProfileSelectView

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LotteryProfileSelectView" owner:nil options:nil] lastObject];
    }
    self.frame = frame;
    return self;
}

- (IBAction)actionPlayTypeSelect:(UIButton *)sender {
    
    for (UIButton *itemBtn in self.profileSelectArray) {
        itemBtn.selected = NO;
    }
    
    sender.selected = YES;
//    1  spf   2 rqspf  3 bf   4  bqc 5hhgg 6jqs 
    JCZQProfile *selectProfile = self.lotteryPros[sender.tag % 100];
    if (sender.tag / 100 == 1) {  //过关
        [self.delegate lotteryProfileSelectViewDelegate:selectProfile andPlayType:JCZQPlayTypeGuoGuan andRes:@"1"];
    }
    if (sender.tag / 100 == 2) {  // 单关
        [self.delegate lotteryProfileSelectViewDelegate:selectProfile andPlayType:JCZQPlayTypeDanGuan andRes:@"1"];
    }
    [UIView animateWithDuration:0.5 animations:^{
        
       self.hidden = YES;
    }];

}


@end
