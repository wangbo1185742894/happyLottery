//
//  SuoSchemeViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SuoSchemeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *publicTime;

- (void)reloadDate:(JCZQSchemeItem * )model;

@end
