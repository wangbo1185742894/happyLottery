//
//  AtttendPersonViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentPersonModel.h"
#import "FollowRedPacketModel.h"

@interface AtttendPersonViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIImageView *redImage;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labHis;

-(void)loadData:(AttentPersonModel *)model;
-(void)loadDataRedCell:(FollowRedPacketModel *)model;

@end
