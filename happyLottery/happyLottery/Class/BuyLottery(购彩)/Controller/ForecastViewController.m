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
@interface ForecastViewController ()<UITableViewDataSource,UITableViewDelegate,LotteryManagerDelegate,NewsListCellDelegate,XYTableViewDelegate>
{
    __weak IBOutlet UITableView *tabForecastListView;
    NSMutableArray  <JczqShortcutModel *>*colloectList;
    
}
@property(nonatomic,strong)NSMutableArray <NSMutableArray<HomeYCModel *> *> *dataArray;
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;
@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayTableSectionIsOpen = [NSMutableArray arrayWithCapacity:0];
    colloectList = [NSMutableArray arrayWithCapacity:0];
    self.viewControllerNo = @"A015";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
    [self setViewController];
    [self setTableView];
    [self getJczqShortcut];
}

-(UIImage *)xy_noDataViewImage{
    return [UIImage imageNamed:@"pic_gendankongbaiye.png"];
}


-(void)getJczqShortcut{
    self.lotteryMan.delegate = self ;
    [self.lotteryMan listByForecast:@{@"lotteryCode":@"jczq"} isHis:NO];
}

-(void)gotlistByForecast:(NSArray *)infoArray errorMsg:(NSString *)msg{
    
    
    if (infoArray == nil || infoArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        [tabForecastListView reloadData];
        return;
    }
    
    
    [self.dataArray removeAllObjects];
    
    for (NSDictionary *itemDic in infoArray) {
        BOOL isExit = NO;
        HomeYCModel *model = [[HomeYCModel alloc]initWithDic:itemDic];
        for (NSMutableArray *itemArray in self.dataArray) {
            HomeYCModel *firstModel = [itemArray firstObject];
            if (firstModel == nil || model.matchDate == nil) {
                break;
            }
            if ([firstModel.matchDate isEqualToString:model.matchDate]) {
                [itemArray addObject:model];
                isExit = YES;
                break;
            }
        }
        
        if (isExit == NO) {
            NSMutableArray  *marray = [NSMutableArray arrayWithCapacity:0];
            [self.arrayTableSectionIsOpen addObject:@(YES)];
            [marray addObject:model];
            [self.dataArray addObject:marray];
        }
    }
    if (self.curUser.isLogin) {
        [self getCollected];
    }else{
        [tabForecastListView reloadData];
    }
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

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL isOpen = [self.arrayTableSectionIsOpen[section] boolValue];
    if (isOpen == YES) {
        return self.dataArray[section].count;
    }else{
        return 0;
    }
}
   
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelect = NO;
    
    if (self.curUser .isLogin == YES) {
    
            for (JczqShortcutModel *model in colloectList) {
                if ([model.matchKey isEqualToString:self.dataArray[indexPath.section][indexPath.row].matchKey]) {
                    isSelect = YES;
                    break;
                }
            }
    }
    cell.delegate = self;
    [cell refreshData:[ _dataArray[indexPath.section][indexPath.row] jCZQScoreZhiboToJcForecastOptions] andSelect:isSelect];
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    JczqShortcutModel * model =[self.dataArray[indexPath.section][indexPath.row] jCZQScoreZhiboToJcForecastOptions];
    
    matchDetailVC.model = model ;//[model jCZQScoreZhiboToJcForecastOptions];
//    if ([matchDetailVC.model.spfSingle boolValue] == YES) {
//        
//    }else{
//        
//        matchDetailVC.isHis = NO;
//    }
    matchDetailVC.isHis = NO;
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

    [self.lotteryMan collectMatch:@{@"cardCode":self.curUser.cardCode,@"matchKey":model.matchKey,@"isCollect":@(isSelect)}];
}

-(void)collectedMatch:(BOOL)isSuccess errorMsg:(NSString *)msg andIsSelect:(BOOL)isSelect{
    if (isSuccess) {
        if (isSelect) {
            [self showPromptText:@"收藏成功" hideAfterDelay:1.7];
            
        }else{
            [self showPromptText:@"已取消收藏" hideAfterDelay:1.7];
            
        }
        
    }
    [self getCollected];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray*array= self.dataArray[section];
    
    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor =RGBCOLOR(245, 245, 245);
    
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    HomeYCModel *model = [array firstObject];
    header.labTime.text = model.matchDate;
    
    
    header.btnActionClick.tag = section;
    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.arrayTableSectionIsOpen [section] boolValue] == YES) {
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
        
    }else{
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return header;
}

-(void)headerViewClick:(UIButton *)btn{
    
    BOOL isOpen = [self.arrayTableSectionIsOpen[btn.tag] boolValue];
    if (isOpen == YES) {
        [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
        [self.arrayTableSectionIsOpen insertObject:@(NO) atIndex:btn.tag];
    }else{
        [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
        [self.arrayTableSectionIsOpen insertObject:@(YES) atIndex:btn.tag];
    }
    [tabForecastListView reloadData];
}


-(void)getCollected{
    [self.lotteryMan getCollectedMatchList:@{@"cardCode":self.curUser.cardCode,@"page":@(1),@"pageSize":@"100"}];
}

-(void)gotCollectedMatchList:(NSArray *)infoArray errorMsg:(NSString *)msg{
    
    if (infoArray == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    [colloectList removeAllObjects];
    
    for (NSDictionary* infoDic in infoArray) {
        JczqShortcutModel *model =  [[JczqShortcutModel alloc]initWith:infoDic];
        [colloectList addObject:model];
    }
    [tabForecastListView reloadData];
}


@end
