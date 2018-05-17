//
//  SchemeContaintCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLabel.h"
#import "JCZQSchemeModel.h"

@protocol SchemeContaintCellDelegate<NSObject>
-(void)goOrderList;
@end

@interface SchemeContaintCell : UITableViewCell
@property (nonatomic,strong)id <SchemeContaintCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet MGLabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingDan;

- (void)reloadDate:(JCZQSchemeItem * )model;

@end
