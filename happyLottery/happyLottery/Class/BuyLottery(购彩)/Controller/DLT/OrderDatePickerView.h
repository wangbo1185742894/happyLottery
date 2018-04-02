//
//  OrderDatePickerView.h
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderDatePickerViewDelegate <NSObject>

-(void)orderDateTimeChooseFinish;
- (void)showText:(NSString*)msg;
@end

@interface OrderDatePickerView : UIView{

    UIControl * backControl;
    UIView * contentV;
    UIDatePicker * picker;
    UIButton * startTimeBt;
    UIButton * endTimeBt;
}
@property (nonatomic , weak) id<OrderDatePickerViewDelegate>delegate;

@property (nonatomic , strong) NSDate * startTime;
@property (nonatomic , strong) NSDate * endTime;
@property (nonatomic , strong) UIButton * curEditButton;

-(void)show:(UIView * )supView;

@end
