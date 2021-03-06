//
//  PersonCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "HotFollowSchemeViewCell.h"
#import "PersonCenterModel.h"
#import "FollowDetailViewController.h"
#import "FASSchemeDetailViewController.h"
#import "MGLabel.h"
#define KHotFollowSchemeViewCell  @"HotFollowSchemeViewCell"

@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTabelView;
@property (nonatomic,strong) NSMutableArray <HotSchemeModel *> * personArray;
@property(assign,nonatomic)NSInteger page;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet MGLabel *fenshiNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusFirst;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusTwo;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusThird;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusForth;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusFifth;
@property (weak, nonatomic) IBOutlet UILabel *initiateStatusSum;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picLianjie;
@property (weak, nonatomic) IBOutlet UIImageView *picLian;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor2;

@end

@implementation PersonCenterViewController{
    PersonCenterModel *model;
    BOOL isAttend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    if ([self isIphoneX]) {
        _topDis .constant = 88;
    }else{
        _topDis.constant = 64;
    }
    [UITableView refreshHelperWithScrollView:self.personTabelView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self initTabelView];
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    [self showLoadingViewWithText:@"正在加载"];

    

    self.personTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.cardCode != nil) {
        NSDictionary *dic = @{@"cardCode":self.cardCode};
        [self.lotteryMan getInitiateInfo:dic];
    }

    [self reloadView];

    // Do any additional setup after loading the view from its nib.
}

- (void)reloadView {
    self.userImage.clipsToBounds = NO;
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
    self.initiateStatusFirst.layer.cornerRadius = self.initiateStatusFirst.mj_h / 2;
    self.initiateStatusFirst.layer.masksToBounds = YES;
    self.initiateStatusTwo.layer.cornerRadius = self.initiateStatusTwo.mj_h / 2;
    self.initiateStatusTwo.layer.masksToBounds = YES;
    self.initiateStatusThird.layer.cornerRadius = self.initiateStatusThird.mj_h / 2;
    self.initiateStatusThird.layer.masksToBounds = YES;
    self.initiateStatusForth.layer.cornerRadius = self.initiateStatusForth.mj_h / 2;
    self.initiateStatusForth.layer.masksToBounds = YES;
    self.initiateStatusFifth.layer.cornerRadius = self.initiateStatusFifth.mj_h / 2;
    self.initiateStatusFifth.layer.masksToBounds = YES;
    self.noticeBtn.layer.masksToBounds = YES;
    self.noticeBtn.layer.borderWidth = 1;
    self.noticeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.noticeBtn.layer.cornerRadius = 3;
    self.fenshiNum.text = [NSString stringWithFormat:@"粉丝 %d人",[model.attentCount intValue]];
    self.fenshiNum.keyWord = [NSString stringWithFormat:@"%d",[model.attentCount intValue]];
    self.fenshiNum.keyWordFont = [UIFont systemFontOfSize:17];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.   
}

- (void)initTabelView {
    self.personTabelView.delegate = self;
    self.personTabelView.dataSource = self;
    [self.personTabelView registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 202;
}


- (void) gotisAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    isAttend = [diction boolValue];
    [self loadNewData];
}

- (void) gotInitiateInfo:(NSDictionary *)diction  errorMsg:(NSString *)msg
{
    if (diction == nil) {
        [self showPromptViewWithText:msg hideAfter:1];
        return;
    }
    model = [[PersonCenterModel alloc]initWith:diction];
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self gotisAttent:@"false" errorMsg:nil];
        return;
    }
    NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
    [self.lotteryMan isAttent:dic];
    
}

