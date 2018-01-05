//
//  SchemListCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/3.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemListCell : UITableViewCell

-(void)refreshData:(JCZQSchemeItem*)model;

@end
