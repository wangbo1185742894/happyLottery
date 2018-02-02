//
//  SetPayPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//首次设置

#import "SetPayPWDViewController.h"
#import "AESUtility.h"
#import "PersonnalCenterViewController.h"
#define KCheckSec 60
@interface SetPayPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger checkSec;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDAgainTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCheckCode;
@property (weak, nonatomic) IBOutlet UIView *viewCheckContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disContentViewTop;

@property (weak, nonatomic) IBOutlet UITextField *tfCheckCode;

@end

@implementation SetPayPWDViewController
@synthesize titleStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isForeget == YES) {
        self.viewCheckContent.hidden = NO;
        self.disContentViewTop.constant = 20;
        _payPWDTextField.enabled = NO;
    }else{
        self.disContentViewTop.constant = -40;
        self.viewCheckContent.hidden = YES;
        _payPWDTextField.enabled = YES;
    }
    
    if (![self.titleStr isEqualToString:@""]) {
         self.title =  titleStr;
    }
    //self.title = @"设置支付密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
      
    }
    checkSec = KCheckSec;
    
    _btnSendCheckCode.layer.cornerRadius = 3;
    _btnSendCheckCode.layer.masksToBounds = YES;
    
    [_btnSendCheckCode setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [_btnSendCheckCode setBackgroundImage:[UIImage imageWithColor:BtnDisAbleBackColor] forState:UIControlStateDisabled];
    
    
    self.memberMan.delegate = self;
    self.tfCheckCode.delegate = self;
    self.mobileTextField.delegate = self;
    self.payPWDTextField.delegate = self;
    self.payPWDAgainTextField.delegate = self;
    self.mobileTextField.text = self.curUser.mobile;
}

-(void)bandPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"设置支付密码成功" hideAfterDelay:1.7];
        self.curUser.paypwdSetting = YES;
           [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
        
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}
- (void)delayMethod{
    if (self.isForeget) {
        BOOL isPop = NO;
        for (BaseViewController *baseVC in self.navigationController.viewControllers) {
            if ([baseVC isKindOfClass:[PersonnalCenterViewController class]]) {
                [self.navigationController popToViewController:baseVC animated:YES];
                isPop = YES;
                break;
            }
        }
        if (isPop == NO) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)commitBtnClick:(id)sender {
    NSString *pwd1 = self.payPWDTextField.text;
    NSString *pwd2 = self.payPWDAgainTextField.text;
    
    if (_payPWDTextField.text.length == 0 || _payPWDTextField.text.length < 6) {
        self.payPWDTextField.text=@"";
        [self showPromptText: @"请输入6位支付密码" hideAfterDelay: 1.7];
        return;
    }
    else if (_payPWDAgainTextField.text.length == 0  || _payPWDAgainTextField.text.length < 6) {
        self.payPWDTextField.text=@"";
        [self showPromptText: @"请输入6位确认密码" hideAfterDelay: 1.7];
        return;
    }
//    else if (_mobileTextField.text.length < 11) {
//        [self showPromptText: @"请输入11位手机号" hideAfterDelay: 1.7];
//        return;
//    }
    else if(![pwd1 isEqualToString:pwd2]){
        [self showPromptText: @"两次输入的密码不一致！" hideAfterDelay: 1.7];
         self.payPWDTextField.text=@"";
         self.payPWDAgainTextField.text=@"";
        return ;
    }
    else{
        
        [self commitClient];
    }
}


-(void)commitClient{
    
    NSDictionary *resetPayPWDInfo;
    @try {
        NSString *mobile = self.mobileTextField.text;
        NSString *pwd1 = self.payPWDTextField.text;
        
        resetPayPWDInfo = @{@"mobile":mobile,
                            @"newPaypwd": [AESUtility encryptStr: pwd1],
                            @"channelCode":CHANNEL_CODE
                            };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan bandPayPWDSms:resetPayPWDInfo];
}



#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isForeget == YES) {
            __weak typeof(self) WeakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (WeakSelf.tfCheckCode.text.length == 6 && self.payPWDTextField.enabled == NO) {
                        [WeakSelf.memberMan checkUpdatePaypwdSms:@{@"mobile":WeakSelf.curUser.mobile,@"checkCode":WeakSelf.tfCheckCode.text}];
                }
            });
         
        }
        if (_payPWDTextField.text.length >=6) {
            _payPWDAgainTextField.enabled = YES;
        }else{
            _payPWDAgainTextField.enabled = NO;
        }
        if (_payPWDAgainTextField.text.length >= 6 && _payPWDTextField.text.length >= 6) {
            _btnSubmit.enabled = YES;
        }else{
            _btnSubmit.enabled = NO;
        }
    });

    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField ==  self.payPWDTextField ||textField ==  self.payPWDAgainTextField) {
        regex = @"^[A-Za-z0-9]";
        
    }else{
        regex = @"^[0-9]";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (textField ==  self.payPWDTextField) {
        
        if (str.length >6 ) {
            
            return NO;
        }
    }
    if (textField ==  self.payPWDAgainTextField ) {
        
        if (str.length >6 ) {
            
            return NO;
        }
    }

//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:string];
//    return isMatch;
    return YES;
}

-(void)checkUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == YES) {
        _payPWDTextField.enabled = YES;
        [self showPromptText:@"验证码验证成功" hideAfterDelay:1.7];
        
    }else{
        [self showPromptText:msg hideAfterDelay:1.8];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //    [self setBoaderColor:textField color:SystemGreen];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == self.payPWDTextField ) {
//        if (![self checkPassWord:self.payPWDTextField.text]) {
//            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
//            self.payPWDTextField.text= @"";
//            return;
//        }
//
//    }else  if (textField == self.payPWDAgainTextField ) {
//        if (![self checkPassWord:self.payPWDAgainTextField.text]) {
//            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
//            self.payPWDAgainTextField.text= @"";
//            return;
//        }
//
//    }
    [self.view resignFirstResponder];
}

#pragma mark 判断密码
-(BOOL)checkPassWord:(NSString *)passWords
{
    //6-20位数字和字母组成
    //NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REG_PASSWORD_STR];
    if ([pred evaluateWithObject:passWords]) {
        return YES ;
    }else
        return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSendCheckCode:(UIButton *)sender {
    if (self.curUser.mobile == nil) {
        return;
    }
    [self.memberMan sendUpdatePaypwdSms:@{@"mobile":self.curUser.mobile}];
}

-(void)sendUpdatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == YES) {
        [self showPromptText:@"发送成功" hideAfterDelay:1.7];
        _tfCheckCode.enabled = YES;
        [self startTimer];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)startTimer{
    [_btnSendCheckCode setEnabled:NO];
    
    [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
    
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (checkSec > 0) {
                checkSec --;
                [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
            }else{
                checkSec = KCheckSec;
                [timer invalidate];
                [_btnSendCheckCode setTitle:@"获取验证码" forState:0];
                [_btnSendCheckCode setTitle:[NSString stringWithFormat:@"重新发送(%lds)",checkSec] forState:UIControlStateDisabled];
                [_btnSendCheckCode setEnabled: YES];
            }
        }];
    } else {
        
    }
    
}


@end
