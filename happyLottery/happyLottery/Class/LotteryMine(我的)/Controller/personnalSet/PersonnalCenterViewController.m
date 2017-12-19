//
//  PersonnalCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PersonnalCenterViewController.h"
#import "MyNickSetViewController.h"

@interface PersonnalCenterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *myImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UIButton *myNickBtn;
@property (weak, nonatomic) IBOutlet UILabel *myNickLab;
@property (weak, nonatomic) IBOutlet UIButton *myCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *myCardLab;
@property (weak, nonatomic) IBOutlet UIButton *paySetBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateLoginPWDBtn;
@property (weak, nonatomic) IBOutlet UIButton *updatePayPWDBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation PersonnalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    if ([self isIphoneX]) {
        // self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
}

- (IBAction)updateImage:(id)sender {
}

- (IBAction)setMember:(id)sender {
}
- (IBAction)setNick:(id)sender {
    MyNickSetViewController * nickVC = [[MyNickSetViewController alloc]init];
   // self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nickVC animated:YES];
}
- (IBAction)addCard:(id)sender {
}
- (IBAction)cardPaySet:(id)sender {
}
- (IBAction)changePayPWD:(id)sender {
}
- (IBAction)changeLoginPWD:(id)sender {
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
