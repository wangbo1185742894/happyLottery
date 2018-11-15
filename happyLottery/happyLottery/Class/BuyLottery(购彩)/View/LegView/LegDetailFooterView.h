//
//  LegDetailFooterView.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LegDetailFooterDelegate <NSObject>

- (void)refreshDetail;

- (void)lookLegDelegate;

@end

@interface LegDetailFooterView : UIView

@property (weak,nonatomic)id<LegDetailFooterDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;


@end
