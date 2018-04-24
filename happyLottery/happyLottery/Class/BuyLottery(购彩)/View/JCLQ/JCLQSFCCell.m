//
//  JCLQSFCCell.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQSFCCell.h"
#import "JCLQSFCPlayTypeView.h"
@implementation JCLQSFCCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQSFCCell" owner:nil options:nil] lastObject];
    }
    
    return self;
    
}

- (IBAction)actionSelectFenShu:(UIButton *)sender {
    JCLQSFCPlayTypeView *type = [[JCLQSFCPlayTypeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    type.frame =[UIScreen mainScreen].bounds;
     type.delegate = self.delegate;
    [type loadDataWith:self.model];
   
    type.cell = self;
    [[UIApplication sharedApplication].keyWindow  addSubview:type];
    
}

-(void)loadDataWithModel:(JCLQMatchModel *)model{

    self.model = model;
    self.imgDanguan.hidden = !model.isDanGuan;
    self.labSFCGameName.text = model.leagueName;
    self.labSFCGameDay.text = model.lineId;
    self.labSFCGameTime.text = [NSString stringWithFormat:@"%@截止",[[[model.stopBuyTime componentsSeparatedByString:@" "] lastObject]substringToIndex:5]];
//    self.labTitleHostAndGoust.text = [NSString stringWithFormat:@"%@ VS %@(主)",model.homeName,model.guestName];
    
    NSString *string =  [NSString stringWithFormat:@"%@客 VS %@主",model.guestName,model.homeName];
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange r1 = NSMakeRange(model.guestName.length, 1);
    NSRange r2 = NSMakeRange(string.length-1, 1);
    
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r1];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r2];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r1];
    [aStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:r2];
    self.labTitleHostAndGoust.attributedText = aStr;
    
    [self updataSelected];


}

-(void)updataSelected{

    NSMutableString *title = [[NSMutableString alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSArray *arry = dic[@"SFC"];
    
    
    NSInteger num = 0;
    for (int i = 0; i<self.model.SFCSelectMatch.count; i++) {
        NSString *str = self.model.SFCSelectMatch[i];
        if ([str isEqualToString:@"1"]) {
            NSDictionary *dic  = arry[i];
            [title appendString:[NSString stringWithFormat:@"%@",dic[@"appear"]]];
            [title appendString:@" "];
            num++;
        }
    }
    
    if (num == 0) {
        self.btnSelectFenShu.selected = NO;
        [self.btnSelectFenShu setTitle:@"点击选择胜分差" forState:UIControlStateNormal];
    }else{
        
        self.btnSelectFenShu.selected = YES;
        [self.btnSelectFenShu setTitle:title forState:UIControlStateNormal];
    }
    
}

@end
