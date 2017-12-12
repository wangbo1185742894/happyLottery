//
//  JCZQPlayViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/11.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQPlayViewController.h"

@interface JCZQPlayViewController ()

@end

@implementation JCZQPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 88, KscreenWidth, KscreenHeight - 88 - 34);
    [self setValue:@(frame) forKeyPath:@"view.frame"];
    self.view.backgroundColor = [UIColor blueColor];
    
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
