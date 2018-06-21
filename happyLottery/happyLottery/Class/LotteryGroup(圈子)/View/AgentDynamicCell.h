//
//  AgentDynamicCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentInfoModel.h"

@interface AgentDynamicCell : UITableViewCell

- (void)reloadDate :(AgentDynamic *)model;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *dynamicLab;
@property (weak, nonatomic) IBOutlet UILabel *labText;

@end
