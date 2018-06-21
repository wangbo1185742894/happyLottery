//
//  RecommendPerViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RecommendPerViewController.h"
#import "RecomPerTableViewCell.h"
#import "RecomPerModel.h"
#import "PersonCenterViewController.h"

#define KRecomPerTableViewCell @"RecomPerTableViewCell"
@interface RecommendPerViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,XYTableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTopHeight;
@property (weak, nonatomic) IBOutlet UILabel *labTItle;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property(nonatomic,strong)NSMutableArray <RecomPerModel *> * personArray;

@property (weak, nonatomic) IBOutlet UILabel *labTop;
@property (weak, nonatomic) IBOutlet UITableView *personList;

@property(nonatomic,strong)NSMutableArray *indexArray;


@end

@implementation RecommendPerViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     *categoryCode; //榜单类别 Cowman，Redman，RedScheme
    if ([self.categoryCode isEqualToString:@"Cowman"]) {
        self.viewControllerNo = @"A417";
    }
    if ([self.categoryCode isEqualToString:@"Redman"]) {
        self.viewControllerNo = @"A418";
    }
    if ([self.categoryCode isEqualToString:@"RedScheme"]) {
        self.viewControllerNo = @"A419";
    }
    
    
    if ([self isIphoneX]) {
        _topDis .constant = -44;
        self.labTopHeight.constant = 88;
        
    }else{
        _topDis.constant = -20;
        self.labTopHeight.constant = 64;
    }
  
    self.personList.delegate = self;
    self.personList.dataSource = self;
    [self.personList registerNib:[UINib nibWithNibName:KRecomPerTableViewCell bundle:nil] forCellReuseIdentifier:KRecomPerTableViewCell];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    self.indexArray = [NSMutableArray arrayWithCapacity:0];
    [UITableView refreshHelperWithScrollView:self.personList target:self loadNewData:@selector(loadData) loadMoreData:@selector(loadData) isBeginRefresh:NO];
    
    [self loadData];
    
}


-(UIImage *)xy_noDataViewImage{
    return [UIImage imageNamed:@"pic_zanwushuju_tongyong"];
}

-(void)loadData{
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    NSDictionary *dic;
    if ([self.categoryCode isEqualToString:@"Cowman"]) {
        dic = @{@"channelCode":CHANNEL_CODE};
    } else {
        dic = nil;
    }
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan listRecommendPer:dic categoryCode:self.categoryCode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showLoadingText:nil];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationNameUserLogin object:nil];
}

- (void)reloadDate {
    //只刷新可视区域中的新cell
    NSArray *array = [self.personList indexPathsForVisibleRows];
    NSMutableArray *arrToReload = [NSMutableArray array];
    for (NSIndexPath *indexPath in array) {
        if (![self.indexArray containsObject:indexPath]) {
            [arrToReload addObject:indexPath];
        }
    }
    [self.personList reloadRowsAtIndexPaths:arrToReload withRowAnimation:UITableViewRowAnimationFade];
}

//////自定义navigationBar
//- (void)navigationBarInit{
//    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 147)];
//    NSString *imageName;
//    if ([self.categoryCode isEqualToString:@"Cowman"]) {
//        imageName = @"pic_niurenbangbeijing.png";
//    } else if ([self.categoryCode isEqualToString:@"Redman"]){
//        imageName = @"pic_hongrenbangbeijing.png";
//    }else {
//        imageName = @"pic_hongdanbangbeijing.png";
//    }
//    UIImageView *itemImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
//    itemImage.frame = topView.frame;
//    itemImage.contentMode= UIViewContentModeScaleToFill;
//    [topView addSubview:itemImage];
//
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,295/(750/KscreenWidth))];
    NSString *imageName;
    UILabel *jinLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth-75, 120, 90, 20)];
    jinLabel.text = @"近15日";
    jinLabel.textColor = [UIColor whiteColor];
    jinLabel.backgroundColor = [UIColor clearColor];
    
    if ([self.categoryCode isEqualToString:@"Cowman"]) {
        imageName = @"pic_niurenbangbeijing.png";
    } else if ([self.categoryCode isEqualToString:@"Redman"]){
        imageName = @"pic_hongrenbangbeijing.png";
        [image addSubview:jinLabel];
    }else {
        imageName = @"pic_hongdanbangbeijing.png";
        [image addSubview:jinLabel];
    }
    UIButton *returnToRoot = [self creatBar:@"" icon:@"newBack" andFrame:CGRectMake(10,30, 44,25) andAction:@selector(returnToRootView)];
    returnToRoot.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:imageName];
