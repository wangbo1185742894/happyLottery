//
//  ActivityInfoView.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgRedIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labRedCost;
@property (weak, nonatomic) IBOutlet UILabel *labActivityInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
-(void)setStartBtnTarget:(id)target andAction:(SEL)action;
@end
