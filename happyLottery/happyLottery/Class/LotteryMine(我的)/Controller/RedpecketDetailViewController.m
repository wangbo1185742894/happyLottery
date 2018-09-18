//
//  RedpecketDetailViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RedpecketDetailViewController.h"

@interface RedpecketDetailViewController ()
    @property (weak, nonatomic) IBOutlet UILabel *labRedCost;
    @property (weak, nonatomic) IBOutlet UILabel *labRedName;
    @property (weak, nonatomic) IBOutlet UILabel *labRedInfo;
    @property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
    @property (weak, nonatomic) IBOutlet UITableView *tabRedPacketList;
    
@end

@implementation RedpecketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender {
}
    
@end
