//
//  RegisterViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/14.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebShowViewController.h"
#define KCheckSec 5
@interface RegisterViewController ()<UITextFieldDelegate,MemberManagerDelegate>
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
    self.memberMan.delegate = self;
    disMarginTop.constant =  [self isIphoneX]?44 + 44:64;
    
    [self setTFViewLRView];
    [self setBtnBackImgWithCol];
    checkSec = KCheckSec;
    self.view.backgroundColor = MAINBGC;
    self.title = @"注册";
    
}

-(void)setTFViewLRView{
    
    tfRecomCode.hidden = YES;
    
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
    
    [tfCheckCode setLeftView:@"captcha" rightView:@"checksuccess"];
    
    tfCheckCode.rightViewMode = UITextFieldViewModeAlways;
    tfCheckCode.rightView.hidden = YES;
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

-(BOOL)checkTelNum{
    
    NSString *phoneNumber = [tfUserTel text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REG_PHONENUM_STR];
    if (![predicate evaluateWithObject: phoneNumber]) {
        [self showPromptText: @"请输入合法的手机号码" hideAfterDelay: 1.7];
        return NO;
    }
    return YES;
    
}

- (IBAction)actionSendCheckCode:(id)sender {
    
    if ([self checkTelNum] == NO) {
        return;
    }
    
    [self.memberMan sendRegisterSms:@{@"mobile":tfUserTel.text}];
    
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

-(void)sendRegisterSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"发送成功" hideAfterDelay: 1.7];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (IBAction)actionRegister:(id)sender {
    if ([self checkTelNum] == NO) {
        return;
    }
    
    if (tfCheckCode.text.length < 5) {
        [self showPromptText: @"请输入有效的验证码" hideAfterDelay: 1.7];
        return;
    }
    
    if (tfUserPwd.text.length < 6 || tfUserPwd.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
    
    if (tfRecomCode.hidden == NO && tfRecomCode.text.length < 7) {
        [self showPromptText: @"请输入有效推荐码" hideAfterDelay: 1.7];
        return;
    }
    NSDictionary *paraDic;
    if (tfRecomCode.hidden == NO) {
        paraDic = @{@"userTel":tfUserTel.text,@"userPwd":tfUserPwd.text,@"checkCode":tfCheckCode.text ,@"shareCode":tfRecomCode.text};
    }else{
        paraDic = @{@"userTel":tfUserTel.text,@"userPwd":tfUserPwd.text,@"checkCode":tfCheckCode.text};
    }
    [self.memberMan registerUser:paraDic];
    [self showLoadingText:@"正在提交信息"];
    
}

-(void)registerUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"注册成功" hideAfterDelay:1.7];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (IBAction)actionIsGreenRule:(id)sender {
    
}
- (IBAction)actionLookRule:(id)sender {
    
    WebShowViewController *showViewVC = [[WebShowViewController alloc]init];
    showViewVC.title = @"用户注册协议";
    [self.navigationController pushViewController:showViewVC animated:YES];
    
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField == tfUserPwd) {
        regex = @"^[A-Za-z0-9]";
        
    }else{
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == tfUserTel) {
        if (str.length >11) {
            [self showPromptText: @"手机号码不能超过11位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    if (textField == tfUserPwd) {
        
        if (str.length >16) {
            [self showPromptText: @"密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    if (textField == tfCheckCode) {
        tfCheckCode.rightView.hidden = YES;
        if (str.length == 6) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (tfUserTel.text.length <11) {
                    [self showPromptText: @"请先输入有效的手机号码" hideAfterDelay: 1.7];
                    
                }else{
                    
                    [self.memberMan checkRegisterSms:@{@"mobile":tfUserTel.text,@"checkCode":str}];
                }
            });
        }
        
        if (str.length >6) {
            [self showPromptText: @"验证码不能超过6位" hideAfterDelay: 1.7];
            return NO;
        }
      
    }
    
    if (textField == tfRecomCode) {
        
        if (str.length >8) {
            [self showPromptText: @"分享码不能超过8位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

-(void)checkRegisterSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    tfCheckCode.rightView.hidden = !success;
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"验证成功" hideAfterDelay:1.7];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (IBAction)actionNeedShareCode:(UIButton *)sender {
    sender.selected = !sender.selected;
    tfRecomCode.hidden =  !sender.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
