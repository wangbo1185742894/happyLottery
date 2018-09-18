//
//  MyPostSchemeViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RedPacketHisViewController.h"
#import "RedPacketViewCell.h"
#define KRedPacketViewCell @"RedPacketViewCell"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface RedPacketHisViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
{
    NSInteger page;
    __weak IBOutlet NSLayoutConstraint *viewDisTop;
    NSMutableArray  *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tabSchemeListView;
@property (weak, nonatomic) IBOutlet UIButton *btnRecive;
@property (weak, nonatomic) IBOutlet UIButton *btnSendRed;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disImgLeft;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;
@property (strong, nonatomic) NSIndexPath* selectIndexPath; //当前要删除的cell

@end

@implementation RedPacketHisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包历史";
    self.viewControllerNo = @"A424";
    if (!self.isFaDan) {
        [self actionGenDan:self.btnRecive];
        self.viewControllerNo = @"A422";
    }
    dataArray = [NSMutableArray arrayWithCapacity:0];
    if ([self isIphoneX]) {
        viewDisTop.constant = 88;
    }else{
        viewDisTop.constant = 64;
    }
    [self setTableView];
    [self setTableViewLoadRefresh];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.tabSchemeListView.delegate = self;
    self.tabSchemeListView.dataSource = self;
    self.tabSchemeListView.rowHeight = 73;

    [self.tabSchemeListView registerNib:[UINib nibWithNibName:KRedPacketViewCell bundle:nil] forCellReuseIdentifier:KRedPacketViewCell];
    self.lotteryMan.delegate =self;
}

-(void)setTableViewLoadRefresh{
    
    [UITableView refreshHelperWithScrollView:self.tabSchemeListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        RedPacketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRedPacketViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadData:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        return cell;
}

-(void)loadNewData{
    page = 1;
    NSString *apiUrl;
    if (_btnRecive.selected == YES) {
        apiUrl = APIgainRedPacket;
    }else{
        apiUrl = APIsendOutRedPacket;
    }
    [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)} andUrl:apiUrl];
}

-(void)loadMoreData{
    page++;
    NSString *apiUrl;
    if (_btnRecive.selected == YES) {
        apiUrl = APIgainRedPacket;
    }else{
        apiUrl = APIsendOutRedPacket;
    }
    [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)} andUrl:apiUrl];
}

-(void)gotRedPacketHis:(NSArray *)redList errorInfo:(NSString *)errMsg{
    if (redList == nil) {
        [self showPromptText:errMsg hideAfterDelay:1.7];
        [dataArray removeAllObjects];
        [self.tabSchemeListView reloadData];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (IBAction)actionGenDan:(UIButton*)sender {
    
    self.btnSendRed.selected = NO;
    self.btnRecive.selected = NO;
     self.disImgLeft.constant = sender.mj_x + 10;
    [UIView animateWithDuration:0.5 animations:^{
        [self.imgBottom.superview layoutIfNeeded];
    }];
    
    sender.selected = YES;
    [self loadNewData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
@end
