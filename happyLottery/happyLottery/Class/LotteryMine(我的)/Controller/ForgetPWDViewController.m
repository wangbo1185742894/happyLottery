//
//  ForgetPWDViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ForgetPWDViewController.h"

@interface ForgetPWDViewController()<MemberManagerDelegate,UITextFieldDelegate>
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
    self.title = @"登陆密码重置";
    self.memberMan.delegate = self;
    self.phoneTextField.delegate = self;
    self.VerificationCodeTextField.delegate = self;
    self.PWDTextField.delegate = self;
    self.PWDTextAgainField.delegate = self;
    [self setIcon];
    if ([self isIphoneX]) {
       // self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.viewTop.constant = 88;
    }
}
- (IBAction)getVerifyCodeBtnClick:(id)sender {
    
}
- (IBAction)commitBtnClick:(id)sender {
    
}
-(void)setIcon{
    [self.phoneTextField setLeftView:@"phone" rightView:nil];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.VerificationCodeTextField setLeftView:@"captcha" rightView:nil];
    self.VerificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.PWDTextField setLeftView:@"password" rightView:nil];
    self.PWDTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.PWDTextAgainField setLeftView:@"password" rightView:nil];
    self.PWDTextAgainField.leftViewMode = UITextFieldViewModeAlways;

    
}

#pragma UITextFieldDelegate
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
