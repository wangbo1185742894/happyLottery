//
//  WBSelectDateButtom.m
//  happyLottery
//
//  Created by 王博 on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WBSelectDateButtom.h"

@interface WBSelectDateButtom()
{
    UIButton *datebtn;
    UILabel *weeklab;
    
}
@end

@implementation WBSelectDateButtom

-(id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    if (datebtn == nil) {
        datebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        datebtn.frame = CGRectMake(0, 10, 28, 28);
        datebtn.center = CGPointMake(self.mj_w / 2, datebtn.center.y);
        datebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [datebtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
        [datebtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateSelected];
        datebtn.layer.cornerRadius = 14;
        datebtn.userInteractionEnabled = NO;
        datebtn.layer.masksToBounds = YES;
        [self addSubview:datebtn];
        [datebtn setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
        [datebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    
    if (weeklab == nil) {
        weeklab = [[UILabel alloc]initWithFrame:CGRectMake(0, datebtn.mj_h + datebtn.mj_y + 5 , self.mj_w, 20)];
        weeklab.font = [UIFont systemFontOfSize:13];
        weeklab.textColor = SystemLightGray;
        weeklab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:weeklab];
    }
}

-(void)setIsSelect:(BOOL)isSelect{
    dispatch_async(dispatch_get_main_queue(), ^{
        datebtn.selected = isSelect;
        self.isSelect = isSelect;
        if (isSelect) {
            weeklab.textColor = SystemGreen;
            
        }else{
            weeklab.textColor = SystemLightGray;
        }
    });
 
}
-(void)setTitle:(NSString *)title week:(NSString *)week{
    
    [datebtn setTitle:title forState:0];
    weeklab.text = week;
    
}



@end
