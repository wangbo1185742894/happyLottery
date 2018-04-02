//
//  LotteryProfileSelectCellView.m
//  Lottery
//
//  Created by YanYan on 6/6/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryProfileSelectCellView.h"

@implementation LotteryProfileSelectCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) initWithLotteryProfile: (LotteryXHProfile *) profile resource:vcName andguoGuanType:(NSInteger)guoGuanType{
    _guoguanType = guoGuanType;
    //lc
//    CGRect frame = self.frame;
//    frame.size.height/=2.5;
//    self.frame=frame;
   
        if([profile.title isEqualToString:@"占位"])
        {
            return;
        }
    
    if([vcName isEqualToString:@"winHistory"])
    {
        if([profile.title isEqualToString:@"混合过关"])
        {
            return;
        }
    }
    
//    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(myDelegate.jzGuanKaType == JingCaiGuanKaTypeDanGuan)
//    {
//
//        if ([profile.title isEqualToString:@"混合过关"]) {
//            return;
//        }
//        
//    }
    
    if (_guoguanType == 0) {
        if ([profile.title isEqualToString:@"混合过关"]||[profile.title isEqualToString:@"混合过关"]) {
            return;
        }
        
    }
   
    //    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    curProfile = profile;
    CGFloat titleLabelHeight = self.bounds.size.height*2/5;
    CGFloat bonusLabelHeight = self.bounds.size.height*3/5/2;
    CGFloat percentageLabelHeight = bonusLabelHeight;

    if ([profile.percentage intValue] == 0) {
        titleLabelHeight = self.bounds.size.height;
    }
    //lc
//    titleLabelHeight = self.bounds.size.height;
    
    if (self.isP3P5 == YES) {
        CGFloat curY = 0;
        //draw p3p5 button
        
        UIButton *btn = [self buttonWithHeight:percentageLabelHeight withY:curY title:profile.title];
//        btn.tag = 1000 + [profile.profileID intValue];
        [self addSubview:btn];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 1;
        self.layer.masksToBounds = YES;
        CGFloat curY = 0;
        //draw title label
        labelTitle = [self labelWithHeight: titleLabelHeight withY: curY isDetail: NO];
        labelTitle.text = profile.title;
        curY = CGRectGetMaxY(labelTitle.frame);
        
        
        //add separate label
        UILabel *seprateLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, curY, self.bounds.size.width, 1)];
        seprateLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview: seprateLabel];
        
        if ([profile.percentage intValue] != 0) {
            //draw bouns label
            labelBouns = [self labelWithHeight: bonusLabelHeight withY: curY isDetail: YES];
            labelBouns.text = [NSString stringWithFormat: TextBonusDesc, [profile.amount intValue]];
            curY = CGRectGetMaxY(labelBouns.frame);
            
            //draw percentage label
            labelPercentage = [self labelWithHeight: percentageLabelHeight withY: curY isDetail: YES];
            labelPercentage.adjustsFontSizeToFitWidth = YES;
            labelPercentage.text = [NSString stringWithFormat: TextPercentageDesc, profile.percentage]; // 概率
        }
        
        //action button
        UIButton *actionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        actionButton.frame = self.bounds;
        [actionButton addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: actionButton];
        
        if (self.isSelectedProfile) {
            [self toggleSelect: YES];
            [self buttonSelect: YES curtitle:curProfile.title];
        }


    }
    
}

- (UILabel *) labelWithHeight: (CGFloat) height withY: (CGFloat) yValue isDetail: (BOOL) detailLabel {
    UILabel *requestLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, yValue, self.bounds.size.width, height)];
    if (detailLabel) {
        requestLabel.font = [UIFont boldSystemFontOfSize: 9];
        
    } else {
        if (height == self.bounds.size.height) {
            requestLabel.font = [UIFont boldSystemFontOfSize: 11];
        }else{
            requestLabel.font = [UIFont boldSystemFontOfSize: 11];
        }
    }
    //lc
//    requestLabel.font = [UIFont systemFontOfSize: 11];
    requestLabel.backgroundColor = RGBCOLOR(232, 79, 42);
    requestLabel.textColor = [UIColor whiteColor];
    requestLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview: requestLabel];
    return requestLabel;
}

- (UIButton *)buttonWithHeight:(CGFloat)height withY:(CGFloat)yValue title: (NSString *)profileTitle{
    
    actionBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    CGFloat heightBtn = self.bounds.size.height - 15;
    actionBtn.frame = CGRectMake(0, 10, self.bounds.size.width,heightBtn);
    [actionBtn setTitle:profileTitle forState:0];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
        if (self.isSelectedProfile &&[profileTitle isEqualToString:self.typeString]) {
            [actionBtn setBackgroundImage:[UIImage imageNamed:@"plxuanzhong.png"] forState:0];
            [actionBtn setTitleColor:TextCharColor forState:0];
        }else{
            [actionBtn setBackgroundImage:[UIImage imageNamed:@"plweixuanzhong.png"] forState:0];
            [actionBtn setTitleColor:[UIColor blackColor] forState:0];
        }
        [actionBtn addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
    return actionBtn;
    
}

- (void) buttonAction: (UIButton *) button {
//    if (!self.isSelectedProfile) {
    if (self.isP3P5) {
       
        [self buttonSelect: YES curtitle:curProfile.title];
        
        [self.delegate cellView: self didSelectLotteryProfile: curProfile andGuoguanType:_guoguanType];

    }else{
        [self toggleSelect: YES];
        
        [self.delegate cellView: self didSelectLotteryProfile: curProfile andGuoguanType:_guoguanType];
    }
   
    
//    }
}

- (void)buttonSelect:(BOOL)select curtitle:(NSString *)title{
    
    self.isSelectedProfile = select;
        if (self.isSelectedProfile && [title isEqualToString:actionBtn.titleLabel.text]) {
            [actionBtn setBackgroundImage:[UIImage imageNamed:@"plxuanzhong.png"] forState:0];
            [actionBtn setTitleColor:TextCharColor forState:0];
        }else{
            [actionBtn setBackgroundImage:[UIImage imageNamed:@"plweixuanzhong.png"] forState:0];
            [actionBtn setTitleColor:[UIColor blackColor] forState:0];
        }
   
    
}

- (void) toggleSelect: (BOOL) select {
    self.isSelectedProfile = select;
   
//    if (select) {
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        labelTitle.textColor = [UIColor yellowColor];
//        labelBouns.textColor = [UIColor yellowColor];
//        labelTitle.font = [UIFont boldSystemFontOfSize:11];
//        labelPercentage.textColor = [UIColor yellowColor];
//    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.font = [UIFont boldSystemFontOfSize:11];
        labelBouns.textColor = [UIColor whiteColor];
        labelPercentage.textColor = [UIColor whiteColor];
//    }
}
@end
