//
//  ForecastViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ForecastViewController.h"
#import "NewsListCell.h"
#import "TableHeaderView.h"
#import "JczqShortcutModel.h"
#import "UMChongZhiViewController.h"
#import "NewsModel.h"
#define KNewsListCell @"NewsListCell"
@interface ForecastViewController ()<UITableViewDataSource,UITableViewDelegate,LotteryManagerDelegate,NewsListCellDelegate>
{
    NSMutableArray <JczqShortcutModel *> *JczqShortcutList;
    __weak IBOutlet UITableView *tabForecastListView;
    JczqShortcutModel *curModel;
}
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;
@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A015";
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
    [self setViewController];
    [self setTableView];
    [self getJczqShortcut];
}

-(void)getJczqShortcut{
    JczqShortcutList = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self ;
    [self.lotteryMan getJczqShortcut];
}

-(void)gotJczqShortcut:(NSArray *)dataArray errorMsg:(NSString *)msg{
    if (dataArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    for (NSDictionary* infoDic in dataArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [JczqShortcutList addObject:model];
    }
    [tabForecastListView reloadData];
}

-(void)setViewController{
    
    self.title = @"精准预测";
    self.arrayTableSectionIsOpen = [NSMutableArray arrayWithArray:@[@(YES),@(YES),@(YES),@(YES)]];
    
}

-(void)setTableView{
    
    tabForecastListView.delegate = self;
    tabForecastListView.dataSource = self;
    [tabForecastListView registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    tabForecastListView.rowHeight = 117;
    [tabForecastListView reloadData];
}

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return JczqShortcutList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelect = NO;
    
    if ([self .fmdb open]) {
        FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_collect_match"];
        do {
            if ([[result stringForColumn:@"matchKey"] isEqualToString:JczqShortcutList[indexPath.row].matchKey] && [[result stringForColumn:@"cardCode"]isEqualToString:self.curUser.cardCode]) {
                isSelect = YES;
                break;
            }
        } while ([result next]);
        [self.fmdb close];
    }
    cell.delegate = self;
    [cell refreshData:JczqShortcutList[indexPath.row] andSelect:isSelect];
    return cell;
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
//    header.backgroundColor =RGBCOLOR(245, 245, 245);
//
//    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
//
//    header.btnActionClick.tag = section;
//    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    if ([self.arrayTableSectionIsOpen [section] boolValue] == YES) {
//        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
//
//    }else{
//        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
//    }
//    return header;
//}

//-(void)headerViewClick:(UIButton *)btn{
//    [UIView animateWithDuration:1.0 animations:^{
//
//        BOOL isOpen = [self.arrayTableSectionIsOpen[btn.tag] boolValue];
//        if (isOpen == YES) {
//            [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
//            [self.arrayTableSectionIsOpen insertObject:@(NO) atIndex:btn.tag];
//        }else{
//            [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
//            [self.arrayTableSectionIsOpen insertObject:@(YES) atIndex:btn.tag];
//        }
//        [tabForecastListView reloadData];
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    JczqShortcutModel * model =JczqShortcutList[indexPath.row];
    
    matchDetailVC.model = model ;//[model jCZQScoreZhiboToJcForecastOptions];
    if ([matchDetailVC.model.spfSingle boolValue] == YES) {
        matchDetailVC.isHis = YES;
    }else{
        
        matchDetailVC.isHis = NO;
    }
    matchDetailVC.hidesBottomBarWhenPushed = YES;
    matchDetailVC.curPlayType =@"jczq";
    [self.navigationController pushViewController:matchDetailVC animated:YES];
}

//"cardCode":"xxx","matchId":"x","isCollect":"x"
-(void)newScollectMatch:(JczqShortcutModel *)model andIsSelect:(BOOL)isSelect{
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    curModel = model;
    [self.lotteryMan collectMatch:@{@"cardCode":self.curUser.cardCode,@"matchKey":model.matchKey,@"isCollect":@(isSelect)}];
}

-(void)collectedMatch:(BOOL)isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect{
    if (isSuccess) {
        if (isSelect) {
            [self showPromptText:@"收藏成功" hideAfterDelay:1.7];
        }else{
            [self showPromptText:@"已取消收藏" hideAfterDelay:1.7];
        }
        [self saveCollectMatchInfoToloaction:isSelect];
    }
}

-(void)saveCollectMatchInfoToloaction:(BOOL)isSelect{
    
    BOOL issuccess;
    if ([self .fmdb open]) {
        
        if (isSelect) {
            issuccess=  [self.fmdb executeUpdate:@"insert into t_collect_match (matchKey,cardCode) values (?,?)  ",curModel.matchKey,self.curUser.cardCode];
        }else{
            FMResultSet*  result = [self.fmdb executeQuery:@"select * from t_collect_match"];
            
            do {
                if ([[result stringForColumn:@"matchKey"] isEqualToString:curModel.matchKey] &&[[result stringForColumn:@"cardCode"]isEqualToString:self.curUser.cardCode]) {
                    issuccess= [self.fmdb executeUpdate:@"delete from t_collect_match where matchKey = ? and cardCode = ? ",curModel.matchKey,self.curUser.cardCode];
                    break;
                }
            } while ([result next]);
        }
        
    }
    if (issuccess) {
        [self.fmdb close];
    }
    [tabForecastListView reloadData];
}

@end
