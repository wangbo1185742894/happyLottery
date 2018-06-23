//
//  NoticeCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/29.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NoticeCenterViewController.h"
#import "NoticeCenterTableViewCell.h"
#import "MyCircleViewController.h"
#import "RecommendPerViewController.h"
#import "MyPostSchemeViewController.h"
#import "MyAttendViewController.h"
#import "NoticeDetailViewController.h"
#import "MyNoticeViewController.h"
#import "Notice.h"
#import "FMDB.h"
#import "JumpWebViewController.h"
#import "DiscoverViewController.h"
#import "HomeJumpViewController.h"
#import "WebCTZQHisViewController.h"
#import "DLTPlayViewController.h"
#import "CTZQPlayViewController.h"
#import "JCZQPlayViewController.h"

@interface NoticeCenterViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray <Notice *>*listSystemNoticeArray;
    NSMutableArray <Notice *>*listPersonNoticeArray;
    BOOL isEnterPersonMessage;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *systemBtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UIImageView *enptyImage;
@property (weak, nonatomic) IBOutlet UILabel *emptyLab;

@property (nonatomic, strong) FMDatabaseQueue *queue;


@end

@implementation NoticeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEnterPersonMessage = NO;
    self.viewControllerNo  = @"A107";
    self.title = @"我的消息";
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    listSystemNoticeArray = [[NSMutableArray alloc]init];
    listPersonNoticeArray = [[NSMutableArray alloc]init];
 
     [self searchSystemDB];
   // [self getDB];
    [self searchPersonDB];
   
}

-(void)getDB{
    //    // 0.获得沙盒中的数据库文件名
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    NSError *error;
    
    NSBundle *bundle = [NSBundle mainBundle];
   // NSString *filenameAgo = [bundle pathForResource:@"userInfo" ofType:@"sqlite"];
   // NSLog(@"filenameAgo>>>>%@",filenameAgo);
    NSLog(@"filename%@",fileName);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager copyItemAtPath:filenameAgo toPath:fileName error:&error];
//
    // 1.创建数据库队列
    self.queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
//    // 2.创表
//    [self.queue inDatabase:^(FMDatabase *db) {
//        BOOL result = [db executeUpdate:@"create table if not exists vcUserPushMsg(id integer primary key autoincrement, title text,content text, msgTime text,t1 text);"];
//        if (result) {
//            NSLog(@"创表成功");
//        } else {
//            NSLog(@"创表失败");
//        }
//    }];
}

-(void)searchPersonDB{
    

//    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
//    self.fmdb =[FMDatabase databaseWithPath:fileName];
    
//    [self.queue inDatabase:^(FMDatabase *db) {
    [listPersonNoticeArray removeAllObjects];
        NSMutableArray *array = [NSMutableArray array];
        // 1.查询数据
            if ([self.fmdb open]) {
//        FMResultSet *rs = [db executeQuery:@"select * from vcUserPushMsg ;"];
       //    FMResultSet *rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg"];
        // 2.遍历结果集
           
                    FMResultSet*  rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg where cardcode=?",self.curUser.cardCode];
                
                        while (rs.next) {
                            Notice *notice =  [[Notice alloc] init];
                            notice.title = [rs stringForColumn:@"title"];
                            notice.content = [rs stringForColumn:@"content"];
                            notice.cardcode = [rs stringForColumn:@"cardcode"];
                            notice.releaseTime = [rs stringForColumn:@"msgTime"];
                            notice.isread = [rs stringForColumn:@"isread"];
                            notice.thumbnailCode = [rs stringForColumn:@"pagecode"];
                            notice.linkUrl = [rs stringForColumn:@"url"];
                            [array addObject: notice];
                        }

            listPersonNoticeArray = array;
                [self.tableView2 reloadData];
//    }];
             //   [self.fmdb close];
            }
    
}

