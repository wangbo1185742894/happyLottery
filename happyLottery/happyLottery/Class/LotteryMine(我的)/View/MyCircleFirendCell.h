//
//  MyCircleFirendCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentMemberModel.h"

@interface MyCircleFirendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lmgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIImageView *quanzhuImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

-(void)loadData:(AgentMemberModel *)model;
-(void)loadDataInQ:(AgentMemberModel *)model;
-(void)loadDataLottery:(NSDictionary  *)itemDic andRate:(NSString *)rate;
@end
