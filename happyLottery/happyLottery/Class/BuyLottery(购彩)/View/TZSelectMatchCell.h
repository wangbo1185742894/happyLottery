//
//  TZSelectMatchCell.h
//  happyLottery
//
//  Created by 王博 on 2017/12/22.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQMatchModel.h"
#import "JCLQMatchModel.h"

@interface TZSelectMatchCell : UITableViewCell

-(void)loadData:(JCZQMatchModel *)model;
-(void)loadDataJCLQ:(JCLQMatchModel *)model;

@end
