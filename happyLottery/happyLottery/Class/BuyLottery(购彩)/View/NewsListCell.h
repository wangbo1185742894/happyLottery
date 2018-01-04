//
//  TableViewCell.h
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JczqShortcutModel.h"

@interface NewsListCell : UITableViewCell
-(void)refreshData:(JczqShortcutModel * )model;
@end
