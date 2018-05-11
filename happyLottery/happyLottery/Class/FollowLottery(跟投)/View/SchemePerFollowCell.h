//
//  SchemePerFollowCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemePerFollowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *guanZhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *genfaLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyNameLabel;

- (void)reloadDate:(JCZQSchemeItem * )model schemeType:(NSString *)schemeType;

@end
