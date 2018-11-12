//
//  LegDetailHeaderView.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LegDetailDelegate <NSObject>

- (void)actionToTele;

@end

@interface LegDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *LegBtn;

@property (assign, nonatomic) id<LegDetailDelegate> delegate;


@end
