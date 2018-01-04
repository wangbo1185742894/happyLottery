//
//  YuCeLiShiZhanJCell.h
//  Lottery
//
//  Created by onlymac on 2017/10/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yucezjModel.h"
@interface YuCeLiShiZhanJCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)refreshData:(yucezjModel *)scheme;
@end
