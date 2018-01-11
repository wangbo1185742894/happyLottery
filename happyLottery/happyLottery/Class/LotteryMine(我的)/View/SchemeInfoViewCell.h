//
//  SchemeInfoViewCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemeInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labIsYouhui;
@property (weak, nonatomic) IBOutlet UILabel *labZheKouJinE;
@property (weak, nonatomic) IBOutlet UILabel *labShiFujine;
@property (weak, nonatomic) IBOutlet UILabel *labZhifuShijian;
-(void)loadData:(JCZQSchemeItem*)model;
@end
