//
//  FASSchemeDetailViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FASSchemeDetailViewController.h"
#import "SchemeInfoFollowCell.h"
#import "SchemePerFollowCell.h"
#import "SchemeContaintCell.h"
#import "SchemeBuyCell.h"
#import "SchemeOverCell.h"
#import "SchemeContainInfoCell.h"
#import "SchemeInfoBuyCell.h"
#import "JCZQSchemeModel.h"

#define KSchemeInfoFollowCell @"SchemeInfoFollowCell"
#define KSchemePerFollowCell  @"SchemePerFollowCell"
#define KSchemeContaintCell   @"SchemeContaintCell"
#define KSchemeBuyCell        @"SchemeBuyCell"
#define KSchemeOverCell       @"SchemeOverCell"
#define KSchemeContainInfoCell  @"SchemeContainInfoCell"
#define KSchemeInfoBuyCell   @"SchemeInfoBuyCell"


@interface FASSchemeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;



@end

@implementation FASSchemeDetailViewController{
    JCZQSchemeItem *schemeDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"方案详情";
    self.lotteryMan.delegate = self;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self setTableView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
//    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getSchemeRecordBySchemeNo:@{@"schemeNo":self.schemeNo}];
}

- (void) gotSchemeRecordBySchemeNo:(NSDictionary *)infoArray errorMsg:(NSString *)msg{
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    schemeDetail = [[JCZQSchemeItem alloc]initWith:infoArray];
    for (NSDictionary *matchDic in [Utility objFromJson:schemeDetail.betContent]) {
          NSArray *matchArray = [Utility objFromJson:matchDic[@"betMatches"]];
        for (int i  = 0; i < matchArray.count; i++) {
            JcBetContent *betContent = [[JcBetContent alloc]init];
            betContent.virtualSp = schemeDetail.virtualSp;
            betContent.matchInfo = matchArray[i];
            [self.dataArray addObject:betContent];
        }
    }
    [self.detailTableView reloadData];
}

-(void)setTableView{
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.allowsSelection = NO;
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeInfoFollowCell bundle:nil] forCellReuseIdentifier:KSchemeInfoFollowCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemePerFollowCell bundle:nil] forCellReuseIdentifier:KSchemePerFollowCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeContaintCell bundle:nil] forCellReuseIdentifier:KSchemeContaintCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeBuyCell bundle:nil] forCellReuseIdentifier:KSchemeBuyCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeOverCell bundle:nil] forCellReuseIdentifier:KSchemeOverCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeContainInfoCell bundle:nil] forCellReuseIdentifier:KSchemeContainInfoCell];
    [self.detailTableView registerNib:[UINib nibWithNibName:KSchemeInfoBuyCell bundle:nil] forCellReuseIdentifier:KSchemeInfoBuyCell];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark  tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 3+self.dataArray.count;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if([self.schemeType isEqualToString:@"BUY_INITIATE"]) return 205;
        return 169;
    } else if (indexPath.section == 1){
        return 38;
    } else if (indexPath.section == 2){
        if (indexPath.row == 0 || indexPath.row == 2+self.dataArray.count ||indexPath.row == 1) {
            return 38;
        }
        return 59;
    }
    return 138;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if([self.schemeType isEqualToString:@"BUY_FOLLOW"]){
            SchemeInfoFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoFollowCell];
            [cell reloadDate:schemeDetail];
            return cell;
        }
        SchemeInfoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeInfoBuyCell];
        [cell reloadDate:schemeDetail];
        return cell;
    }else if (indexPath.section == 1){
        SchemePerFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemePerFollowCell];
        [cell reloadDate:schemeDetail schemeType:self.schemeType];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            SchemeContaintCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContaintCell];
            return cell;
        }else if (indexPath.row == self.dataArray.count+2){
            SchemeOverCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeOverCell];
            NSString *pass = [schemeDetail.passType componentsJoinedByString:@","];
            pass = [pass stringByReplacingOccurrencesOfString:@"x" withString:@"串"];
            cell.passType.text = pass;
            cell.touzhuCount.text =[NSString stringWithFormat:@"%@倍%@注",schemeDetail.multiple,schemeDetail.units];
            return cell;
        }else{
            SchemeContainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeContainInfoCell];
            JcBetContent *bet;
            if(indexPath.row == 1){
                cell.orderNoLab.text = @"编号";
                cell.groupMatchLab.text = @"主队vs客队";
                cell.betContentLab.text = @"投注内容";
                cell.matchResultLab.text = @"赛果";
            }else{
                if(self.dataArray.count >0){
                    bet = self.dataArray[indexPath.row-2];
                    [cell refreshData:bet andResult:schemeDetail.trOpenResult];
                }
            }
            return cell;
        }
    }
    SchemeBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemeBuyCell];
    [cell loadData:schemeDetail];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

@end
