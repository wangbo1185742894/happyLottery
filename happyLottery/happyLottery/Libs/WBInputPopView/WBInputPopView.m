//
//  WBInputPopView.m
//  ceshi
//
//  Created by 王博 on 16/1/15.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "WBInputPopView.h"


@interface WBInputPopView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBackGround;//背景button
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;//模拟输入的图片


@property(strong,nonatomic)NSNotificationCenter *noCenter;
- (IBAction)findPayPwd:(UIButton *)sender;

@end

@implementation WBInputPopView


-(id)init{

    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WBInputPopView" owner:nil options:nil] lastObject];
        
        self.frame = [UIScreen mainScreen].bounds;
        self.txtInput.delegate = self;
//        LCNumberKeyboard *numberKeyBoard= [[LCNumberKeyboard alloc] init];
//        self.txtInput.inputView = numberKeyBoard;
        NSLog(@"%@",self.txtInput.delegate);
//        [numberKeyBoard setInputTextField:self.txtInput andIsRandom:YES];
//        [numberKeyBoard setInputTextField:self.txtInput andIsRandom:YES andDelagate:self];
        [self.txtInput becomeFirstResponder];
        
        self.noCenter = [NSNotificationCenter defaultCenter];
        
        [self. noCenter addObserver:self selector:@selector(textChange) name:@"NotificationNumberKeyChange" object:nil];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.txtInput.text = @"";
    self.imgBack.image = [UIImage imageNamed:[NSString stringWithFormat:@"pass%zd.png",self.txtInput.text.length]];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self performSelector:@selector(GetBlock) withObject:nil afterDelay:0.01];
    return YES;
}

-(void)textChange{
    [self performSelector:@selector(GetBlock) withObject:nil afterDelay:0.01];

}

-(void)GetBlock{
    if (self.txtInput.text.length >= 6) {
        self.imgBack.image = [UIImage imageNamed:[NSString stringWithFormat:@"pass6.png"]];
        self.passBlock(self.txtInput.text);
        [self endEditing:YES];
        self.txtInput.text = @"";
        return;
    }
    self.imgBack.image = [UIImage imageNamed:[NSString stringWithFormat:@"pass%zd.png",self.txtInput.text.length]];
}
- (void)show{
    [self.txtInput becomeFirstResponder];
}
-(void)createBlock:(PasswordBlock)pass{

    self.passBlock = pass;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{


    return YES;
}

//背景点击方法
- (IBAction)clickBtnBackGround:(UIButton *)sender {
    self.txtInput.text = @"";
//    [self endEditing:YES];
    self.imgBack.image = [UIImage imageNamed:@"pass0.png"];
    [self removeFromSuperview];
    
}


- (IBAction)findPayPwd:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(findPayPwd)]) {
        [self.delegate findPayPwd];
    }
    
}
@end
