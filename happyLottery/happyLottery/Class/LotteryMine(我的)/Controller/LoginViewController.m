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
#import "JPUSHService.h"

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
static NSInteger seq = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.fimageView.layer.cornerRadius = 30;
    self.loginBtn.enabled = NO;
    self.fimageView.layer.masksToBounds = YES;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_userTextField.text.length == 11) {
        _passwordTextField.enabled = YES;
    }
}

- (NSInteger)seq {
    return ++ seq;
}

//登陆接口请求服务器
-(void)loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"%@",userInfo);
    /* userInfo: balance = 0;
    cardCode = 10000004;
    channelCode = TBZ;
    couponCount = 0;
    id = 0;
    memberType = "FREEDOM_PERSON";
    mobile = 15591986891;
    notCash = 0;
    parentId = 0;
    registerTime = 1513568027000;
    score = 0;
    sendBalance = 0;
    whitelist = 0;*/
    User *user = [[User alloc]initWith:userInfo];
    user.loginPwd = [self.passwordTextField.text lowercaseString];
    user.isLogin = YES;
    [GlobalInstance instance].curUser = user;
    [self upLoadClientInfo];
   
    
    if (success) {
         [self showPromptText: @"登录成功"  hideAfterDelay: 1.7];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1];
       
        [self saveUserInfo];
        [JPUSHService setTags:nil alias:self.curUser.cardCode callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
     
    }else{
        //[self showPromptText: @"登录失败"  hideAfterDelay: 1.7];
        [self showPromptText:msg  hideAfterDelay: 1.7];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)delayMethod{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveUserInfo{
    
    if ([self.fmdb open]) {
        User *user = [GlobalInstance instance].curUser;
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_user_info"];
        NSLog(@"%@",result);
        BOOL issuccess = NO;
        NSInteger payVerifyType = 1;
        do {
            NSString *mobile = [result stringForColumn:@"mobile"];
          
            if ([mobile isEqualToString: self.curUser.mobile]) {
                payVerifyType = [[result stringForColumn:@"payVerifyType"] integerValue];
                issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
                
            }else{
                issuccess= [self.fmdb executeUpdate:@"delete from t_user_info where mobile = ? ",mobile];
            }
           

        } while ([result next]);
        [self.fmdb executeUpdate:@"insert into t_user_info (cardCode , loginPwd , isLogin , mobile , payVerifyType) values ( ?,?,?,?,?)  ",user.cardCode,user.loginPwd,@"1",user.mobile,[NSString stringWithFormat:@"%ld",payVerifyType]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserLogin object:nil];
        [result close];
        [self.fmdb close];
    }
}

-(void)loginUserBySuccessReg:(NSString *)mobile andPwd:(NSString *)pwd{
    
    NSDictionary *loginInfo;
    @try {
        loginInfo = @{@"mobile":mobile,
                      @"pwd": [AESUtility encryptStr: pwd],
                      @"channelCode":CHANNEL_CODE
                      };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan loginCurUser:loginInfo];
  
}

-(void)loginUserClient{

    NSDictionary *loginInfo;
    @try {
        NSString *mobile = self.userTextField.text;
        NSString *pwd = [self.passwordTextField.text lowercaseString];
        
        loginInfo = @{@"mobile":mobile,
                    @"pwd": [AESUtility encryptStr: pwd],
                    @"channelCode":CHANNEL_CODE
                       };
        
    } @catch (NSException *exception) {
       return;
    }
        [self.memberMan loginCurUser:loginInfo];
 
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
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 16) {
        [self showPromptText: @"请输入有效的密码" hideAfterDelay: 1.7];
        return;
    }
    
    else if (_userTextField.text.length < 11) {
        [self showPromptText: @"请输入有效手机号" hideAfterDelay: 1.7];
        return;
    }else{
        
          [self loginUserClient];
    }
 
}
- (IBAction)forgetBtnClick:(id)sender {
    ForgetPWDViewController *forgetVC = [[ForgetPWDViewController alloc]init];
    forgetVC.strTel = self.userTextField.text;
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.loginVC = self;
    [self.navigationController pushViewController:registerVC animated:YES];
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
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_userTextField.text.length == 11) {
            _passwordTextField.enabled = YES;
        }else{
            _passwordTextField.enabled = NO;
        }
        
        if (_userTextField.text.length == 11 && _passwordTextField.text.length >=6) {
            _loginBtn.enabled = YES;
        }else{
            _loginBtn.enabled = NO;
        }
    });
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField == _passwordTextField ) {
        regex = @"^[A-Za-z0-9]";
        
    }else{
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == _userTextField) {
        if (str.length >11) {
            
            return NO;
        }
    }
    
    if (textField == _passwordTextField ) {
        
        if (str.length >16) {
            
            return NO;
        }
    }
  
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
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
    
}


@end
