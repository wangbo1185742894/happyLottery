//
//  GroupApplyInfoViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupApplyInfoViewController.h"
#import "ApplayInventCell.h"
#import "ApplyInputCell.h"
#import "AdvantageCell.h"
#import "PingtaiYouCell.h"
#import "GAStatusViewController.h"

#define KApplayInventCell @"ApplayInventCell"
#define KApplyInputCell  @"ApplyInputCell"
#define KAdvantageCell   @"AdvantageCell"
#define KPingtaiYouCell  @"PingtaiYouCell"


@interface GroupApplyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ApplyInputCellDelegate,AgentManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GroupApplyInfoViewController{
    NSArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    if (self.agentMan == nil) {
        self.agentMan = [[AgentManager alloc]init];
    }
    self.agentMan.delegate = self;
    self.title = @"申请圈主";
    array = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"AgentApplayConfig" ofType: @"plist"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:KApplayInventCell bundle:nil] forCellReuseIdentifier:KApplayInventCell];
     [self.tableView registerNib:[UINib nibWithNibName:KApplyInputCell bundle:nil] forCellReuseIdentifier:KApplyInputCell];
     [self.tableView registerNib:[UINib nibWithNibName:KAdvantageCell bundle:nil] forCellReuseIdentifier:KAdvantageCell];
     [self.tableView registerNib:[UINib nibWithNibName:KPingtaiYouCell bundle:nil] forCellReuseIdentifier:KPingtaiYouCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 283;
    }
    if (indexPath.row == 1) {
        return 195;
    }
    if (indexPath.row == 2) {
        return 44;
    }
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ApplayInventCell *cell = [tableView dequeueReusableCellWithIdentifier:KApplayInventCell];
        return cell;
    }
    if (indexPath.row == 1) {
        ApplyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:KApplyInputCell];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 2) {
        PingtaiYouCell *cell = [tableView dequeueReusableCellWithIdentifier:KPingtaiYouCell];
        return cell;
    }
    AdvantageCell *cell = [tableView dequeueReusableCellWithIdentifier:KAdvantageCell];
    NSDictionary *dic = [array objectAtIndex:indexPath.row-3];
    [cell reloadDate:dic];
    return cell;
}

//{"cardCode":"卡号","realName":"真实姓名","mobile":"手机号","qq":"qq号"}
- (void)applayAgent:(NSString *)realName telephone:(NSString *)telephone{
    NSDictionary *dicInfo = @{@"cardCode":self.curUser.cardCode,@"realName":realName,@"mobile":telephone,@"qq":@""};
    [self.agentMan agentApply:dicInfo];
}


-(void )agentApplydelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (param == nil) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    GAStatusViewController *statusVC = [[GAStatusViewController alloc]init];
//    statusVC.agentStatus = agentStatus;
    statusVC.agentStatus = @"AGENT_APPLYING";
    [self.navigationController pushViewController:statusVC animated:YES];
    
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
