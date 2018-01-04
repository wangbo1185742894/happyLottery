//
//  ShareViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/3.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *coedBtn;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    NSString *code=self.curUser.shareCode;
    if (code.length>0) {
        self.codeLab.text=code;
    }
}
- (IBAction)shareBtnClick:(id)sender {
}
- (IBAction)codeBtnClick:(id)sender {
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
