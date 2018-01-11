//
//  ForgetPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "AESUtility.h"
#define KCheckSec 60
@interface ForgetPWDViewController()<MemberManagerDelegate,UITextFieldDelegate>{
    
    int seconds;
    UILabel * labelCountDown;
    NSTimer * countDownTimer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *HeadportraitImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *PWDTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *PWDTextAgainField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.memberMan.delegate = self;
    self.phoneTextField.delegate = self;
    self.VerificationCodeTextField.delegate = self;
    self.PWDTextField.delegate = self;
    self.PWDTextAgainField.delegate = self;
     labelCountDown = [[UILabel alloc] init];
    //self.commitBtn.enabled = NO;
    [self setIcon];
    if ([self isIphoneX]) {
       // self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.viewTop.constant = 88;
    }
}

-(void)sendForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
         [self startCountDown];
        [self showPromptText: @"发送成功" hideAfterDelay: 1.7];
       
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}
-(void)checkForgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    _VerificationCodeTextField.rightView.hidden = !success;
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"验证成功" hideAfterDelay:1.7];
    }else{
        
        //[self showPromptText:msg hideAfterDelay:1.7];
          [self showPromptText:@"验证码错误！" hideAfterDelay:1.7];
        _VerificationCodeTextField.text = @"";
      
    }
}

-(void)forgetPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    _VerificationCodeTextField.rightView.hidden = !success;
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"重置密码成功" hideAfterDelay:1.7];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (IBAction)getVerifyCodeBtnClick:(id)sender {
   
    
    //verify phone number
    NSString *phoneNumber =self.phoneTextField.text;
    if ( [phoneNumber isEqualToString:@""]) {
        [self showPromptText: @"请输入合法的手机号码!"  hideAfterDelay: 1.7];
        return;
    }
    
  
    
    //[self showLoadingViewWithText:@"正在加载..."];
    
    [self.memberMan sendForgetPWDSms:@{@"mobile":phoneNumber}];
    _getVerifyCodeBtn.enabled = NO;
    seconds = KCheckSec;
//  
//        labelCountDown.frame =_getVerifyCodeBtn.frame;
//        [_getVerifyCodeBtn.superview addSubview: labelCountDown];
//        labelCountDown.backgroundColor = [UIColor clearColor];
//        labelCountDown.textAlignment = NSTextAlignmentCenter;
//        labelCountDown.font = [UIFont boldSystemFontOfSize: 19];
//        labelCountDown.textColor = [UIColor whiteColor];
//  
//    labelCountDown.text = [NSString stringWithFormat: @"%d", seconds];
//    labelCountDown.hidden = NO;

}


