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
        NSString *btnTi = [btn titleForState:UIControlStateNormal];
        if (tag/100==1||tag/100==2) {
            if(!btnTi){
                btnTi= @"";
            }
             NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc] initWithString:btnTi];
            if (!btn.selected) {
                if ([btnTi containsString:@"+"]||[btnTi containsString:@"-"]) {
                    NSRange addRange = [btnTi rangeOfString:@"+"];
                    NSRange minRange = [btnTi rangeOfString:@"-"];
                    NSRange blankRange = [btnTi rangeOfString:@" "];
                    BOOL isAdd = YES;
                    if (addRange.location == NSNotFound) {
                        isAdd = NO;
                    }
                    NSInteger index_1 = isAdd ? addRange.location : minRange.location;
                    NSInteger index_2 = blankRange.location;

                    [btnTitle addAttribute:NSForegroundColorAttributeName value:TEXTGRAYCOLOR range:NSMakeRange(0, index_1)];
                    if (isAdd) {
                        [btnTitle addAttribute:NSForegroundColorAttributeName value:SystemRed range:NSMakeRange(index_1, index_2 - index_1)];
                    }else{
                        [btnTitle addAttribute:NSForegroundColorAttributeName value:SystemGreen range:NSMakeRange(index_1, index_2 - index_1)];
                    }
                    [btnTitle addAttribute:NSForegroundColorAttributeName value:TEXTGRAYCOLOR range:NSMakeRange(index_2, btnTitle.length - index_2)];
                }else{
                    [btnTitle addAttribute:NSForegroundColorAttributeName value:TEXTGRAYCOLOR range:NSMakeRange(0, btnTitle.length)];
                }
                [btn setAttributedTitle:btnTitle forState:UIControlStateNormal];
            }else{
                [btnTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, btnTitle.length)];
                [btn setAttributedTitle:btnTitle forState:UIControlStateNormal];
            }
        }
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

@end
