//
//  ChangePayPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/20.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ChangePayPWDViewController.h"
#import "AESUtility.h"
#import "SetPayPWDViewController.h"

@interface ChangePayPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *PWD1;
@property (weak, nonatomic) IBOutlet UITextField *PWD2;
@property (weak, nonatomic) IBOutlet UITextField *PWD3;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation ChangePayPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    
    self.memberMan.delegate = self;
    self.PWD1.delegate = self;
    self.PWD2.delegate = self;
    self.PWD3.delegate = self;
}

-(void)resetPayPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"修改支付密码" hideAfterDelay:1.7];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}
- (IBAction)commitBtnClick:(id)sender {
    if ( self.PWD1.text.length < 6 ||  self.PWD1.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
    else if (self.PWD2.text.length < 6 || self.PWD2.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    } else if (self.PWD3.text.length < 6 || self.PWD3.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
    else if(![_PWD2.text isEqualToString:_PWD3.text]){
        [self showPromptText: @"两次输入的密码不一致！" hideAfterDelay: 1.7];
        _PWD2.text=@"";
        _PWD3.text=@"";
        return ;
    }
    else{

        [self commitClient];
    }
}

-(void)commitClient{
    
    NSDictionary *resetPayPWDInfo;
    @try {
        NSString *pwd1 = self.PWD1.text;
        NSString *pwd2 = self.PWD2.text;
        NSString *pwd3 = self.PWD3.text;
           NSString *mobile = self.curUser.mobile;
        
        resetPayPWDInfo = @{@"mobile":mobile,
                          @"oldPaypwd": [AESUtility encryptStr: pwd1],
                          @"newPaypwd":[AESUtility encryptStr: pwd2],
                          @"channelCode":CHANNEL_CODE
                          };
        
    } @catch (NSException *exception) {
        resetPayPWDInfo = nil;
    } @finally {
        [self.memberMan resetPayPWDSms:resetPayPWDInfo];
    }
    
}
- (IBAction)forgetBtnClick:(id)sender {
    SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
    spvc.titleStr = @"忘记支付密码";
    [self.navigationController pushViewController:spvc animated:YES];
}


#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField ==  self.PWD1 ||textField ==  self.PWD2||textField ==  self.PWD3) {
        regex = @"^[A-Za-z0-9]";
        
    }else{
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
  
    if (textField ==  self.PWD1) {
        
        if (str.length >16 ) {
            [self showPromptText: @"密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    if (textField ==  self.PWD2 ) {
        
        if (str.length >16 ) {
            [self showPromptText: @"密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
   
    if (textField ==  self.PWD3 ||str.length < 6) {
        
        if (str.length >16) {
            [self showPromptText: @"密码在6-16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self setBoaderColor:textField color:SystemGreen];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.PWD1 ) {
        if (![self checkPassWord:self.PWD1.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
            self.PWD1.text= @"";
            return;
        }
        
    }else  if (textField == self.PWD2 ) {
        if (![self checkPassWord:self.PWD2.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
            self.PWD2.text= @"";
            return;
        }
        
    } else if (textField == self.PWD3) {
        
        if (![self checkPassWord:self.PWD3.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
            self.PWD3.text= @"";
            return;
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
