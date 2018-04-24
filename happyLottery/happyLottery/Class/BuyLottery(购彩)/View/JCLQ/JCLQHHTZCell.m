//
//  JCLQHHTZCell.m
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQHHTZCell.h"
#import "HHTZAllPlayType.h"

@interface JCLQHHTZCell ()

@end

@implementation JCLQHHTZCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQHHTZCell" owner:nil options:nil] lastObject];
        [self.btnShowAll addTarget:self action:@selector(showAllType) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;

}


- (IBAction)actionClick:(UIButton *)sender {
    sender.selected = ! sender.selected;
    
    NSInteger index = sender.tag /100 -1;
    NSString *flag;
//    switch (index) {
//        case 0:  //RF  0
//            flag = [self.model.openFlag substringWithRange:NSMakeRange(0, 1)];
//            break;
//        case 1:   //RFSF 1
//            flag = [self.model.openFlag substringWithRange:NSMakeRange(1, 1)];
//            break;
//        case 3:   //SFC  2
//            flag = [self.model.openFlag substringWithRange:NSMakeRange(2, 1)];
//            break;
//        case 2:   //DXF  3
//            flag = [self.model.openFlag substringWithRange:NSMakeRange(3, 1)];
//            break;
//            default:
//            break;
//    }
//    if ([flag isEqualToString:@"3"]) {
//        
//        return;
//    }
    if (sender.selected) {
        if (self.delegate) {
            [self.delegate clickItem:@"1" model:self.model andIndex:sender.tag];
        }
        
    }else{
        if (self.delegate) {
               [self.delegate clickItem:@"0" model:self.model andIndex:sender.tag];
        }
    }
    
    
    [self updataSelected];
  
}

-(void)updataSelected{
    NSInteger number = [self sumSelect:self.model.SFSelectMatch];
    
    number += [self sumSelect:self.model.SFCSelectMatch];
    number += [self sumSelect:self.model.DXFSelectMatch];
    number += [self sumSelect:self.model.RFSFSelectMatch];
    
    if (number == 0) {
        [self.btnShowAll setTitle:@"全部玩法" forState:UIControlStateNormal];
        
        self.btnShowAll.backgroundColor = [UIColor whiteColor];
    }
    else{
        [self.btnShowAll setTitle:[NSString stringWithFormat:@"已选%zd项",number] forState:UIControlStateNormal];
        self.btnShowAll.backgroundColor = [UIColor clearColor];
    }
    [self refreshSelected:self.model.SFSelectMatch baseTag:100 andEnableArray:self.model.SFOddArray];
    [self refreshSelected:self.model.RFSFSelectMatch baseTag:200 andEnableArray:self.model.RFSFOddArray];
    
}

-(NSInteger)sumSelect:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *item in array) {
        if ([item isEqualToString:@"1"]) {
            num ++;
        }
    }
    return num;
}

-(void)loadDataWithModel:(JCLQMatchModel *)model{
    
    self.model = model;
    self.imgDanguan.hidden = YES;;
    self.labHHTZGameName.text = model.leagueName;
    self.labHHTZGameDay.text = model.lineId;
    self.labHHTZGameTime.text =  [NSString stringWithFormat:@"%@截止",[[[model.stopBuyTime componentsSeparatedByString:@" "] lastObject]substringToIndex:5]];
    
    NSString *string =  [NSString stringWithFormat:@"%@客 VS %@主",model.guestName,model.homeName];
    
//    SF RFSF SFC DXF
    
    if (model.openFlag == nil) {
       model.openFlag = @"3333";
    }
    NSString  *sfFlag = [model.openFlag substringWithRange:NSMakeRange(0, 1)];
    NSString  *rfsfFlag = [model.openFlag substringWithRange:NSMakeRange(1, 1)];
    
    
    // 01  单关  02  过关
    if ([sfFlag isEqualToString:@"3"] || [sfFlag isEqualToString:@"1"]) {
    
    }
    
    if ([rfsfFlag isEqualToString:@"3"] || [rfsfFlag isEqualToString:@"1"]) {
       
    }
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange r1 = NSMakeRange(model.guestName.length, 1);
    NSRange r2 = NSMakeRange(string.length-1, 1);
    
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r1];
     [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r2];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r1];
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r2];
    self.labHomeAndGoust.attributedText = aStr;
            [self setButton:self.btnGuestWinNo normal:[NSString stringWithFormat:@"客胜%.2f",[model.SFOddArray[0] doubleValue]] andSelect:self.model.SFSelectMatch[0]];
            [self setButton:self.btnGuestWinR normal:[NSString stringWithFormat:@"客胜%.2f",[model.RFSFOddArray[0] doubleValue]] andSelect:self.model.RFSFSelectMatch[0]];
    
            [self setButton:self.btnHomeWinNo normal:[NSString stringWithFormat:@"主胜%.2f",[model.SFOddArray[1] doubleValue]] andSelect:self.model.SFSelectMatch[1]];
   

    
//    [self.btnHomeWinR setTitle:[NSString stringWithFormat:@"主胜(%@)%@",model.RFSFOddArray[1],model.handicap] forState:UIControlStateNormal];
//    NSRange r = [model.handicap rangeOfString:@"-"];
    if ([model.handicap integerValue]>0) {
          [self setButton:self.btnHomeWinR normal:[NSString stringWithFormat:@"主胜+%@ %.2f",model.handicap,[model.RFSFOddArray[1] doubleValue] ] andSelect:self.model.RFSFSelectMatch[1]];

    }else{
     [self setButton:self.btnHomeWinR normal:[NSString stringWithFormat:@"主胜%@ %.2f",model.handicap,[model.RFSFOddArray[1] doubleValue] ] andSelect:self.model.RFSFSelectMatch[1]];
    }
//    [self refreshSelected:self.model.SFSelectMatch baseTag:100 andEnableArray:model.SFOddArray];
//    [self refreshSelected:self.model.RFSFSelectMatch baseTag:200 andEnableArray:model.RFSFOddArray];
    [self updataSelected];
}

-(void)showAllType{
    HHTZAllPlayType *type = [[HHTZAllPlayType alloc]init];
    type.delegate = self.delegate;
    [type loadData:self.model];
    type.cell = self;
    [[UIApplication sharedApplication].keyWindow  addSubview:type];
}

@end
