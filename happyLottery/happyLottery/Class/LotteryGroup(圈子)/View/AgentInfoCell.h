//
//  AgentInfoCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentInfoModel.h"

@protocol AgentInfoDelegate

- (void)agentMember;

@end

@interface AgentInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;

@property (weak, nonatomic) IBOutlet UILabel *circleNotice;

@property (weak, nonatomic) IBOutlet UIImageView *headUrlImge;

@property (weak, nonatomic) IBOutlet UILabel *memberCountLab;

@property (weak, nonatomic) IBOutlet UILabel *totalBonusLab;

@property (weak, nonatomic) IBOutlet UIView *cornorView;

@property (weak, nonatomic) id<AgentInfoDelegate> delegate;

- (void)reloadDate:(AgentInfoModel *)model;

@end
