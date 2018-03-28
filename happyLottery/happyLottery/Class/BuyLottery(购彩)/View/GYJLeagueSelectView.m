//
//  MatchLeagueSelectView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GYJLeagueSelectView.h"
#import "UIImage+ImageWithColor.h"



@interface GYJLeagueSelectView()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrayItemLea;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;


@end

@implementation GYJLeagueSelectView

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"GYJLeagueSelectView" owner:nil options:nil] lastObject];
    }
    [self creatUI];
    self.frame = frame;
    return self;
}


- (IBAction)actionCancel:(id)sender {
    self.hidden = YES;
}

- (IBAction)btnSubmit:(id)sender {
    NSMutableArray *selectArray = [NSMutableArray arrayWithCapacity:0];
    for (UIButton *btn in self.arrayItemLea) {
        if (btn.selected == YES) {
            [selectArray addObject:@(btn.tag)];
        }
    }
    [self.delegate selectedLeagueItem:selectArray];
    self.hidden = YES;
}

-(void)creatUI{
    for (UIButton *btnItem in self.arrayItemLea) {
        [btnItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)itemClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)refreshItemState{
    for (UIButton *btnItem in self.arrayItemLea) {
        btnItem .selected = NO;
    }
}


@end
