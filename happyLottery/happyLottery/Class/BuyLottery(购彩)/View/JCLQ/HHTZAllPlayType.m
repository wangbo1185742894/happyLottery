//
//  HHTZAllPlayType.m
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "HHTZAllPlayType.h"

@interface HHTZAllPlayType ()
@property(nonatomic,strong)JCLQMatchModel *model;

@property (nonatomic,strong)NSMutableArray *oldSFMatchArray;
@property (nonatomic,strong)NSMutableArray *oldRFSFMatchArray;
@property (nonatomic,strong)NSMutableArray *oldDXFMatchArray;
@property (nonatomic,strong)NSMutableArray *oldSFCMatchArray;

@end
@implementation HHTZAllPlayType

-(id)init{

    if(self = [super init]){
    
        self = [[[NSBundle mainBundle] loadNibNamed:@"HHTZAllPlayType" owner:nil options:nil] lastObject];
        self.frame = [UIScreen mainScreen].bounds;
    
    }
    
    return self;

}
- (IBAction)actionSure:(UIButton *)sender {
    
    [self.cell updataSelected];
    [self removeFromSuperview];
}

- (IBAction)actionCancel:(UIButton *)sender {
    self.model.SFCSelectMatch = self.oldSFCMatchArray;
    self.model.RFSFSelectMatch = self.oldRFSFMatchArray;
    self.model.DXFSelectMatch = self.oldDXFMatchArray;
    self.model.SFSelectMatch = self.oldSFMatchArray;
    
    
    [self.cell loadDataWithModel:self.model];
    [self.cell updataSelected];
//    [self loadData:self.model];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterTouzhuReloadData" object:self.model];
    [self removeFromSuperview];
    
}
- (IBAction)actionClick:(UIButton *)sender {
    
    NSString *flag;
    
    NSInteger num = sender.tag/100;
    
    
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

-(void)loadData:(JCLQMatchModel*)model{

    self.model = model;
    
    
    
    self.oldSFMatchArray = [[NSMutableArray alloc]initWithArray:model.SFSelectMatch];
    self.oldRFSFMatchArray = [[NSMutableArray alloc]initWithArray:model.RFSFSelectMatch];
    self.oldDXFMatchArray = [[NSMutableArray alloc]initWithArray:model.DXFSelectMatch];
    self.oldSFCMatchArray = [[NSMutableArray alloc]initWithArray:model.SFCSelectMatch];
 
    self.labMatchName.text = [NSString stringWithFormat:@"%@(客) VS %@(主)",model.guestName,model.homeName];
//    胜负
    [self.btnGuestWinNO setTitle:[NSString stringWithFormat:@"客胜 %@",model.SFOddArray[0]] forState:UIControlStateNormal];
//    self.btnGuestWinNO.enabled = ![model.SFOddArray[0]isEqualToString:@"0"];
    
    [self.btnGuestWinR setTitle:[NSString stringWithFormat:@"客胜 %@",model.RFSFOddArray[0]] forState:UIControlStateNormal];
//    self.btnGuestWinR.enabled = ![model.RFSFOddArray[0]isEqualToString:@"0"];

    [self.btnHomeWinNO setTitle:[NSString stringWithFormat:@"主胜 %@",model.SFOddArray[1]] forState:UIControlStateNormal];
//    self.btnHomeWinNO.enabled = ![model.SFOddArray[1]isEqualToString:@"0"];
    
//    NSRange r = [model.handicap rangeOfString:@"-"];
    if ([model.handicap integerValue]>0) {
        [self.btnHomeWinR setTitle:[NSString stringWithFormat:@"主胜+%@ %@",model.handicap,model.RFSFOddArray[1] ] forState:UIControlStateNormal];
    }else{
    
        [self.btnHomeWinR setTitle:[NSString stringWithFormat:@"主胜%@ %@",model.handicap,model.RFSFOddArray[1] ] forState:UIControlStateNormal];
    }
    
//    [self.btnHomeWinR setTitle:[NSString stringWithFormat:@"主胜%@  %@",model.handicap,model.RFSFOddArray[1] ] forState:UIControlStateNormal];
//    self.btnHomeWinR.enabled = ![model.RFSFOddArray[1]isEqualToString:@"0"];
//    大小分
    [self.btnDXFDY setTitle:[NSString stringWithFormat:@"大于%@  %@",model.hilo,model.DXFSOddArray[0]] forState:UIControlStateNormal];
    
    
    [self.btnDXFXY setTitle:[NSString stringWithFormat:@"小于%@  %@",model.hilo,model.DXFSOddArray[1]] forState:UIControlStateNormal];

//    胜分差
//    self.btnSFCGuest21_25.titleLabel.numberOfLines = 0;
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
    
    [self refreshSelected:self.model.SFSelectMatch baseTag:100 andEnableArray:model.SFOddArray];
    [self refreshSelected:self.model.RFSFSelectMatch baseTag:200 andEnableArray:model.RFSFOddArray];
    [self refreshSelected:self.model.DXFSelectMatch baseTag:300 andEnableArray:model.DXFSOddArray];
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
