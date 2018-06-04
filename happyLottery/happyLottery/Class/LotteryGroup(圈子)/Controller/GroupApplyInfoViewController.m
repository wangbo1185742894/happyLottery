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
#import "AdvantageLeftCell.h"
#import "PingtaiYouCell.h"
#import "PromptCell.h"
#import "GAStatusViewController.h"
#import "WebViewController.h"

#define KApplayInventCell @"ApplayInventCell"
#define KApplyInputCell  @"ApplyInputCell"
#define KAdvantageCell   @"AdvantageCell"
#define KPingtaiYouCell  @"PingtaiYouCell"
#define KAdvantageLeftCell  @"AdvantageLeftCell"
#define KPromptCell  @"PromptCell"



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
    [self.tableView registerNib:[UINib nibWithNibName:KAdvantageLeftCell bundle:nil] forCellReuseIdentifier:KAdvantageLeftCell];
    [self.tableView registerNib:[UINib nibWithNibName:KPromptCell bundle:nil] forCellReuseIdentifier:KPromptCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark  ======== tableViewDelegate==========

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 283;
    }
    if (indexPath.row == 1) {
        return 195;
    }
    if (indexPath.row == 2||indexPath.row == 6) {
        return 44;
    }
    
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ApplayInventCell *cell = [tableView dequeueReusableCellWithIdentifier:KApplayInventCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        ApplyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:KApplyInputCell];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2) {
        PingtaiYouCell *cell = [tableView dequeueReusableCellWithIdentifier:KPingtaiYouCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 4) {
        AdvantageLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:KAdvantageLeftCell];
        NSDictionary *dic = [array objectAtIndex:indexPath.row-3];
        [cell reloadDate:dic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 6) {
        PromptCell *cell = [tableView dequeueReusableCellWithIdentifier:KPromptCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    AdvantageCell *cell = [tableView dequeueReusableCellWithIdentifier:KAdvantageCell];
    NSDictionary *dic = [array objectAtIndex:indexPath.row-3];
    [cell reloadDate:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void )agentApplydelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (!success) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    GAStatusViewController *statusVC = [[GAStatusViewController alloc]init];
    statusVC.agentStatus = @"AGENT_APPLYING";
    [self.navigationController pushViewController:statusVC animated:YES];
}

#define mark ======= cellDelegate=========

- (void)goToGroupInform{
    WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.type = @"html";
    webVC.title = @"圈主须知";
    webVC.htmlName = @"quanzhuxuzhi";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)applayAgent:(NSString *)realName telephone:(NSString *)telephone agree:(BOOL)agree{
    //判断输入
    NSString *alertString;
    if ([realName isEqualToString:@""]) {
        alertString = @"请输入您的姓名";
    }else if ([telephone isEqualToString:@""]){
        alertString = @"请输入您的手机号/微信/qq";
    }else if (!agree){
        alertString = @"请点击同意本协议";
    }
    if (alertString == nil) {
        NSDictionary *dicInfo = @{@"cardCode":self.curUser.cardCode,@"realName":realName,@"mobile":telephone};
        [self.agentMan agentApply:dicInfo];
    } else {
        [self showPromptText:alertString hideAfterDelay:1.0];
    }
}


@end
