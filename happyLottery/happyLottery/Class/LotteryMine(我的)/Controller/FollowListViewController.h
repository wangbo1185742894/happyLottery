//
//  FollowListViewController.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "FollowListModel.h"

@interface FollowListViewController : BaseViewController

@property(nonatomic,copy)NSArray <FollowListModel *>  *followListDtos;

@end
