//
//  RegisterViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/14.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "RegisterViewController.h"
#define KCheckSec 5
@interface RegisterViewController ()<UITextFieldDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *disMarginTop;
    __weak IBOutlet UIButton *btnIsNeedRecomCode;
    __weak IBOutlet UITextField *tfRecomCode;
    __weak IBOutlet UITextField *tfUserPwd;
    __weak IBOutlet UITextField *tfUserTel;
    __weak IBOutlet UIButton *btnMemberIcon;
    __weak IBOutlet UITextField *tfCheckCode;
    __weak IBOutlet UIButton *btnSendCheckCode;
    __weak IBOutlet UIButton *btnRegister;
    NSTimer *timer;
    NSInteger checkSec;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    disMarginTop.constant =  [self isIphoneX]?94 + 44:94;
    
    [self setTFViewLRView];
    [self setBtnBackImgWithCol];
    checkSec = KCheckSec;
    self.view.backgroundColor = MAINBGC;
    self.title = @"注册";
}

-(void)setTFViewLRView{
    
    tfUserTel.delegate = self;
    tfRecomCode.delegate = self;
    tfCheckCode.delegate = self;
    tfUserPwd.delegate = self;
    
    [tfUserTel setLeftView:@"phone" rightView:nil];
    tfUserTel.leftViewMode=UITextFieldViewModeAlways;
    [self setBoaderColor:tfUserTel color:TFBorderColor];
    [self setBoaderColor:tfRecomCode color:TFBorderColor];
    [self setBoaderColor:tfCheckCode color:TFBorderColor];
    [self setBoaderColor:tfUserPwd color:TFBorderColor];
    
    [tfCheckCode setLeftView:@"captcha" rightView:nil];
    tfCheckCode.leftViewMode=UITextFieldViewModeAlways;
    
    [tfUserPwd setLeftView:@"password" rightView:nil];
    tfUserPwd.leftViewMode=UITextFieldViewModeAlways;
    [tfRecomCode setLeftView:@"recommend" rightView:nil];
    tfRecomCode.leftViewMode=UITextFieldViewModeAlways;
    
}

-(void)setBtnBackImgWithCol{
    
    btnMemberIcon.layer.cornerRadius = btnMemberIcon.mj_h/2;
    btnMemberIcon.layer.masksToBounds = YES;
    
    btnRegister.layer.cornerRadius = 3;
    btnRegister.layer.masksToBounds = YES;
    btnSendCheckCode.layer.cornerRadius = 3;
    btnSendCheckCode.layer.masksToBounds = YES;
    
    
    [btnRegister setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnRegister setBackgroundImage:[UIImage imageWithColor:BtnDisAbleBackColor] forState:UIControlStateDisabled];
    
    [btnSendCheckCode setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnSendCheckCode setBackgroundImage:[UIImage imageWithColor:BtnDisAbleBackColor] forState:UIControlStateDisabled];
    

}



- (IBAction)actionSendCheckCode:(id)sender {
    
    [btnSendCheckCode setEnabled:NO];
    
    [btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
    
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (checkSec > 0) {
                checkSec --;
                [btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
            }else{
                checkSec = KCheckSec;
                [timer invalidate];
                [btnSendCheckCode setTitle:@"获取验证码" forState:0];
                [btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
                [btnSendCheckCode setEnabled: YES];
            }
        }];
    } else {
        
    }
    
}
- (IBAction)actionRegister:(id)sender {
}

- (IBAction)actionIsGreenRule:(id)sender {
}
- (IBAction)actionLookRule:(id)sender {
}


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:SystemGreen];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:TFBorderColor];
}

-(void)setBoaderColor:(UITextField *)textField color:(UIColor*)color{
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
