//
//  LotteryProfileSelectView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LotteryProfileSelectView.h"

@interface LotteryProfileSelectView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightVIew;
@property(nonatomic,strong)NSArray *lotteryProfiles;
@property (weak, nonatomic) IBOutlet UIButton *btnDanGuanHT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UIView *lotteryProfileItemView;
@property (weak, nonatomic) IBOutlet UIImageView *labPlayType;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *profileSelectArray;
@property (weak, nonatomic) IBOutlet UIView *viewGuoguan;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bifenDisLeft;
@end

@implementation LotteryProfileSelectView

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LotteryProfileSelectView" owner:nil options:nil] lastObject];
    }
    self.frame = frame;
    return self;
}

-(void)setPlayVIew:(JCZQPlayType )playtype{
    if (playtype == JCZQPlayTypeDanGuan) {
        self.viewGuoguan.hidden = YES;
        self.labPlayType.hidden = YES;
        self.heightVIew.constant = 130;
        
        self.btnDanGuanHT.hidden = NO;
        self.topDis .constant= 20;
        UIButton *select = [self viewWithTag: 204];
        if ([select isKindOfClass:[UIButton class]]) {
            select .selected = YES;
        }
    }else{
        self.bifenDisLeft.constant = 8;
    }
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
