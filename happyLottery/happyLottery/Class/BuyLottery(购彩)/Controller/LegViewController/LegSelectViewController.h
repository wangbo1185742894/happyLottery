//
//  LegSelectViewController.h
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PostboyAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectModelDelegate

- (void)alreadySelectModel:(PostboyAccountModel *)selectModel;

@end

@interface LegSelectViewController : BaseViewController

@property (nonatomic , copy) NSString *titleName;  //页面名称  给跑腿小哥转账  存款  代买小哥

@property (nonatomic, strong) PostboyAccountModel *curModel;

@property (nonatomic, weak) id<SelectModelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
