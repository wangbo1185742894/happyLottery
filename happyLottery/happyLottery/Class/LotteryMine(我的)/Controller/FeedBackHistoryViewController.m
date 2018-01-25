//
//  FeedBackHistoryViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedBackHistoryViewController.h"
#import "FeedBackHistoryTableViewCell.h"
#import "FeedBackHistory.h"

static NSString * const ReuseIdentifier = @"cell";
@interface FeedBackHistoryViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@end

@implementation FeedBackHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"历史反馈";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
      self.memberMan.delegate = self;
      self.tableview.delegate=self;
      self.tableview.dataSource=self;
      self.tableview.estimatedRowHeight = 120;//很重要保障滑动流畅性
      self.tableview.rowHeight = UITableViewAutomaticDimension;
      [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FeedBackHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
      page=1;
      self.dataArray = [[NSMutableArray alloc]init];
      [self initRefresh];
    
    
}

-(void)initRefresh{
    [UITableView refreshHelperWithScrollView:self.tableview target:self loadNewData:@selector(FeedBackNewData) loadMoreData:@selector(FeedBackMoreData) isBeginRefresh:YES];
}

-(void)FeedBackNewData{
    page = 1;
    NSDictionary *Info;
    @try {
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@"5"
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getFeedbackListSms:Info];
    
}

-(void)FeedBackMoreData{
    page ++;
    NSDictionary *Info;
    @try {
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize)
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getFeedbackListSms:Info];

}

-(void)getFeedbackListSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{

    if (success == YES && redPacketInfo != nil) {
        [self.tableview tableViewEndRefreshCurPageCount:redPacketInfo.count];
        if (page == 1) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *itemDic in redPacketInfo) {
            FeedBackHistory *feedBackHistory =  [[FeedBackHistory alloc]initWith:itemDic];

            [_dataArray addObject:feedBackHistory];
        }
        [self.tableview reloadData];
        
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    FeedBackHistory *f = self.dataArray[indexPath.row];
    NSString *feedbackContent = f.feedbackContent;
    cell.askLab.text =feedbackContent;
    if ([f.reply isEqualToString:@"1"]){
        [cell.answerBtn setBackgroundImage:[UIImage  imageNamed:@"answer.png"]  forState:UIControlStateNormal];
        cell.answerLab.text=f.replyContent;
    }else{
        [cell.answerBtn setBackgroundImage:[UIImage imageNamed:@"response.png"]  forState:UIControlStateNormal];
        cell.answerLab.text = @"平台会尽快回复您，请您耐心等待，也可拨打客服电话400-600-5558";
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 120;
    }
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
