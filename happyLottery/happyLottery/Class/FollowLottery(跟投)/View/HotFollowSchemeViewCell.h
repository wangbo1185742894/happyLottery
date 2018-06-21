//
//  HotFollowSchemeViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSchemeModel.h"

@protocol ToPersonViewDelegate <NSObject>

-(void)itemClickToPerson:(NSString *)carcode;

@property(nonatomic,weak)id <ToPersonViewDelegate> delegate;

@end

@interface HotFollowSchemeViewCell : UITableViewCell

//个人中心
-(void)loadDataWithModelInPC:(HotSchemeModel *)model;

//跟单大厅
- (void)loadDataWithModelInDaT:(HotSchemeModel *)model;

//我的关注
-(void)loadDataWithModelInNotice:(HotSchemeModel *)model;

@property(nonatomic,weak)id <ToPersonViewDelegate> delegate;

@end
