//
//  FASSchemeDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FASSchemeDetailViewController.h"

@interface FASSchemeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

@implementation FASSchemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"方案详情";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
//    [self.detailTableView registerClass:[SchemeDetailMatchViewCell class] forCellReuseIdentifier: KSchemeDetailMatchViewCell];
//    [self.detailTableView registerClass:[SchemeDetailViewCell class] forCellReuseIdentifier:KSchemeDetailViewCell];
//    [self.detailTableView registerClass:[SchemeInfoViewCell class] forCellReuseIdentifier:KSchemeInfoViewCell];
//    [self.detailTableView registerNib:[UINib nibWithNibName:KCTZQWinResultCell bundle:nil] forCellReuseIdentifier:KCTZQWinResultCell];
//    [detailTableView registerClass:[GYJSchemeViewCell class] forCellReuseIdentifier:KGYJSchemeViewCell];
    
}
#pragma mark  tableView
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
