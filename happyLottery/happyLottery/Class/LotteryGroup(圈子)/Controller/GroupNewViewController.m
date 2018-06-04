//
//  GroupNewViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupNewViewController.h"

@interface GroupNewViewController ()

@property (weak, nonatomic) IBOutlet UITableView *groupTableView;

@end

@implementation GroupNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark =====UITableView=========
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return 3;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 2;
//}
//
//// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
//// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell;
//    return cell;
//}


@end