-(void)searchSystemDB{
    
    

    [listSystemNoticeArray removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    // 1.查询数据
    if ([self.fmdb open]) {
        //        FMResultSet *rs = [db executeQuery:@"select * from vcUserPushMsg ;"];
        //    FMResultSet *rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg"];
        // 2.遍历结果集
        
        FMResultSet*  rs = [self.fmdb executeQuery:@"select * from SystemNotice where cardcode=?",self.curUser.cardCode];
     
        
        while (rs.next) {
            Notice *notice =  [[Notice alloc] init];
            notice.title = [rs stringForColumn:@"title"];
            notice.content = [rs stringForColumn:@"content"];
            notice.cardcode = [rs stringForColumn:@"cardcode"];
            notice.releaseTime = [rs stringForColumn:@"msgTime"];
            notice.isread = [rs stringForColumn:@"isread"];
            notice._id = [rs stringForColumn:@"noticeid"];
            notice.type = [rs stringForColumn:@"type"];
               notice.thumbnailCode = [rs stringForColumn:@"pagecode"];
               notice.linkUrl = [rs stringForColumn:@"url"];
            //            [self goImage:student.photo];
            [listSystemNoticeArray addObject: notice];
        }
        [listSystemNoticeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Notice *no1 = (Notice *)obj1;
            Notice *no2 = (Notice *)obj2;
            return  [no1.releaseTime compare:no2.releaseTime];
            
        }];
        [self.fmdb close];
        [self.tableView1 reloadData];
        //    }];
    }
}

-(BOOL)havData{
    if (self.personBtn.selected == YES) {
        if (listPersonNoticeArray.count == 0) {
            return NO;
        }else{
            return YES;
        }
    }else{
        if (listSystemNoticeArray.count == 0) {
            return NO;
        }else{
            return YES;
        }
    }
}


- (IBAction)systemBtnClick:(id)sender {
    self.systemBtn.selected = YES;
    self.personBtn.selected = NO;
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.tableView1.hidden=NO;
    self.tableView2.hidden = YES;
    [listPersonNoticeArray removeAllObjects];
    [listSystemNoticeArray removeAllObjects];
       [self searchSystemDB];
}

- (IBAction)personBtnClick:(id)sender {
    isEnterPersonMessage = YES;
    self.systemBtn.selected = NO;
    self.personBtn.selected = YES;
    self.line2.hidden = NO;
    self.line1.hidden = YES;
    self.tableView2.hidden=NO;
    self.tableView1.hidden = YES;
    [listPersonNoticeArray removeAllObjects];
    [listSystemNoticeArray removeAllObjects];
     [self searchPersonDB];
}



#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listSystemNoticeArray.count > 0) {
            return listSystemNoticeArray.count;
        }
    }else if (tableView ==self.tableView2){
        
        if (listPersonNoticeArray.count > 0) {
            return listPersonNoticeArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    NoticeCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
    }
    //    SCORE_CONVERT("积分兑换"),
    //    LUCKY_DRAW("抽奖"),
    //    SYSTEM("系统赠送"),
    //    ACTIVITY("活动");
 
    if (tableView ==self.tableView1) {
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listSystemNoticeArray.count > 0) {
               Notice *notice = [[Notice alloc]init];
            long i=listSystemNoticeArray.count-indexPath.row-1;
            notice = listSystemNoticeArray[i];
            //cell.endImage.hidden = YES;
            cell.nameLab.text = notice.title;
            cell.noticeLab.text =notice.content;
             NSString *date=[notice.releaseTime substringWithRange:NSMakeRange(0,10)];
            cell.dateLab.text =date;
            if ([notice.isread isEqualToString:@"0"]) {
                cell.redPoint.hidden=NO;
            } else if ([notice.isread isEqualToString:@"1"]){
                cell.redPoint.hidden=YES;
            }
        }
        
    }else if (tableView ==self.tableView2){
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listPersonNoticeArray.count > 0) {
               Notice *notice = [[Notice alloc]init];
             long j=listPersonNoticeArray.count-indexPath.row-1;
            notice = listPersonNoticeArray[j];
            //cell.endImage.hidden = YES;
            cell.nameLab.text = notice.title;
            cell.noticeLab.text =notice.content;
            NSString *date=[notice.releaseTime substringWithRange:NSMakeRange(0,10)];
            cell.dateLab.text =date;
            if ([notice.isread isEqualToString:@"0"]) {
                cell.redPoint.hidden=NO;
            } else if ([notice.isread isEqualToString:@"1"]){
                cell.redPoint.hidden=YES;
            }
        }
    }
    return cell;
}

