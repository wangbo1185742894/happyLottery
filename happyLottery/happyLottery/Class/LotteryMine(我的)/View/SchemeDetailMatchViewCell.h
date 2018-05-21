//
//  SchemeDetailMatchViewCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQSchemeModel.h"
#import "JCZQSchemeModel.h"

@interface SchemeDetailMatchViewCell : UITableViewCell
-(void)setBtnNumIndexShow:(BOOL)isShow;
-(void)refreshData:(JcBetContent  *)modelDic andResult:(NSArray<OpenResult *> *)resultArray;
-(void)refreshDataJCLQ:(JlBetContent  *)modelDic andResult:(NSArray<JCLQOpenResult *> *)resultArray;
-(NSString *)reloadDataWithRecJCLQ:(NSArray *)option type:(NSString *)playType andMatchKey:(NSString *)matchKey;
-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType andMatchKey:(NSString *)matchKey;
-(NSString *)getPlayTypeRecEn:(NSString *)playType;
-(NSString *)reloadDataWithRecResult:(NSArray *)option type:(NSString *)playType;
-(NSString *)getPlayTypeRec:(NSString *)playType;
@end
