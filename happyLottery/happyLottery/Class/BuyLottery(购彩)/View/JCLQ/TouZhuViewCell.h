//
//  TouZhuViewCell.h
//  Lottery
//
//  Created by 王博 on 16/8/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQMatchModel.h"

@interface TouZhuViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labSelectMatchTime;
@property (weak, nonatomic) IBOutlet UILabel *labSelectMatchHomeAndGuest;
@property (weak, nonatomic) IBOutlet UIView *viewSelectType;
- (IBAction)actionMatch:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constranintTypeViewHeight;

-(void)reloadDataWith:(JCLQMatchModel*)model;
@end
