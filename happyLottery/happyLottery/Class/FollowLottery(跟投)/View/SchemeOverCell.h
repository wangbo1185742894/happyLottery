//
//  SchemeOverCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemeOverCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *passType;

@property (weak, nonatomic) IBOutlet UILabel *touzhuCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;

- (void)reloadDate :(JCZQSchemeItem *)schemeDetail;

- (float)dateHeight:(JCZQSchemeItem *)schemeDetail;

@end
