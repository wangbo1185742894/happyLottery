//
//  MyCricleFriendVC.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyCricleYongJinVC.h"
#import "MyCircleFirendCell.h"
#import "AgentMemberModel.h"

#define KMyCircleFirendCell @"MyCircleFirendCell"
@interface MyCricleYongJinVC ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>

@property(nonatomic,strong)NSMutableArray <NSMutableArray *> *personArray;
@property(strong,nonatomic)NSMutableArray *openRow;
@property(assign,nonatomic)NSInteger page;
@end

@implementation MyCricleYongJinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金比例";
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self getDataArray];

    [self setTableView];
    self.agentMan.delegate = self;
    [self.tabFirendList reloadData];
}

-(void)getDataArray{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"LotteryArea" ofType:@"plist"];
    NSArray *itemArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *shuziArray = [NSMutableArray array];
    NSMutableArray *jingjiArray = [NSMutableArray array];
    for (NSDictionary *itemDic in itemArray) {
        NSString *lottery =itemDic[@"lottery"];
        if ([lottery isEqualToString:@"JCZQ"]) {
            [jingjiArray addObject:itemDic];
        }
        if ([lottery isEqualToString:@"JCLQ"]) {
            [jingjiArray addObject:itemDic];
        }
        if ([lottery isEqualToString:@"GYJ"]) {
            [jingjiArray addObject:itemDic];
        }
        if ([lottery isEqualToString:@"SFC"]) {
            [jingjiArray addObject:itemDic];
        }
        if ([lottery isEqualToString:@"SSQ"]) {
            [shuziArray addObject:itemDic];
        }
        if ([lottery isEqualToString:@"DLT"]) {
            [shuziArray addObject:itemDic];
        }
    }
    [self.personArray addObject:jingjiArray];
    [self.personArray addObject:shuziArray];
}

-(void)setTableView{
    self.tabFirendList .delegate = self;
    self.tabFirendList.dataSource = self;
    [self.tabFirendList registerNib:[UINib nibWithNibName:KMyCircleFirendCell bundle:nil] forCellReuseIdentifier:KMyCircleFirendCell];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.personArray[section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCircleFirendCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyCircleFirendCell];
    if (indexPath.section == 0) {
        
        [cell loadDataLottery:self.personArray[indexPath.section][indexPath.row] andRate:self.agentModel.sportsCommission];
    }else{
        [cell loadDataLottery:self.personArray[indexPath.section][indexPath.row] andRate:self.agentModel.numberCommission];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    

    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 35)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 15)];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = SystemGreen;
    if (section == 0) {
        titleLab.text = @"竞技彩";
    }else{
        titleLab.text = @"数字彩";
    }
    [header addSubview:titleLab];
    return header;
}

@end
