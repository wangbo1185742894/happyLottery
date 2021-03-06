//
//  SchemeContainInfoCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jcBetContent.h"
#import "JCZQSchemeModel.h"

@interface SchemeContainInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;

@property (weak, nonatomic) IBOutlet UILabel *groupMatchLab;

@property (weak, nonatomic) IBOutlet UILabel *betContentLab;

@property (weak, nonatomic) IBOutlet UILabel *matchResultLab;

-(CGFloat)getCellHeight:(JcBetContent  *)modelDic;
-(CGFloat)getCellJCLQHeight:(JcBetContent  *)modelDic;
-(void)refreshData:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray;

-(void)refreshDataJCLQ:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray;

- (void)reloadDate:(JCZQSchemeItem *)scheme;

@end
