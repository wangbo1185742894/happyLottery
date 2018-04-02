//
//  CTZQOpenLotterySelectDateView.m
//  Lottery
//
//  Created by 王博 on 16/3/29.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQOpenLotterySelectDateView.h"



@interface CTZQOpenLotterySelectDateView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picSelectDate;
@property (assign,nonatomic) NSInteger selectRow;


@end
@implementation CTZQOpenLotterySelectDateView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CTZQOpenLotterySelectDateView" owner:nil options:nil] lastObject];
        
    }
    self.frame = frame;
    self.picSelectDate.showsSelectionIndicator = YES;
    [self.picSelectDate reloadAllComponents];
   
  
    return self;

}


- (IBAction)actionBackground:(UIButton *)sender {
    if (self != nil) {
        [self removeFromSuperview];
    }
}
- (IBAction)actionSure:(UIButton *)sender {
    
    [self.delegate actionSubmitDate:self.selectRow];
    [self removeFromSuperview];
}
- (IBAction)actionCancel:(UIButton *)sender {
    if (self != nil) {
        [self removeFromSuperview];
    }
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.pickerDataSource.count;

}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.selectRow = row;

}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    LotteryRound *round =  self.pickerDataSource[row];
    
    NSString* timestr = [NSString stringWithFormat:@"%@",round.startTime];
    NSInteger length = [timestr length];
    if(length > 10)
    {
        timestr = [timestr substringToIndex:10];
    }
//    timestr =
//    _labMatchDate.text = [NSString stringWithFormat:@"第%@期  %@(%@)",round.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
    
    NSString *item = [NSString stringWithFormat:@"第%@期 %@(%@)",round.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
    
    return item;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumScaleFactor = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:19]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (void)configShow{
    NSUInteger index = 0;
    for (LotteryRound *round in self.pickerDataSource) {
        if ([round.issueNumber isEqualToString:_selected]) {
            index = [_pickerDataSource indexOfObject:round];
            break;
        }
    }
    
    [_picSelectDate selectRow:index inComponent:0 animated:YES];
    
}



@end
