//
//  OrderDatePickerView.m
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "OrderDatePickerView.h"

@implementation OrderDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIButton *)bt:(CGRect)fram title:(NSString *)title action:(SEL)select{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    button.frame = fram;
    button.layer.cornerRadius = 1;
    button.layer.masksToBounds = YES;   
    button.backgroundColor = RGBCOLOR(220, 220, 220);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

-(UILabel *)lb:(CGRect)fram {

    UILabel * lable = [[UILabel alloc] initWithFrame:fram];
    lable.layer.borderColor = RGBCOLOR(100, 100, 100).CGColor;
    lable.layer.borderWidth = 0.5;
    return lable;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    backControl = [[UIControl alloc] initWithFrame:self.bounds];
    backControl.backgroundColor = [UIColor blackColor];
    backControl.alpha = 0.3;
    [backControl addTarget:self action:@selector(chooseCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backControl];
    contentV = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 325)];
    contentV.center = self.center;
    contentV.layer.cornerRadius = 4;
    contentV.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentV];
    float padding = 10;
    float button_width = (contentV.frame.size.width - 3*padding)/2.0;
    float button_height = 35;
    startTimeBt = [self bt:CGRectMake(padding, padding, button_width, button_height) title:@"开始时间" action:@selector(editItemShift:)];
    [contentV addSubview:startTimeBt];
    endTimeBt = [self bt:CGRectMake(startTimeBt.frame.size.width+2*padding, padding, button_width, button_height) title:@"结束时间" action:@selector(editItemShift:)];
    [contentV addSubview:endTimeBt];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, startTimeBt.frame.size.height+startTimeBt.frame.origin.y+padding, contentV.frame.size.width, 216)];
    [picker addTarget:self action:@selector(timeChange) forControlEvents:UIControlEventValueChanged];
    picker.maximumDate = [NSDate date];
    CGPoint center = picker.center;
    center.x = contentV.frame.size.width/2.0;
    picker.center = center;
    picker.datePickerMode = UIDatePickerModeDate;
    [contentV addSubview:picker];
    
    UIButton * cancelBt = [self bt:CGRectMake(padding, picker.frame.size.height+picker.frame.origin.y+padding, button_width, button_height) title:@"取消" action:@selector(chooseCancel)];
    cancelBt.backgroundColor = [UIColor redColor];
    
    [cancelBt setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
    [contentV addSubview:cancelBt];
    
    UIButton * surelBt = [self bt:CGRectMake(cancelBt.frame.size.width+cancelBt.frame.origin.x +padding, picker.frame.size.height+picker.frame.origin.y+padding, button_width, button_height) title:@"确定" action:@selector(chooseFinish)];
    
      [surelBt setBackgroundImage:[UIImage imageNamed:@"orangeBackground"] forState:UIControlStateNormal];
    [contentV addSubview:surelBt];
}

-(void)show:(UIView * )supView{
    picker.date = _endTime;
    [self editItemShift:startTimeBt];
    self.alpha = 0;
    [supView addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (void) editItemShift:(UIButton *)button{

    if (button == _curEditButton) {
        //zwl 12-28 picker根据选中按钮显示开始或者结束时间
        if (button == startTimeBt) {
            [picker setDate:_startTime animated:YES];
        }
        else
        {
            [picker setDate:_endTime animated:YES];
        }
        return;
    }
    UIButton * showButton;
    UIButton * hideButton;
    if (button == startTimeBt) {
        showButton = startTimeBt;
        hideButton = endTimeBt;
        
        picker.maximumDate = _endTime;
        [picker setDate:_startTime animated:YES];
    }else{
        showButton = endTimeBt;
        hideButton = startTimeBt;
 //
//      picker.minimumDate = _startTime;
        picker.maximumDate = [NSDate date];
        [picker setDate:_endTime animated:YES];
    }
    self.curEditButton = button;
    [self buttonSelected:showButton isSelected:YES];
    [self buttonSelected:hideButton isSelected:NO];
}

-(void)buttonSelected:(UIButton *)button isSelected:(BOOL)isSelect{
    if (isSelect) {
        button.backgroundColor = RGBCOLOR(150, 150, 150);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.shadowOffset = CGSizeMake(1, 1);
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOpacity = .8f;
    }else{
        button.backgroundColor = RGBCOLOR(220, 220,220);
        [button setTitleColor:RGBCOLOR(180, 180, 180) forState:UIControlStateNormal];
        button.layer.shadowOffset = CGSizeMake(1, 1);
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOpacity = 0;
    }
}

- (void)timeChange{
    if (_curEditButton == startTimeBt) {
        self.startTime = picker.date;
    }else{
        self.endTime = picker.date;
    }
}

- (void) chooseCancel {
    [self hide];
}

- (void) chooseFinish{
    //判断开始时间是否小于结束时间
     NSComparisonResult result = [self.startTime compare:self.endTime];
    if (result == NSOrderedDescending){
        NSString *msg =@"开始时间不能大于结束时间";
         [self hide];
        [self.delegate showText:msg];
        return;
    }
    [self.delegate orderDateTimeChooseFinish];
    [self hide];
}
@end
