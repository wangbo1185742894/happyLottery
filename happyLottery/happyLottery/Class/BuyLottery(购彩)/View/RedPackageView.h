//
//  RedPackageView.h
//  happyLottery
//
//  Created by LYJ on 2018/9/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPackageViewDelegete

- (void)initiateFollowScheme;

- (void)payForRedPackage;

@end


@interface RedPackageView : UIView

@property(nonatomic, strong) NSString *totalBanlece;

@property(nonatomic, weak) id<RedPackageViewDelegete> delegate;

@end
