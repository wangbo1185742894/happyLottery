//
//  FollowListViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowListViewController.h"
#import "FollowListTableViewCell.h"
#define  KFollowListTableViewCell  @"FollowListTableViewCell"
@interface FollowListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labPersonInfo;
@property (weak, nonatomic) IBOutlet UITableView *tabFollowListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@end

@implementation FollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    if ([self isIphoneX]) {
        self.topDis.constant = 88;
    }else{
        self.topDis.constant = 64 ;
    }
    self.labPersonInfo.text = [NSString stringWithFormat:@"当前用户跟单%ld人次",self.followListDtos.count];
}

-(void)setTableView{
    self.tabFollowListView.delegate = self;
    self.tabFollowListView.dataSource  = self;
    [self.tabFollowListView registerNib:[UINib nibWithNibName:KFollowListTableViewCell bundle:nil] forCellReuseIdentifier:KFollowListTableViewCell];
    [self.tabFollowListView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followListDtos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KFollowListTableViewCell];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    [cell loadData:self.followListDtos[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