#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    NoticeCenterTableViewCell  *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView ==self.tableView1) {
            long i=listSystemNoticeArray.count-indexPath.row-1;
        
         Notice *notice = listSystemNoticeArray[i];
        if ([self.fmdb open]) {
            NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
            if ([cardcode isEqualToString:@""]) {
                cardcode = @"cardcode";
            }
            NSString *isread = @"1";
            BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"update SystemNotice set isread = '%@' where noticeid = '%@';",isread,notice._id]];
            if (result) {
                [self.fmdb close];
            }
        }
        [self searchSystemDB];
    NSString *type = notice.type;
    if ([type isEqualToString:@"APP"]) {
          NSString *pageCode=notice.thumbnailCode;
        [self goToYunshiWithInfo:notice];
    }else if ([type isEqualToString:@"H5PAGE"]||[type isEqualToString:@"EDITOR"]) {
        JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
         jumpVC.title = notice.title;
        jumpVC.URL = notice.linkUrl;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }else if ([type isEqualToString:@"TEXT"]) {
        NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] init];
            vc.notice = notice;
       
        [self.navigationController pushViewController: vc animated: YES];
    }
        
    }else if (tableView ==self.tableView2){
        long j=listPersonNoticeArray.count-indexPath.row-1;
        
          Notice *notice  = listPersonNoticeArray[j];
        if ([self.fmdb open]) {
            NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
            if ([cardcode isEqualToString:@""]) {
                cardcode = @"cardcode";
            }
            NSString *isread = @"1";
            BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"update vcUserPushMsg set isread = '%@' where msgTime = '%@';",isread,notice.releaseTime]];
            if (result) {
                [self.fmdb close];
            }
        }
        [self searchPersonDB];
           NSString *linkUrl=notice.linkUrl;
        if (![notice.thumbnailCode isEqualToString:@"(null)"]) {
            NSString *pageCode=notice.thumbnailCode;
            [self goToYunshiWithInfo:notice];
        }
        if (![linkUrl isEqualToString:@"(null)"]) {
            JumpWebViewController *jumpVC = [[JumpWebViewController alloc] initWithNibName:@"JumpWebViewController" bundle:nil];
            
            jumpVC.URL = linkUrl;
             jumpVC.title = notice.title;
            [self.navigationController pushViewController:jumpVC animated:YES];
       
        }
        if ([notice.thumbnailCode isEqualToString:@"(null)"]&&[linkUrl isEqualToString:@"(null)"]){
            NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] init];
            vc.notice = notice;
            [self.navigationController pushViewController: vc animated: YES];
        }
    }
   
}


