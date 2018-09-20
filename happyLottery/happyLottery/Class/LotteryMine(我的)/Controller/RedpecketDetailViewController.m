//
//  RedpecketDetailViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RedpecketDetailViewController.h"
#import "AtttendPersonViewCell.h"
#define KAtttendPersonViewCell @"AtttendPersonViewCell"

@interface RedpecketDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property(nonatomic,strong)NSMutableArray <FollowRedPacketModel *> * followRedList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthNavHeight;
@property(nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UILabel *labRedCost;
    @property (weak, nonatomic) IBOutlet UILabel *labRedName;
    @property (weak, nonatomic) IBOutlet UILabel *labRedInfo;
    @property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labRedDetailInfo;
@property (weak, nonatomic) IBOutlet UITableView *tabRedPacketList;
    
@end

@implementation RedpecketDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.imgIcon.layer.cornerRadius = self.imgIcon.mj_h / 2;
    self.imgIcon.layer.masksToBounds = YES;
    if ( self.curUser.headUrl == nil ) {
            [self.imgIcon setImage:[UIImage imageNamed:@"user_mine"]];
    }else{
            [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];
    }

    self.labRedName.text = self.redPacket.trPacketChannel;
    self.labRedDetailInfo.text = [NSString stringWithFormat:@"   已领取%@/%@个，共%.2f/%.2f元",_redPacket.openSize,_redPacket.totalCount,[_redPacket.openSize integerValue] * [_redPacket.univalent doubleValue],[_redPacket.totalCount integerValue] * [_redPacket.univalent doubleValue]];
    self.followRedList = [NSMutableArray arrayWithCapacity:0];
    self.heigthNavHeight.constant = NaviHeight;
    self.lotteryMan.delegate = self;
    [self setTableView];
    [UITableView refreshHelperWithScrollView:self.tabRedPacketList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
    [self loadNewData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)loadNewData{
    _page = 1;
    [self loadData];
}

-(void)loadMoreData{
    _page ++;
    [self loadData];
}

-(void)loadData{
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan  sendOutRedPacketDetail:@{@"id":self.redPacket._id,@"page":@(_page),@"pageSize":@(KpageSize)}];
}

-(void)sendedOutRedPacketDetail:(BOOL)success followList:(NSArray *)redList errorInfo:(NSString *)errMsg{
    [self.tabRedPacketList tableViewEndRefreshCurPageCount:redList.count];
    [self hidePromptText];
    if (success) {
        if (_page == 1) {
            [self.followRedList removeAllObjects];
        }
        for (NSDictionary *item in redList) {
            FollowRedPacketModel *model = [[FollowRedPacketModel alloc]initWith:item];
            [self.followRedList addObject:model];
        }
        [self.tabRedPacketList reloadData];
    }else{
        [self.tabRedPacketList reloadData];
        [self showPromptText:errMsg hideAfterDelay:YES];
    }
}

-(void)setTableView{
    self.tabRedPacketList.delegate  =self;
    self.tabRedPacketList.rowHeight = 80;
    self.tabRedPacketList.dataSource = self;
    [self.tabRedPacketList registerNib:[UINib nibWithNibName:KAtttendPersonViewCell bundle:nil] forCellReuseIdentifier:KAtttendPersonViewCell];
    [self .tabRedPacketList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.followRedList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AtttendPersonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAtttendPersonViewCell];
    [cell loadDataRedCell:self .followRedList[indexPath.row]];
    cell.selectionStyle  =0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UILabel *footer =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 60)];
    footer.backgroundColor = [UIColor whiteColor];
    footer.font = [UIFont systemFontOfSize:13];
    footer.textAlignment = NSTextAlignmentCenter;
     footer.text = @"未领取的红包，将于24小时后返还";
    footer.textColor = SystemGreen;
    return footer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
    
@end
