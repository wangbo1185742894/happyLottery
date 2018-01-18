//
//  TableViewCell.h
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JczqShortcutModel.h"

@protocol NewsListCellDelegate

-(void)newScollectMatch:(JczqShortcutModel *)model andIsSelect:(BOOL)isSelect;

@end

@interface NewsListCell : UITableViewCell
@property(nonatomic,weak)id<NewsListCellDelegate >delegate;
-(void)refreshData:(JczqShortcutModel * )model andSelect:(BOOL)isSelect;
-(void)refreshDataCollect:(JczqShortcutModel * )model andSelect:(BOOL)isSelect;
@end