-(void)goToYunshiWithInfo:(Notice *)itemIndex{
    NSString *keyStr = itemIndex.thumbnailCode;
    
    if (keyStr == nil) {
        return;
    }
    
    if (itemIndex.status!= nil) {
        if ([itemIndex.status isEqualToString:@"ENABLE"] && self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
    }
    BaseViewController *baseVC;
   
    NSDictionary * vcDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pageCodeConfig" ofType:@"plist"]];
    if (keyStr == nil || [keyStr isEqualToString:@""]) {
        return;
    }
    NSString *vcName = vcDic[keyStr];
    if (vcName==nil) {
        return;
    }
    Class class = NSClassFromString(vcName);
    
    baseVC =[[class alloc] init];
    if([keyStr isEqualToString:@"A401"]){

        self.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }else if([keyStr isEqualToString:@"A402"]){
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app setGroupView];
               [self.navigationController popToRootViewControllerAnimated:YES];
//        self.tabBarController.selectedIndex = 2;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A201"]){

             self.tabBarController.selectedIndex = 4;
        [self.navigationController popToRootViewControllerAnimated:YES];
         return;
    }else if([keyStr isEqualToString:@"A000"]){

        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else  if ([keyStr isEqualToString:@"A403"]){
        
        if (self.curUser.isLogin == YES && self.curUser.cardCode != nil) {
            HomeJumpViewController *disVC = [[HomeJumpViewController alloc]init];
            disVC.navigationController.navigationBar.hidden = YES;
            ADSModel *model = [[ADSModel alloc]init];
            model.linkUrl = [NSString stringWithFormat:@"%@/app/find/turntable?activityId=5&cardCode=%@",H5BaseAddress,self.curUser.cardCode];
            disVC.infoModel = model;
            disVC.isNeedBack = YES;
            [self.navigationController pushViewController:disVC animated:disVC];
        }else{
            [self needLogin];
        }
        return;
    }else if ([keyStr isEqualToString:@"A414"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/dltOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A415"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/sfcOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
        return;
    }else if([keyStr isEqualToString:@"A416"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        self.tabBarController.selectedIndex = 1;
        return;
    }else if ([keyStr isEqualToString:@"A417"]){
        [self jumpGenTouPage:0];
        
        return;
    }else if ([keyStr isEqualToString:@"A418"]){
        [self jumpGenTouPage:1];
        
        return;
    }else if ([keyStr isEqualToString:@"A419"]){
        [self jumpGenTouPage:2];
        
        return;
    }else if ([keyStr isEqualToString:@"A420"]){
        [self jumpGenTouPage:3];
        
        return;
    }else if ([keyStr isEqualToString:@"A422"]){
        
        if (self.curUser .isLogin == NO) {
            [self needLogin];
            return;
        }
        MyPostSchemeViewController *revise = [[MyPostSchemeViewController alloc]init];
        revise.isFaDan = NO;
        [self.navigationController pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A424"]){
        
        if (self.curUser .isLogin == NO) {
            [self needLogin];
            return;
        }
        MyPostSchemeViewController *revise = [[MyPostSchemeViewController alloc]init];
        revise.isFaDan = YES;
        [self.navigationController pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A423"]){
        
        if (self.curUser .isLogin == NO) {
            [self needLogin];
            return;
        }
        MyAttendViewController *revise = [[MyAttendViewController alloc]init];
        [self.navigationController pushViewController:revise animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A412"]){
        WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/jzOpenAward",H5BaseAddress];
        playViewVC.pageUrl = [NSURL URLWithString:strUrl];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
        return;
    }else if ([keyStr isEqualToString:@"A009"]){
        [self .navigationController popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"GYJ"];
        return;
    }else if ([keyStr isEqualToString:@"A006"]){
        [self .navigationController popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"SFC"];
        return;
    }else if ([keyStr isEqualToString:@"A005"]){
        [self .navigationController popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"RJC"];
        
        return;
    }else if ([keyStr isEqualToString:@"A004"]){
        [self .navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"DLT"];
        
        return;
    }
    else if ([keyStr isEqualToString:@"A007"]){
        [self .navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"SSQ"];
        return;
    }else if([keyStr isEqualToString:@"A425"]){
        MyCircleViewController * myCircleVC = [[MyCircleViewController alloc]init];
        myCircleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCircleVC animated:YES];

    } else{
         baseVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:baseVC animated:YES];
    }
}

- (void)actionToRecommed:(NSString *)categoryCode {
    RecommendPerViewController *perVC = [[RecommendPerViewController alloc]init];
    perVC.hidesBottomBarWhenPushed = YES;
    perVC.navigationController.navigationBar.hidden = YES;
    perVC.categoryCode = categoryCode;
    [self.navigationController pushViewController:perVC animated:YES];
}


-(void)jumpGenTouPage:(NSInteger)index{
    if (index == 0) {  // 牛人
        [self actionToRecommed:@"Cowman"];
    }else if (index == 1){  // 红人
        [self actionToRecommed:@"Redman"];
    }else if (index == 2){ // 红单
        [self actionToRecommed:@"RedScheme"];
    }else if (index == 3){  // 我的关注
        if (self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
        MyNoticeViewController *noticeVc = [[MyNoticeViewController alloc]init];
        noticeVc.hidesBottomBarWhenPushed = YES;
        noticeVc.curUser = self.curUser;
        [self.navigationController pushViewController:noticeVc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationBackToLastPage{
    if ([self.fmdb open]) {
        NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
        if ([cardcode isEqualToString:@""]) {
            cardcode = @"cardcode";
        }
        NSString *isread = @"1";
        BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"update SystemNotice set isread = '%@';",isread]];
        if (result) {
            [self.fmdb close];
        }
    }
    [self searchSystemDB];
    if (isEnterPersonMessage == YES) {
        if ([self.fmdb open]) {
            NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
            if ([cardcode isEqualToString:@""]) {
                cardcode = @"cardcode";
            }
            NSString *isread = @"1";
            BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"update vcUserPushMsg set isread = '%@';",isread]];
            if (result) {
                [self.fmdb close];
            }
        }
        [self searchPersonDB];
    }
   
    [super navigationBackToLastPage];
}

@end
