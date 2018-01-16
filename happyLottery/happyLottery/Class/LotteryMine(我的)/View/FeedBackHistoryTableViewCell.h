//
//  FeedBackHistoryTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBackHistory.h"

@interface FeedBackHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *askLab;

@property (nonatomic, strong) FeedBackHistory *model;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UILabel *answerLab;

@end
