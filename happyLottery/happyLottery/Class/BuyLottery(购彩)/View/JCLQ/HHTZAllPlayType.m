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

    if ([flag isEqualToString:@"3"] || [flag isEqualToString:@"1"]) {
        
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
       [self setButton:self.btnGuestWinNO normal:[NSString stringWithFormat:@"客胜 %@",model.SFOddArray[0]] andSelect:self.model.SFSelectMatch[0]];
        [self setButton:self.btnGuestWinR normal:[NSString stringWithFormat:@"客胜 %@",model.RFSFOddArray[0]] andSelect:self.model.RFSFSelectMatch[0]];


    [self setButton:self.btnHomeWinNO normal:[NSString stringWithFormat:@"主胜 %@",model.SFOddArray[1]] andSelect:self.model.SFSelectMatch[1]];


    if ([model.handicap integerValue]>0) {
        [self setButton:self.btnHomeWinR normal:[NSString stringWithFormat:@"主胜+%@ %@",model.handicap,model.RFSFOddArray[1] ] andSelect:self.model.RFSFSelectMatch[1]];

    }else{
    
        [self setButton:self.btnHomeWinR normal:[NSString stringWithFormat:@"主胜%@ %@",model.handicap,model.RFSFOddArray[1] ] andSelect:self.model.RFSFSelectMatch[1]];

    }

//    大小分
    
    [self setButton:self.btnDXFDY normal:[NSString stringWithFormat:@"大于%@  %.2f",model.hilo,[model.DXFSOddArray[0] doubleValue]] andSelect:self.model.DXFSelectMatch[0]];
    [self setButton:self.btnDXFXY normal:[NSString stringWithFormat:@"小于%@  %.2f",model.hilo,[model.DXFSOddArray[1] doubleValue]] andSelect:self.model.DXFSelectMatch[1]];

//    胜分差
//    self.btnSFCGuest21_25.titleLabel.numberOfLines = 0;
    [self setButton:self.btnSFCGuest1_5 normal:[NSString stringWithFormat:@"1-5\n%@",model.SFCOddArray[0]] andSelect:self.model.SFCSelectMatch[0]];
    [self setButton:self.btnSFCGuest6_10 normal:[NSString stringWithFormat:@"6-10\n%@",model.SFCOddArray[1]] andSelect:self.model.SFCSelectMatch[1]];
    [self setButton:self.btnSFCGuest11_15 normal:[NSString stringWithFormat:@"11-15\n%@",model.SFCOddArray[2]] andSelect:self.model.SFCSelectMatch[2]];
    [self setButton:self.btnSFCGuest16_20 normal:[NSString stringWithFormat:@"16-20\n%@",model.SFCOddArray[3]] andSelect:self.model.SFCSelectMatch[3]];
    [self setButton:self.btnSFCGuest21_25 normal:[NSString stringWithFormat:@"21-25\n%@",model.SFCOddArray[4]] andSelect:self.model.SFCSelectMatch[4]];
        [self setButton:self.btnSFCGuest26_ normal:[NSString stringWithFormat:@"26+\n%@",model.SFCOddArray[5]] andSelect:self.model.SFCSelectMatch[5]];
    [self setButton:self.btnSFCHome1_5 normal:[NSString stringWithFormat:@"1-5\n%@",model.SFCOddArray[6]] andSelect:self.model.SFCSelectMatch[6]];
    [self setButton:self.btnSFCHome6_10 normal:[NSString stringWithFormat:@"6-10\n%@",model.SFCOddArray[7]] andSelect:self.model.SFCSelectMatch[7]];
    [self setButton:self.btnSFCHome11_15 normal:[NSString stringWithFormat:@"11-15\n%@",model.SFCOddArray[8]] andSelect:self.model.SFCSelectMatch[8]];
    [self setButton:self.btnSFCHome16_20 normal:[NSString stringWithFormat:@"16-20\n%@",model.SFCOddArray[9]] andSelect:self.model.SFCSelectMatch[9]];
    [self setButton:self.btnSFCHome21_25 normal:[NSString stringWithFormat:@"21-25\n%@",model.SFCOddArray[10]] andSelect:self.model.SFCSelectMatch[10]];
    [self setButton:self.btnSFCHome26_ normal:[NSString stringWithFormat:@"26+\n%@",model.SFCOddArray[11]] andSelect:self.model.SFCSelectMatch[11]];

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


-(BOOL)isCanBuyThisType:(UIButton *)sender{
    
    if (sender.tag == 0) {  //无效button
        
        return YES;
    }
    
    if (sender.tag == 1000) {  //全部玩法 展开
        
        return YES;
    }
    if (sender.tag == 2000) { //半全场  展开
        
        return YES;
    }
    if (sender.tag == 3000) { // 比分展开
        
        return YES;
    }
    
    NSInteger playType = sender.tag / 100;
    NSInteger index = sender.tag % 100;
    NSString *title;
    BOOL isCanBuy = YES;
    switch (playType) {
        case 1:
            isCanBuy = [self.delegate canBuyThisMatch:self.model andIndex:0];
            title = [self getSpNOTitle:self.model.SFOddArray index:index];
            break;
        case 2:
            title = [self getSpNOTitle:self.model.RFSFOddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:self.model andIndex:1];
            
            break;
        case 4:
            title = [self getSpNOTitle:self.model.SFCOddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:self.model andIndex:2];
            
            break;
        case 3:
            title = [self getSpNOTitle:self.model.DXFSOddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:self.model andIndex:3];
            
            break;
    }
    
    if (isCanBuy == NO || [title doubleValue] == 0) {
        return NO;
    }else{
        if ([self.model.status isEqualToString:@"ENDED"]) {
            
            return NO;
        }
        
        if ([self.model.status isEqualToString:@"CANCLE"]) {
            
            return NO;
        }
        
        if ([self.model.status isEqualToString:@"PAUSE"]) {
            
            return NO;
        }
        return YES;
        
    }
}



-(NSString *)getSpNOTitle:(NSArray *)oddArray index:(NSInteger)i{
    float sp = 0.00;
    if (oddArray.count > i ) {
        sp = [oddArray[i] doubleValue];
    }
    NSString *itemStr = [NSString stringWithFormat:@"%.2f",sp];
    return itemStr;
}

-(void )setButton:(UIButton *)item normal:(NSString  *)title andSelect:(NSString *)isselect{
    item.selected = [isselect boolValue];
    NSMutableAttributedString *attrStrN = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *attrStrS = [[NSMutableAttributedString alloc] initWithString:title];
    if ([self isCanBuyThisType:item]) {
        NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72)};
        [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
        
        
        NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
        
    }else{
        NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
        [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
        [item setAttributedTitle:attrStrN forState:0];
        NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
        [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
        [item setAttributedTitle:attrStrS forState:0];
    }
    [item setAttributedTitle:attrStrS forState:UIControlStateSelected];
    [item setAttributedTitle:attrStrN forState:0];
    item.titleLabel.numberOfLines = 0;
    item.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    item.titleLabel.font = [UIFont systemFontOfSize:13];
    
}


@end
