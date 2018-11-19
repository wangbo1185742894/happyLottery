//
//  LegSelectFooterView.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LegSelectFooterDelegate <NSObject>

- (void)actionToDelegate;

@end

@interface LegSelectFooterView : UIView

@property (nonatomic,weak) id<LegSelectFooterDelegate> delegate;


@end
