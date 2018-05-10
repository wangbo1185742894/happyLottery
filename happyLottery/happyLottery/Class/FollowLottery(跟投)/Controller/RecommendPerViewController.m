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

#define KRecomPerTableViewCell @"RecomPerTableViewCell"
@interface RecommendPerViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>


@property(nonatomic,strong)NSMutableArray <RecomPerModel *> * personArray;

@property (weak, nonatomic) IBOutlet UITableView *personList;

@property(nonatomic,strong)NSMutableArray *indexArray;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation RecommendPerViewController{
     UIView * topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.personList.delegate = self;
    self.personList.dataSource = self;
    [self.personList registerNib:[UINib nibWithNibName:KRecomPerTableViewCell bundle:nil] forCellReuseIdentifier:KRecomPerTableViewCell];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    self.indexArray = [NSMutableArray arrayWithCapacity:0];
    [self navigationBarInit];
    //data request
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
    [self.lotteryMan listRecommendPer:dic categoryCode:self.categoryCode];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//自定义navigationBar
- (void)navigationBarInit{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 147)];
    NSString *imageName;
    if (self.categoryCode isEqualToString:@"Cowman") {
        imageName = 
    }
    UIImageView *itemImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_guanyajun_beijing"]];
    itemImage.contentMode =UIViewContentModeScaleToFill;
    itemImage.frame = topView.frame;
    itemImage.contentMode= UIViewContentModeScaleToFill;
    [topView addSubview:itemImage];
    [self.navigationBar addSubview:topView];
    [self setLeftButton];
}

- (void)setLeftButton{
    UIButton *returnToRoot = [self creatBar:@"" icon:@"common_top_bar_back" andFrame:CGRectMake(20,64, 12,18) andAction:@selector(returnToRootView)];
    [topView addSubview:returnToRoot];
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


#pragma mark  lotteryMan

- (void) gotlistRecommend:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    [self.personArray removeAllObjects];
    //添加数据
    for (NSDictionary *dic in infoArray) {
        RecomPerModel *model = [[RecomPerModel alloc]initWithDic:dic];
        [self.personArray addObject:model];
    }
    [self.personList reloadData];
    
}//牛人，红人，红单榜

#pragma mark  tableView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //快滑结束触发
    if(!decelerate){
        [self reloadDate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //快滑结束触发
    [self reloadDate];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecomPerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecomPerTableViewCell];
    RecomPerModel *model = [self.personArray objectAtIndex:indexPath.row];
    [cell reloadDate:model categoryCode:self.categoryCode];
    //网络图片加载
    if ((self.personList.isDragging || self.personList.isDecelerating)&&![self.indexArray containsObject:indexPath]) {
        cell.userImage.image = [UIImage imageNamed:@""];
        return cell;
    }
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:model.personImageName] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![self.indexArray containsObject:indexPath]) {
            [self.indexArray addObject:indexPath];
        }
    }];
    return cell;

}

@end
