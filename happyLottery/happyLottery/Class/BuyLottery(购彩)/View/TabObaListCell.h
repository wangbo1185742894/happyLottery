//
//  TabObaListCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegWordModel.h"
@interface TabObaListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labObaCost;
@property (weak, nonatomic) IBOutlet UILabel *labObaRemark;
@property (weak, nonatomic) IBOutlet UILabel *labObaName;
-(void)loadData:(LegWordModel *)model;
@end
