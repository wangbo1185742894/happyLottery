

//
//  BaseJczaMorePlayView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseJczaMorePlayView.h"

@implementation BaseJczaMorePlayView

-(void)jczqCellItemClickBase:(NSInteger )tag{
    if (tag == 0) {  //无效button
        return;
    }
    
    NSInteger playType = tag / 100;
    NSInteger index = tag % 100;
    
    switch (playType) {
        case 1:
            [self.curModel.SPF_SelectMatch replaceObjectAtIndex:index withObject:@"1"];
            break;
        case 2:
            [self.curModel.RQSPF_SelectMatch replaceObjectAtIndex:index withObject:@"1"];
            break;
        case 3:
            [self.curModel.BF_SelectMatch replaceObjectAtIndex:index withObject:@"1"];
            break;
        case 4:
            [self.curModel.BQC_SelectMatch replaceObjectAtIndex:index withObject:@"1"];
            break;
        case 5:
            [self.curModel.JQS_SelectMatch replaceObjectAtIndex:index withObject:@"1"];
            break;
        default:
            break;
    }
    
}

-(NSString *)getSpTitle:(NSArray *)oddArray index:(NSInteger)i{
    float sp = 0.00;
    if (oddArray.count > i ) {
        sp = [oddArray[i] doubleValue];
    }
    NSString *itemStr = [NSString stringWithFormat:@"(%.2f)",sp];
    return itemStr;
}

-(NSString *)getSpNOTitle:(NSArray *)oddArray index:(NSInteger)i{
    float sp = 0.00;
    if (oddArray.count > i ) {
        sp = [oddArray[i] doubleValue];
    }
    NSString *itemStr = [NSString stringWithFormat:@"%.2f",sp];
    return itemStr;
}

-(BOOL)checkThisItemCanBuy:(UIButton *)sender{
    
    NSInteger playType = sender.tag / 100;
    NSInteger index = sender.tag % 100;
    NSString *title;
    switch (playType) {
        case 1:
            title = [self getSpNOTitle:_curModel.SPF_OddArray index:index];
            break;
        case 2:
            title = [self getSpNOTitle:_curModel.RQSPF_OddArray index:index];
            
            break;
        case 3:
            title = [self getSpNOTitle:_curModel.BF_OddArray index:index];
            
            break;
        case 4:
            title = [self getSpNOTitle:_curModel.BQC_OddArray index:index];
            
            break;
        case 5:
            title = [self getSpNOTitle:_curModel.JQS_OddArray index:index];
            
            break;
        default:
            break;
    }
    
    if ([title doubleValue] == 0) {
        
        return NO;
    }else{
        if ([self.curModel.status isEqualToString:@"ENDED"]) {
            
            return NO;
        }
        
        if ([self.curModel.status isEqualToString:@"CANCLE"]) {
            
            return NO;
        }
        
        if ([self.curModel.status isEqualToString:@"PAUSE"]) {
            
            return NO;
        }
        return YES;
        
    }
    
}

@end
