//
//  SelectView.m
//  Lottery
//
//  Created by 王博 on 16/1/18.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labRightText;

@property (weak, nonatomic) IBOutlet UILabel *lableft;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property(strong,nonatomic)UIToolbar *toolBar;

@end

@implementation SelectView

-(id)initWithFrame:(CGRect)frame andRightTitle:(NSString*)rightTitle andLeftTitle:(NSString *)leftTitle {

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SelectView" owner:nil options:nil]lastObject];
        self.frame = frame;
        self.lableft.text = leftTitle;
        self.labRightText.text = rightTitle;
        self.labContent.delegate = self;
        
//        self.labContent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
//        self.labContent.layer.borderWidth = SEPHEIGHT;
//        self.labContent.layer.borderColor = SEPCOLOR.CGColor;
        self.labContent.returnKeyType =UIReturnKeyDone;
    
        
    }
    [self ToolView];
    return self;

}



-(void)setTarget:(id)target rightAction:(SEL)rAction leftAction:(SEL)lAction{
    self.labContent.delegate = self;
    [self.btnLeft addTarget:target action:lAction forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:target action:rAction forControlEvents:UIControlEventTouchUpInside];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSMutableString*numStr = [[NSMutableString alloc]initWithString:textField.text];
    [numStr appendString:string];
    NSInteger num = [numStr integerValue];
  
    if (num > _beiShuLimit) {
        return NO;
    }
    [self performSelector:@selector(selfUpdate) withObject:nil afterDelay:0.1];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    
    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"0"]) {
        return NO;
    }

    
    
    
    NSString * regex;
    regex = @"^[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

-(void)selfUpdate{
    
    [self.delegate update];
}
-(void)ToolView{
    
    [self.labContent resignFirstResponder];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIButton *submitClean = [UIButton buttonWithType:UIButtonTypeCustom];
    submitClean.mj_h = 15;
    submitClean.mj_w = 25;
    [submitClean setBackgroundImage:[UIImage imageNamed:@"keyboarddown"] forState:UIControlStateNormal];
    [submitClean setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    submitClean.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitClean addTarget:self action:@selector(actionWancheng:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemsubmit = [[UIBarButtonItem alloc]initWithCustomView:submitClean];
    
    topView.backgroundColor = RGBCOLOR(230, 230, 230);
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithCustomView:[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 30)]];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:space,itemsubmit,nil];
    
    topView.opaque = YES;
    [topView setItems:buttonsArray];
    self.toolBar = topView;
    [self.labContent setInputAccessoryView:self.toolBar];
}

-(void)setRightTitle:(NSString*)rightTitle andLeftTitle:(NSString *)leftTitle{

    self.labRightText.text = rightTitle;
    self.lableft.text = leftTitle;
}

-(void)actionWancheng:(UITextView*)tv{
    
    [self.labContent resignFirstResponder];

}
@end
