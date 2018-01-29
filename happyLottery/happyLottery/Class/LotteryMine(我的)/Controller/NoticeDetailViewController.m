//
//  NoticeDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/29.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation NoticeDetailViewController
@synthesize notice;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    //notice =[[Notice alloc]init];
    [self loade];
}
-(void)loade{
    
    self.titleLab.text = notice.title;
    self.noticeLab.text = notice.content;
    self.dateLab.text = notice.endTime;
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
