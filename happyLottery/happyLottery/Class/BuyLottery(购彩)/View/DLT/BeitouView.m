//
//  BeitouView.m
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "BeitouView.h"

@implementation BeitouView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)setUp:(Lottery *)lottery{
    CGRect beiToufram;
    CGRect zhuihaofram;
    CGRect zhuijiaFram;
    CGFloat buttonWidth;
    CGFloat buttonHeight = self.frame.size.height;
    buttonWidth = 150;
    beiToufram = CGRectMake(10, 0, buttonWidth, buttonHeight);
    zhuihaofram = CGRectMake((self.frame.size.width-buttonWidth-10), 0, buttonWidth, buttonHeight);
}

- (void)beitou{
    [self.delegate betBeiTou];
}
- (void)zhuihao{
    [self.delegate betzhuihao];
}
- (void)zhuijia:(UIButton *)button{
    button.selected =  !button.selected;
    [self.delegate betZhuijia:button.selected];
}
- (UIButton *)button:(CGRect)fram title:(NSString *)title select:(SEL)select imgage:(NSString *)imgName selectedImgName:(NSString *)selectImgName{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [button addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];
    [button setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

@end
