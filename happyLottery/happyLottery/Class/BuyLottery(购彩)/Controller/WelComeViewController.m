//
//  WelComeViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/3/29.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "WelComeViewController.h"

@interface WelComeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@end

@implementation WelComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)setImg:(NSString *)url{
    [self .imgBack sd_setImageWithURL:[NSURL URLWithString:url]];
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