//    [image addSubview:returnToRoot];
    image.userInteractionEnabled = YES;
    return image;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 295/(750/KscreenWidth);
}

- (void)returnToRootView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton*)creatBar:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action{
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btnItem.frame = frame;
    if (title != nil) {
        [btnItem setTitle:title forState:0];
    }
    
    if (imgName != nil) {
        [btnItem setImage:[UIImage imageNamed:imgName] forState:0];
    }
    return btnItem;
}

-(NSNumber *)xy_noDataViewCenterYOffset{
    return @60;
}

-(BOOL)havData{
    if (self.personArray.count == 0) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark  lotteryMan

- (void) gotlistRecommend:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    [self.personList tableViewEndRefreshCurPageCount:infoArray.count];
    if (infoArray == nil) {
        [self showPromptViewWithText:msg hideAfter:1];
        [self .personList reloadData];
        return;
    }
    [self.personArray removeAllObjects];
    //添加数据
    for (NSDictionary *dic in infoArray) {
        RecomPerModel *model = [[RecomPerModel alloc]initWith:dic];
        [self.personArray addObject:model];
    }
    [self.personList reloadData];
    [self hideLoadingView];
    
}//牛人，红人，红单榜

#pragma mark  tableView
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //快滑结束触发
//    if(!decelerate){
//        [self reloadDate];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    //快滑结束触发
//    [self reloadDate];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ( self.personList.contentOffset.y> 100) {
        UIColor *color= RGBACOLOR(17, 199, 146, 1);
        self.topView.backgroundColor = color;
        return;
    }
    
    CGFloat offsetY = self.personList.contentOffset.y /100.0;
    UIColor *color= RGBACOLOR(17, 199, 146, offsetY);
    self.topView.backgroundColor = color;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecomPerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecomPerTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecomPerModel *model = [self.personArray objectAtIndex:indexPath.row];
    [cell reloadDate:model categoryCode:self.categoryCode];
    if(indexPath.row <3){
        cell.infoOneSum.textColor = RGBCOLOR(254, 58, 81);
        cell.infoTwoSum.textColor = RGBCOLOR(254, 58, 81);
    }
    else {
        cell.infoOneSum.textColor = [UIColor blackColor];
        cell.infoTwoSum.textColor = [UIColor blackColor];
    }
    if(indexPath.row == 0){
        [cell.orderImage setImage:[UIImage imageNamed:@"firstbang.png"]];
        cell.orderImage.hidden = NO;
        cell.orderLabel.hidden = YES;
    } else if (indexPath.row == 1){
        [cell.orderImage setImage:[UIImage imageNamed:@"second.png"]];
        cell.orderImage.hidden = NO;
        cell.orderLabel.hidden = YES;
    } else if (indexPath.row == 2){
        [cell.orderImage setImage:[UIImage imageNamed:@"third.png"]];
        cell.orderImage.hidden = NO;
        cell.orderLabel.hidden = YES;
    } else {
        cell.orderImage.hidden = YES;
        cell.orderLabel.hidden = NO;
        cell.orderLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    }

    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
  
    }];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    RecomPerModel *model = [self.personArray objectAtIndex:indexPath.row];
    PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
    viewContr.cardCode = model.cardCode;
    [self.navigationController pushViewController:viewContr animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)actionBack:(id)sender {
    [self navigationBackToLastPage];
}



@end
