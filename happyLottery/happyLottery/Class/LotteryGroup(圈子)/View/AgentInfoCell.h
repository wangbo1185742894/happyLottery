//
//  AgentInfoCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentInfoModel.h"

@interface AgentInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *circleNameLab;

@property (weak, nonatomic) IBOutlet UILabel *circleNotice;

@property (weak, nonatomic) IBOutlet UIImageView *headUrlImge;

@property (weak, nonatomic) IBOutlet UILabel *memberCountLab;

@property (weak, nonatomic) IBOutlet UILabel *totalBonusLab;

@property (weak, nonatomic) IBOutlet UIView *cornorView;

- (void)reloadDate:(AgentInfoModel *)model;

@end
