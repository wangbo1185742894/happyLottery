//
//  LoginViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/13.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    
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
   self.grayImage.frame =CGRectMake(0,[self isIphoneX]?88:0, KscreenWidth, 175.0/375 * KscreenWidth);
    if ([self isIphoneX]) {
        self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
//        _bigViewTop =[NSLayoutConstraint constraintWithItem:self.bigView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40];
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
    [registerBtn addTarget: self action: @selector(registerBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)setIcon{
    UIImage *image = [UIImage imageNamed:@"user"];
    UIImageView *userimage = [[UIImageView alloc]initWithImage:image];
    userimage.frame = CGRectMake(10, 0, 20, 20);
   // userimage.image = [UIImage imageNamed:@"user"];
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userTextField.leftView = userimage;
    
    UIImageView *pwdimage = [[UIImageView alloc]init];
    userimage.image = [UIImage imageNamed:@"password"];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = pwdimage;
    
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

-(void)registerBtnClick{
    
    
}
- (IBAction)loginBtnClick:(id)sender {
}
- (IBAction)forgetBtnClick:(id)sender {
}
- (IBAction)registerBtnClick:(id)sender {
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
