//
//  ChangeLoginPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ChangeLoginPWDViewController.h"
#import "AESUtility.h"

@interface ChangeLoginPWDViewController ()<MemberManagerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *PWD1;
@property (weak, nonatomic) IBOutlet UITextField *PWD3;
@property (weak, nonatomic) IBOutlet UITextField *PWD2;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ChangeLoginPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改登录密码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    
    self.memberMan.delegate = self;
    self.PWD1.delegate = self;
    self.PWD2.delegate = self;
    self.PWD3.delegate = self;
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)commitBtnClick:(id)sender {
    if ( self.PWD1.text.length == 0||  self.PWD1.text.length < 6 ) {

        [self showPromptText: @"请输入6-16位初始密码" hideAfterDelay: 1.7];
        return;
    }
    else if (self.PWD2.text.length == 0 || self.PWD2.text.length < 6 ) {
       
        [self showPromptText: @"请输入6-16位新密码" hideAfterDelay: 1.7];
        return;
    } else if (self.PWD3.text.length == 0 || self.PWD3.text.length < 6 ) {
        
        [self showPromptText: @"请输入6-16位确认密码" hideAfterDelay: 1.7];
        return;
    }
    else if(![_PWD2.text isEqualToString:_PWD3.text]){
        [self showPromptText: @"两次输入的密码不一致！" hideAfterDelay: 1.7];
        return ;
    }
    else{
        
        [self commitClient];
    }
}


-(void)commitClient{
    
    NSDictionary *resetPWDInfo;
    @try {
        NSString *pwd1 = self.PWD1.text;
        NSString *pwd2 = self.PWD2.text;
        
        NSString *mobile = self.curUser.mobile;
        
        resetPWDInfo = @{@"mobile":mobile,
                            @"oldPwd": [AESUtility encryptStr: pwd1],
                            @"newPwd":[AESUtility encryptStr: pwd2],
                            @"channelCode":CHANNEL_CODE
                            };
        
    } @catch (NSException *exception) {
       return;
    }
        [self.memberMan changeLoginPWDSms:resetPWDInfo];
  
}

-(void)changeLoginPWDSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"修改登录密码成功" hideAfterDelay:1.7];
        self.curUser.isLogin = NO;
        [self updateLoginStatus];
        [self needLoginCompletion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
      
        
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

-(void)updateLoginStatus{
    
    if ([self.fmdb open]) {
        NSString *mobile =self.curUser.mobile;
        NSString * isLogin =@"0";
        //update t_student set score = age where name = ‘jack’ ;
        [self.fmdb executeUpdate:@"update  t_user_info set isLogin = ? where mobile = ?",isLogin, mobile];
        [self.fmdb close];
    }
}

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.PWD1.text.length > 0) {
            self.PWD2.enabled = YES;
        }
        
        if (self.PWD2.text.length >0) {
            self.PWD3.enabled = YES;
        }
        if (self.PWD3.text.length >= 6 && self.PWD2.text.length >=6  && self.PWD1.text.length >= 6) {
            self.commitBtn.enabled = YES;
        }else{
            self.commitBtn.enabled = NO;
        }
    });
    
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
            [self showPromptText: @"初始密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    if (textField ==  self.PWD2 ) {
        
        if (str.length >16 ) {
            [self showPromptText: @"新密码不能超过16位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    
    if (textField ==  self.PWD3 ) {
        
        if (str.length >16) {
            [self showPromptText: @"确认密码不能超过16位" hideAfterDelay: 1.7];
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
    //    if (textField == self.PWD1 ) {
    //        if (![self checkPassWord:self.PWD1.text]) {
    //            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
    //            self.PWD1.text= @"";
    //            return;
    //        }
    //
    //    }else  if (textField == self.PWD2 ) {
    //        if (![self checkPassWord:self.PWD2.text]) {
    //            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
    //            self.PWD2.text= @"";
    //            return;
    //        }
    //
    //    } else if (textField == self.PWD3) {
    //
    //        if (![self checkPassWord:self.PWD3.text]) {
    //            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
    //            self.PWD3.text= @"";
    //            return;
    //        }
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
