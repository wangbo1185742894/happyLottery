//
//  UITextField+WbSetLRView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/14.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "UITextField+WbSetLRView.h"

@implementation UITextField (WbSetLRView)

-(void)setLeftView:(NSString *)leftImgName rightView:(NSString *)rightImgName{
    
    if (leftImgName != nil) {
        
        self.leftView = [self getImageView:leftImgName];
        
        
    }
    if (rightImgName != nil) {
        
        self.rightView = [self getImageView:rightImgName];
    }
    
}

-(UIView*)getImageView:(NSString *)imgName{
    UIView *cView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [img setImage:[UIImage imageNamed:imgName]];
    [cView addSubview:img];
    return cView;
}

@end