-(void)loadNewData{
    if (model != nil) {
        _page = 1;
        NSDictionary *parc;
        if (self.curUser == nil || self.curUser.isLogin==NO) {
         parc = @{@"nickName":model.cardCode,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
        }else {
         parc = @{@"nickName":model.cardCode,@"selfCardCode":self.curUser.cardCode,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
        }
        
        [self.lotteryMan getFollowSchemeByNickName:parc];
    }
    [self.personTabelView tableViewEndRefreshCurPageCount:0];
}

-(void)loadMoreData{
    if (model != nil) {
        _page ++;
        NSDictionary *parc;
        if (self.curUser == nil || self.curUser.isLogin==NO) {
            parc = @{@"nickName":model.cardCode,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
        }else {
            parc = @{@"nickName":model.cardCode,@"selfCardCode":self.curUser.cardCode,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@YES};
        }
        [self.lotteryMan getFollowSchemeByNickName:parc];
    }
}

-(void)getHotFollowScheme:(NSArray *)personList errorMsg:(NSString *)msg{
    [self.personTabelView tableViewEndRefreshCurPageCount:personList.count];
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    if (_page == 1) {
        [self.personArray removeAllObjects];
    }
    for (NSDictionary *dic in personList) {
        [self.personArray addObject:[[HotSchemeModel alloc]initWith:dic]];
    }
    [self reload:model isAttend:isAttend];
    [self.personTabelView  reloadData];
    [self hideLoadingView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
    if (self.personArray .count >0) {
        HotSchemeModel *model = [self.personArray objectAtIndex:indexPath.row];
        [cell loadDataWithModelInPC:model];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotSchemeModel *model = [_personArray objectAtIndex:indexPath.row];
    NSDate * dateServer = [Utility dateFromDateStr:model.serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateCur = [Utility dateFromDateStr:model.deadLine withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([dateServer compare:dateCur] ==kCFCompareLessThan ) { //没过期 可以买
        FollowDetailViewController *followVC = [[FollowDetailViewController alloc]init];
        followVC.model = model;
        followVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:followVC animated:YES];
    }else{
        if (model.won == nil) {
            return;
        }else{
            FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
            detailCV.schemeNo = model.schemeNo;
            detailCV.schemeType = KBUY_INITIATE;
            detailCV.schemeFromView = @"personCen";
            [self.navigationController pushViewController:detailCV animated:YES];
        }
    }
}
- (void)addOrReliefAttend {
    if (isAttend) {
        //取消关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan reliefAttent:dic];
    }
    else {
        //添加关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":self.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan attentMember:dic];
    }
}

- (void) gotAttentMember:(NSString *)diction  errorMsg:(NSString *)msg{
    if (diction) {
        isAttend = YES;
        [self reload:model isAttend:isAttend];
        [self showPromptText:@"添加关注成功" hideAfterDelay:1.0];
    }
}

- (void) gotReliefAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    if (diction) {
        isAttend = NO;
        [self reload:model isAttend:isAttend];
        [self showPromptText:@"取消关注成功" hideAfterDelay:1.0];
    }
}

- (UILabel *)initiateStatus:(UILabel *)label text:(NSString *)string{
    
    if ([string isEqualToString:@"1"]) {
        label.text = @"中";
        label.backgroundColor = RGBCOLOR(254, 165, 19);
        return label;
    }
    label.text = @"未";
    label.backgroundColor = RGBCOLOR(180, 177, 177);
    return label;
}

- (void)reload:(PersonCenterModel *)model  isAttend:(BOOL)isAttend{
    self.imgPersonHonor.hidden = NO;
    self.imgPersonHonor1.hidden = NO;
    self.imgPersonHonor2.hidden = NO;
    NSString *str = isAttend?@"已关注":@"+ 关注";
    self.noticeBtn.userInteractionEnabled = YES;
    [self.noticeBtn setTitle:str forState:UIControlStateNormal];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"]];
    self.userName.text = model.nickName==nil?[model.mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"]:model.nickName;
    
    self.fenshiNum.text = [NSString stringWithFormat:@"粉丝 %d人",[model.attentCount intValue]];
    self.fenshiNum.keyWord = [NSString stringWithFormat:@"%d",[model.attentCount intValue]];
    self.fenshiNum.keyWordFont = [UIFont systemFontOfSize:17];
    
    self.initiateStatusSum.text = [NSString stringWithFormat:@"%.2f",[model.totalInitiateBonus  doubleValue]];
    NSArray *array = [model.initiateStatus componentsSeparatedByString:@","];
    switch (array.count) {
        case 0:
            self.initiateStatusFirst.hidden = YES;
            self.initiateStatusTwo.hidden = YES;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = 0;
            self.picLian.hidden = YES;
            break;
        case 1:
            self.initiateStatusFirst = [self initiateStatus:self.initiateStatusFirst text:array[0]];
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.hidden = YES;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = self.initiateStatusFirst.mj_x+self.initiateStatusFirst.mj_w+12;
            self.picLian.hidden = NO;
            break;
        case 2:
            self.initiateStatusFirst = [self initiateStatus:self.initiateStatusFirst text:array[1]];
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo = [self initiateStatus:self.initiateStatusTwo text:array[0]];
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = self.initiateStatusTwo.mj_x+self.initiateStatusTwo.mj_w +12;
            self.picLian.hidden = NO;
            break;
        case 3:
            self.initiateStatusFirst = [self initiateStatus:self.initiateStatusFirst text:array[2]];
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo = [self initiateStatus:self.initiateStatusTwo text:array[1]];
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird = [self initiateStatus:self.initiateStatusThird text:array[0]];
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLian.hidden = NO;
            self.picLianjie.constant = self.initiateStatusThird.mj_x+ self.initiateStatusThird.mj_w+12;
            break;
        case 4:
            self.initiateStatusFirst = [self initiateStatus:self.initiateStatusFirst text:array[3]];
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo = [self initiateStatus:self.initiateStatusTwo text:array[2]];
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird = [self initiateStatus:self.initiateStatusThird text:array[1]];
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth = [self initiateStatus:self.initiateStatusForth text:array[0]];
            self.initiateStatusForth.hidden = NO;
            self.initiateStatusFifth.hidden = YES;
            self.picLian.hidden = NO;
            self.picLianjie.constant = self.initiateStatusForth.mj_x+self.initiateStatusForth.mj_w+12;
            break;
        case 5:
            self.initiateStatusFirst = [self initiateStatus:self.initiateStatusFirst text:array[4]];
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo = [self initiateStatus:self.initiateStatusTwo text:array[3]];
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird = [self initiateStatus:self.initiateStatusThird text:array[2]];
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth = [self initiateStatus:self.initiateStatusForth text:array[1]];
            self.initiateStatusForth.hidden = NO;
            self.initiateStatusFifth = [self initiateStatus:self.initiateStatusFifth text:array[0]];
            self.initiateStatusFifth.hidden = NO;
            self.picLian.hidden = NO;
            self.picLianjie.constant = 189;
            break;
        default:
            break;
    }
    if (model.labelMap != nil) {
        NSArray *laburls = [model.labelMap componentsSeparatedByString:@";"];
        for (int i = 0; i < laburls.count; i ++){
            NSString *url;
            if ([laburls[i] containsString:@"="]) {
                NSArray *lab = [laburls[i] componentsSeparatedByString:@"="];
                url = lab[1];
                url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            if (i == 0) {
                self.imgPersonHonor.hidden = NO;
                [self.imgPersonHonor sd_setImageWithURL:[NSURL URLWithString:url]];
            }else if(i == 1){
                [self.imgPersonHonor1 sd_setImageWithURL:[NSURL URLWithString:url]];
                self.imgPersonHonor1.hidden = NO;
                
            }else if (i == 2){
                [self.imgPersonHonor2 sd_setImageWithURL:[NSURL URLWithString:url]];
                self.imgPersonHonor2.hidden = NO;
            }
        }
    }
}

- (IBAction)attendAction:(id)sender{
    if (self.curUser == nil || self.curUser.isLogin==NO) {
        [self needLogin];
        return;
    }
    self.noticeBtn.userInteractionEnabled = NO;
    [self addOrReliefAttend];
}

@end