- (void) startCountDown {
    [_getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ds)",KCheckSec] forState:UIControlStateDisabled];
    if (@available(iOS 10.0, *)) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (seconds > 0) {
                seconds --;
                [_getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ds)",seconds] forState:UIControlStateDisabled];
            }else{
                seconds = KCheckSec;
                [countDownTimer invalidate];
                [_getVerifyCodeBtn setTitle:@"获取验证码" forState:0];
                [_getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ds)",seconds] forState:UIControlStateDisabled];
                [_getVerifyCodeBtn setEnabled: YES];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (IBAction)commitBtnClick:(id)sender {
    if (_VerificationCodeTextField.text.length < 5) {
        [self showPromptText: @"请输入有效的验证码" hideAfterDelay: 1.7];
        return;
    }
    
    else if (_PWDTextField.text.length < 6 || _PWDTextField.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
    else if (_PWDTextAgainField.text.length < 6 || _PWDTextAgainField.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
   else if (_phoneTextField.text.length < 11) {
        [self showPromptText: @"请输入有效手机号" hideAfterDelay: 1.7];
        return;
   }else if(![_PWDTextAgainField.text isEqualToString:_PWDTextField.text]){
       [self showPromptText: @"两次输入的密码不一致！" hideAfterDelay: 1.7];
       _PWDTextAgainField.text=@"";
       _PWDTextField.text=@"";
       return ;
   }
   else{
        
        
       
        [self commitClient];
    }

}

-(void)commitClient{
    
    NSDictionary *forgetPWDInfo;
    @try {
        NSString *mobile = self.phoneTextField.text;
        NSString *pwd = self.PWDTextAgainField.text;
        NSString *checkCode = self.VerificationCodeTextField.text;
        
        forgetPWDInfo = @{@"mobile":mobile,
                      @"newPwd": [AESUtility encryptStr: pwd],
                      @"checkCode":checkCode,
                      @"channelCode":CHANNEL_CODE
                      };
        
    } @catch (NSException *exception) {
        forgetPWDInfo = nil;
    } @finally {
        [self.memberMan forgetPWDSms:forgetPWDInfo];
    }
    
}
-(void)setIcon{
    [self.phoneTextField setLeftView:@"phone" rightView:nil];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.VerificationCodeTextField setLeftView:@"captcha" rightView:@"checksuccess"];
    self.VerificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.VerificationCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.VerificationCodeTextField.rightView.hidden = YES;
    [self.PWDTextField setLeftView:@"password" rightView:nil];
    self.PWDTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.PWDTextAgainField setLeftView:@"password" rightView:nil];
    self.PWDTextAgainField.leftViewMode = UITextFieldViewModeAlways;

    
}

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField == _PWDTextField ||textField == _PWDTextAgainField) {
        regex = @"^[A-Za-z0-9]";
        
    }else{
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == _phoneTextField) {
        if (str.length >11) {
            [self showPromptText: @"手机号码不能超过11位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    if (textField == _PWDTextField ) {
        
        if (str.length >16) {
            [self showPromptText: @"密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    if (textField == _VerificationCodeTextField) {
        _VerificationCodeTextField.rightView.hidden = YES;
        if (str.length == 6) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_phoneTextField.text.length <11) {
                    [self showPromptText: @"请先输入有效的手机号码" hideAfterDelay: 1.7];
                    
                }else{
                    
                    [self.memberMan checkForgetPWDSms:@{@"mobile":_phoneTextField.text,@"checkCode":str}];
                }
            });
        }
        
        if (str.length >6) {
            [self showPromptText: @"验证码不能超过6位" hideAfterDelay: 1.7];
            return NO;
        }
      
        
    }
    if (textField == _PWDTextAgainField) {

        if (str.length >16) {
            [self showPromptText: @"密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
   
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:SystemGreen];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:TFBorderColor];
    if (textField == self.phoneTextField) {
        if (![self checkPhoneNumber:self.phoneTextField.text]) {
            [self showPromptText: @"请输入合法的手机号码" hideAfterDelay: 1.7];
            self.phoneTextField.text= @"";
            return;
        }

    } else  if (textField == _PWDTextField ) {
        if (![self checkPassWord:self.PWDTextField.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
            self.PWDTextField.text= @"";
            return;
        }

    }else  if (textField == _PWDTextAgainField ) {
        if (![self checkPassWord:self.PWDTextAgainField.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
            self.PWDTextAgainField.text= @"";
            return;
        }
        
    } else if (textField == _VerificationCodeTextField) {
        
        if (_VerificationCodeTextField.text.length >6) {
            [self showPromptText: @"验证码不能超过6位" hideAfterDelay: 1.7];
            self.VerificationCodeTextField.text= @"";
            return ;
        }
    }
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
#pragma mark 判断电话号码
-(BOOL)checkPhoneNumber:(NSString *)phone
{
    //正则表达式
    //NSString *pattern = @"^1+[3578]+\\d{9}$";
    //创建一个谓词,一个匹配条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REG_PHONENUM_STR];
    //评估是否匹配正则表达式
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;
}

-(void)setBoaderColor:(UITextField *)textField color:(UIColor*)color{
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
