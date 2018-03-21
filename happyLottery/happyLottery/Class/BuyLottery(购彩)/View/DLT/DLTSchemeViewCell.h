//
//  DLTSchemeViewCell.h
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//
#import "JCZQSchemeModel.h"


@interface DLTSchemeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *labMatchNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRedBall;
@property (weak, nonatomic) IBOutlet UILabel *labRedBall;
@property (weak, nonatomic) IBOutlet UILabel *labBuleBall;
@property (strong,nonatomic)NSString *trDltOpenResult;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UIView *viewBallContent;

-(void)refreshDataWith:(NSDictionary*)betDic andOpenResult:(NSString *)string;
-(CGFloat)getCellHeightWith:(NSDictionary*)betDic;
-(void)setNumIndex:(NSString *)numIndex andIsShow:(BOOL)isShow;
@end
