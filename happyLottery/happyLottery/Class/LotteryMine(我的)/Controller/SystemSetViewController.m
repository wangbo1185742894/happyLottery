//
//  SystemSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/29.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "SystemSetViewController.h"
#import "AboutViewController.h"

@interface SystemSetViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;

@end

@implementation SystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A208";
    self.title = @"系统设置";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
}

- (IBAction)switch2Click:(id)sender {
}
- (IBAction)aboutBtnClick:(id)sender {
    AboutViewController *ab = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:ab animated:YES];
}
- (IBAction)versionBtnClick:(id)sender {

}
- (IBAction)quitBtnClick:(id)sender {
    self.curUser.isLogin = NO;
    [self updateLoginStatus];
    [self.navigationController popViewControllerAnimated:YES];
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
