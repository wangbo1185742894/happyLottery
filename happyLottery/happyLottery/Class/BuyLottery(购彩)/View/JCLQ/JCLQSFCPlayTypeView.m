//
//  JCLQSFCPlayTypeView.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQSFCPlayTypeView.h"

@interface JCLQSFCPlayTypeView ()

@property(nonatomic,strong)JCLQMatchModel *model;
@property (nonatomic,strong)NSMutableArray *oldSFCMatchArray;
@end

@implementation JCLQSFCPlayTypeView

-(id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"JCLQSFCPlayTypeView" owner:nil options:nil] lastObject];
        
    }
    
    return self;
    
}
- (IBAction)actionCancel:(UIButton *)sender {
    self.model.SFCSelectMatch = self.oldSFCMatchArray;
    
    
    [self.cell loadDataWithModel:self.model];
    [self.cell updataSelected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterTouzhuReloadData" object:self.model];
    [self removeFromSuperview];
}
- (IBAction)actionSure:(UIButton *)sender {
    [self.cell updataSelected];
    [self removeFromSuperview];
    
}
- (IBAction)actionItemClick:(UIButton *)sender {
    NSInteger num = sender.tag/100;
    NSString *flag;
    
    if (self.model.openFlag .length !=4) {
        self.model.openFlag = @"3333";
    }
    if (num == 4) {
        flag = [self.model.openFlag substringWithRange:NSMakeRange(2, 1)];
    }else if (num == 3){
        flag = [self.model.openFlag substringWithRange:NSMakeRange(3, 1)];
    }else{
        flag = [self.model.openFlag substringWithRange:NSMakeRange(num - 1, 1)];
    }
    
    
    
    if ([flag isEqualToString:@"3"]) {
        
    }else{
        sender.selected = !sender.selected;
    }
    
    if (sender.selected) {
        [self.delegate clickItem:@"1" model:self.model andIndex:sender.tag];
    }else{
        [self.delegate clickItem:@"0" model:self.model andIndex:sender.tag];
        
    }
}

-(void)loadDataWith:(JCLQMatchModel*)model{
    //    胜分差
    self.model = model;
      self.labMatchName.text = [NSString stringWithFormat:@"%@(客) VS %@(主)",model.guestName,model.homeName];
    
    self.oldSFCMatchArray = [[NSMutableArray alloc]initWithArray:model.SFCSelectMatch];
    [self.btnSFCGuest1_5 setTitle:[NSString stringWithFormat:@"1-5\n%@",model.SFCOddArray[0]] forState:UIControlStateNormal];
    [self.btnSFCGuest6_10 setTitle:[NSString stringWithFormat:@"6-10\n%@",model.SFCOddArray[1]] forState:UIControlStateNormal];
    [self.btnSFCGuest11_15 setTitle:[NSString stringWithFormat:@"11-15\n%@",model.SFCOddArray[2]] forState:UIControlStateNormal];
    [self.btnSFCGuest16_20 setTitle:[NSString stringWithFormat:@"16-20\n%@",model.SFCOddArray[3]] forState:UIControlStateNormal];
    [self.btnSFCGuest21_25 setTitle:[NSString stringWithFormat:@"21-25\n%@",model.SFCOddArray[4]] forState:UIControlStateNormal];
    [self.btnSFCGuest26_ setTitle:[NSString stringWithFormat:@"26+\n%@",model.SFCOddArray[5]] forState:UIControlStateNormal];
    [self.btnSFCHome1_5 setTitle:[NSString stringWithFormat:@"1-5\n%@",model.SFCOddArray[6]] forState:UIControlStateNormal];
    [self.btnSFCHome6_10 setTitle:[NSString stringWithFormat:@"6-10\n%@",model.SFCOddArray[7]] forState:UIControlStateNormal];
    [self.btnSFCHome11_15 setTitle:[NSString stringWithFormat:@"11-15\n%@",model.SFCOddArray[8]] forState:UIControlStateNormal];
    [self.btnSFCHome16_20 setTitle:[NSString stringWithFormat:@"16-20\n%@",model.SFCOddArray[9]] forState:UIControlStateNormal];
    [self.btnSFCHome21_25 setTitle:[NSString stringWithFormat:@"21-25\n%@",model.SFCOddArray[10]] forState:UIControlStateNormal];
    [self.btnSFCHome26_ setTitle:[NSString stringWithFormat:@"26+\n%@",model.SFCOddArray[11]] forState:UIControlStateNormal];

    [self refreshSelected:self.model.SFCSelectMatch baseTag:400 andEnableArray:model.SFCOddArray];
}

-(void)refreshSelected:(NSArray *)array baseTag:(NSInteger)tag andEnableArray:(NSArray *)enble{
    for (int i = 0; i<array.count; i++) {
        NSString *item = array[i];
        UIButton *btn = [self viewWithTag:tag+i];
        btn.selected = [item isEqualToString:@"1"];
        btn.enabled =![enble[i]isEqualToString:@"0"];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
