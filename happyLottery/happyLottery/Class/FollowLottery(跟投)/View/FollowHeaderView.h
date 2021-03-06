//
//  FollowHeaderView.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FollowHeaderDelegate<NSObject>
-(void)actionToGD;

-(void)actionToNotice;

@end

@interface FollowHeaderView : UIView

@property(weak,nonatomic)id <FollowHeaderDelegate >delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnGenDan;
@property (weak, nonatomic) IBOutlet UIButton *btnNotice;

@end
