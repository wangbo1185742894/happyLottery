//
//  SchemeBuyCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemeBuyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labIsYouhui;
@property (weak, nonatomic) IBOutlet UILabel *labZheKouJinE;
@property (weak, nonatomic) IBOutlet UILabel *labShiFujine;
@property (weak, nonatomic) IBOutlet UILabel *labZhifuShijian;
@property (weak, nonatomic) IBOutlet UILabel *zhifuInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *labInfo1;
@property (weak, nonatomic) IBOutlet UILabel *labInfo2;
@property (weak, nonatomic) IBOutlet UILabel *labInfo3;
@property (weak, nonatomic) IBOutlet UILabel *labInfo4;

-(void)loadData:(JCZQSchemeItem*)model;

@end
