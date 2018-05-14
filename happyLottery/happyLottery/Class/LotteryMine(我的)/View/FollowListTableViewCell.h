//
//  FollowListTableViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowListModel.h"


@interface FollowListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labNickName;
@property (weak, nonatomic) IBOutlet UILabel *FollowCost;
@property (weak, nonatomic) IBOutlet UILabel *bouns;
@property (weak, nonatomic) IBOutlet UILabel *yongjin;

-(void)loadData:(FollowListModel *)model;
@end
