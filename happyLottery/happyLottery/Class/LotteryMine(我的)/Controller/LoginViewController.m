//
//  LoginViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/13.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<MemberManagerDelegate>{
    
    UIButton *registerBtn;
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
   self.grayImage.frame =CGRectMake(0,[self isIphoneX]?88:0, KscreenWidth, 175.0/375 * KscreenWidth);
    if ([self isIphoneX]) {
        self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bigViewTop.constant = 88;
    }
    [self setIcon];
    [self setNavigationBack];
}

-(void)registerBtnSet{
    registerBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0, 0, 35, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: registerBtn];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setImage:[UIImage imageNamed:@"news_ _bj_default@2x.png"] forState:UIControlStateNormal];
//    [registerBtn addTarget: self action: @selector(registerBtnClick) forControlEvents: UIControlEventTouchUpInside];
}
//登陆接口请求服务器
-(void)loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"%@",userInfo);
    if (success) {
       // [[GlobalInstance instance] userInfoUpdated];

        [self loginUserClient];
        
        
        //上传手机信息
        
    }else{
        
        [self showPromptText:msg];
    }
}

-(void)loginUserClient{

    NSDictionary *loginInfo;
    @try {
        loginInfo = @{@"mobile":self.userTextField.text==nil?@"":self.userTextField.text,
                       @"pwd":self.passwordTextField.text,
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
    [self.passwordTextField setLeftView:@"password" rightView:nil];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
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
    
}
- (IBAction)forgetBtnClick:(id)sender {
    
}
- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//11.02 检测键盘输入位数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _userTextField) {
        if(range.length == 1){
            return YES;
        }else if (range.length == 0){
            NSString * regex;
            regex = @"^[0-9]";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:string];
            if (!isMatch) {
                return NO;
            }
        }
        
        
        if (range.location == 11) {
            return NO;
        }
        
    }
    return YES;
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
