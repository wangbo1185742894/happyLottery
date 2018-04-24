//
//  BaseCell.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell


-(id)init{

    return [super init ];
}

-(void)loadDataWithModel:(JCLQMatchModel*)model{

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

-(NSMutableAttributedString*)setLabHomeGuestTextColor:(NSString *)str andSelect:(BOOL)select{
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange r1 = NSMakeRange(str.length-1, 1);
    NSRange r2 = NSMakeRange(0,str.length-1);
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:r1];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:r2];
        [aStr addAttribute:NSForegroundColorAttributeName value:TextOrangeColor range:r1];
        [aStr addAttribute:NSForegroundColorAttributeName value:TEXTGRAYCOLOR range:r2];
  
    return aStr;
    
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
