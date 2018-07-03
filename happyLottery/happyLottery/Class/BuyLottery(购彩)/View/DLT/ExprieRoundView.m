//
//  ExprieRoundView.m
//  Lottery
//
//  Created by Yang on 15/6/18.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "ExprieRoundView.h"
#import "LotteryRound.h"
#import "ExprieRoundViewCell.h"


@interface ExprieRoundView()

@property (nonatomic ,assign)NSInteger profileID;

@end

@implementation ExprieRoundView

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        self.allowsSelection = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
    }
}


//-(void)roundDesInfo:(LotteryRound *)round tableViewCell:(UITableViewCell *)cell{
//    
//    //11.23
////    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
////    paragraph.alignment = NSTextAlignmentNatural;//设置对齐方式
//
//    NSMutableAttributedString *betInfoString = [[NSMutableAttributedString alloc] init];
//    
//    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
//    textAttrsDictionary[NSForegroundColorAttributeName] = [UIColor blackColor];
////    textAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;
//    
//    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"第%@期",round.issueNumber] attributes: textAttrsDictionary]];
//    
//    NSMutableDictionary *mainResNumberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
//    mainResNumberAttrsDictionary[NSForegroundColorAttributeName] = [UIColor redColor];
////    mainResNumberAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;
//    //bet count string
//    
//    
//    NSString *betCountStr = [NSString stringWithFormat: @"%@", round.mainRes];
//    
//    NSArray *betnumArray = [betCountStr componentsSeparatedByString:@" "];
//    NSString *betNumStr = @"";
//    for (int i=0; i<betnumArray.count; i++) {
//        NSString *tempstr;
//        tempstr = [NSString stringWithFormat:@"%02d",[betnumArray[i] intValue]];
//        betNumStr = [betNumStr stringByAppendingString:@" "];
//        betNumStr = [betNumStr stringByAppendingString:tempstr];
//    }
//    
//    
//    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: betNumStr attributes: mainResNumberAttrsDictionary]];
//    
//    if (round.subRes && round.subRes.length != 0) {
//        
//        NSMutableDictionary *subResNumberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
//        subResNumberAttrsDictionary[NSForegroundColorAttributeName] = [UIColor blueColor];
////        subResNumberAttrsDictionary[NSParagraphStyleAttributeName] = paragraph;
//        
//        [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @" %@", round.subRes] attributes: subResNumberAttrsDictionary]];
//    }
//    //bet unit string
////    NSString *qi = [NSString stringWithFormat:@"第%@期",round.issueNumber];
////    NSString *shu = [NSString stringWithFormat:@" %@",round.mainRes];
////    NSString *reult = [NSString stringWithFormat:@"%@%@",qi,shu];
////
////    cell.textLabel.text = reult;
////    cell.textLabel.adjustsFontSizeToFitWidth = NO;
//    cell.textLabel.attributedText = betInfoString;
//    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
//}

#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rounds.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString * cellIdentify = @"cellIdentify";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
//        cell.textLabel.font = [UIFont systemFontOfSize:13];
//    }
//    LotteryRound * round = rounds[indexPath.row];
//    [self roundDesInfo:round tableViewCell:cell];
//    return cell;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentify = @"ExprieRoundViewCell";
    ExprieRoundViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExprieRoundViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = MAINBGC;
   
    NSUserDefaults *profileId = [NSUserDefaults standardUserDefaults];
    NSInteger profileID = [profileId integerForKey:@"profileId"];
    
    [profileId synchronize];
    NSArray* reversedArray;
    if (profileID == 10 || profileID == 9  || profileID == 21 || profileID == 22) {
        reversedArray = self.rounds;//倒序
    }else{
        
        reversedArray = [[self.rounds reverseObjectEnumerator] allObjects]; //倒序
    }
    
    DltOpenResult * round = reversedArray[indexPath.row];
    if([round .lotteryCode isEqualToString:@"SX115"] || [round.lotteryCode isEqualToString:@"SD115"]){
        cell.isX115 = YES;
    }
    [cell roundDesInfo:round andProfileID:[self.lottery.activeProfile.profileID integerValue]]; // 暂时用NSUserDefaults做赋值操作
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  ExpireTableViewCellH;
}

- (void)refreshWithProfileID:(NSInteger )profileID{

    _profileID = profileID;
    NSUserDefaults *profileId = [NSUserDefaults standardUserDefaults];
    [profileId setInteger:profileID forKey:@"profileId"];
    [profileId synchronize];
    NSLog(@"11236 %zd ",_profileID);
    
    [self reloadData];
    
}




@end
