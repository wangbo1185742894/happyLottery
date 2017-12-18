//
//  LoginViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/13.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPWDViewController.h"
#import "AESUtility.h"

@interface LoginViewController ()<MemberManagerDelegate,UITextFieldDelegate>{
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *fimageView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *grayImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewTop;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登陆";
    self.memberMan.delegate = self;
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.grayImage.frame =CGRectMake(0,[self isIphoneX]?88:0, KscreenWidth, 175.0/375 * KscreenWidth);
    if ([self isIphoneX]) {
        self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bigViewTop.constant = 88;
    }
    [self setIcon];
    [self setNavigationBack];
    if ([self .fmdb open]) {
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_user_info"];
        if ([result next] && [result stringForColumn:@"mobile"] != nil) {
            self.userTextField.text =[result stringForColumn:@"mobile"];
        }
    }
}

//登陆接口请求服务器
-(void)loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"%@",userInfo);
    User *user = [[User alloc]initWith:userInfo];
    user.loginPwd = self.passwordTextField.text;
    user.isLogin = YES;
    [GlobalInstance instance].curUser = user;
    
    if (success) {
        [self showPromptText: @"登陆成功"  hideAfterDelay: 1.7];
        [self saveUserInfo];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self showPromptText: @"登陆失败"  hideAfterDelay: 1.7];
        [self showPromptText:msg];
    }
}

-(void)saveUserInfo{
    
    if ([self.fmdb open]) {
        User *user = [GlobalInstance instance].curUser;
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_user_info"];
        NSLog(@"%@",result);
        BOOL issuccess = NO;
        
        do {
            NSString *mobile = [result stringForColumn:@"mobile"];
            if ([mobile isEqualToString:user.mobile]) {
                
                issuccess= [self.fmdb executeUpdate:@"update t_user_info set cardCode = ? ,loginPwd = ?,isLogin = ? where mobile = ? ",user.cardCode,user.loginPwd,@(user.isLogin),user.mobile];
            }else{
                issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
            }
        } while ([result next]);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserLogin object:nil];
        [result close];
        [self.fmdb close];
    }
}

-(void)loginUserClient{

    NSDictionary *loginInfo;
    @try {
        NSString *mobile = self.userTextField.text;
        NSString *pwd = self.passwordTextField.text;
        
        loginInfo = @{@"mobile":mobile,
                       @"pwd": [AESUtility encryptStr: pwd],
                       @"channelCode":CHANNEL_CODE
                       };
        
    } @catch (NSException *exception) {
        loginInfo = nil;
    } @finally {
        [self.memberMan loginCurUser:loginInfo];
    }
    
}

-(void)setIcon{
    
    [self.userTextField setLeftView:@"user" rightView:nil];
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userTextField.keyboardType =UIKeyboardTypeNumberPad;
    [self.passwordTextField setLeftView:@"password" rightView:nil];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
}

-(void)setNavigationBack{
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackToLastPage)];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

-(void)navigationBackToLastPage{
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:NO completion:^{

        }];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (IBAction)loginBtnClick:(id)sender {
    [self loginUserClient];
}
- (IBAction)forgetBtnClick:(id)sender {
    ForgetPWDViewController *forgetVC = [[ForgetPWDViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//11.02 检测键盘输入位数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES ;
}
#pragma mark 判断密码
-(BOOL)checkPassWord:(NSString *)passWords
{
   
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


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:SystemGreen];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setBoaderColor:textField color:TFBorderColor];
    if (textField == _userTextField) {
        if (![self checkPhoneNumber:self.userTextField.text]) {
            [self showPromptText: @"请输入合法的手机号码" hideAfterDelay: 1.7];
            self.userTextField.text= @"";
            return;
        }
        
    } else  if (textField == _passwordTextField) {
        if (![self checkPassWord:self.passwordTextField.text]) {
            [self showPromptText: @"请输入6-16密码，由英文字母或数字组成" hideAfterDelay: 1.7];
             self.passwordTextField.text= @"";
            return;
        }
        
    }
    [self.view resignFirstResponder];
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
