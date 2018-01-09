//
//  SetPayPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//首次设置

#import "SetPayPWDViewController.h"
#import "AESUtility.h"

@interface SetPayPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *payPWDAgainTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;


@end

@implementation SetPayPWDViewController
@synthesize titleStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.titleStr isEqualToString:@""]) {
         self.title =  titleStr;
    }
    //self.title = @"设置支付密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
      
    }
    self.memberMan.delegate = self;
    self.mobileTextField.delegate = self;
    self.payPWDTextField.delegate = self;
    self.payPWDAgainTextField.delegate = self;
    self.mobileTextField.text = self.curUser.mobile;
}

-(void)bandPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"设置支付密码" hideAfterDelay:1.7];
           [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
        
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (void)delayMethod{
   [self.navigationController popViewControllerAnimated:YES];
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
        resetPayPWDInfo = nil;
    } @finally {
        [self.memberMan bandPayPWDSms:resetPayPWDInfo];
    }
    
}



#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
            [self showPromptText: @"设置密码不能超过6位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    if (textField ==  self.payPWDAgainTextField ) {
        
        if (str.length >6 ) {
            [self showPromptText: @"确认密码不能超过6位" hideAfterDelay: 1.7];
            return NO;
        }
    }

    
    
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:string];
//    return isMatch;
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
