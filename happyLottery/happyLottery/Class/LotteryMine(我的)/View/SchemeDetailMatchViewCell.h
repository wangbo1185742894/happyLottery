//
//  SchemeDetailMatchViewCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemeDetailMatchViewCell : UITableViewCell
-(void)setBtnNumIndexShow:(BOOL)isShow;
-(void)refreshData:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray;
@end
