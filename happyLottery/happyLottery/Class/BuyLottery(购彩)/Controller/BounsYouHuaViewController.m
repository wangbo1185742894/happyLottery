//
//  BounsYouHuaViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BounsYouHuaViewController.h"
#import "SelectView.h"
#import "PayOrderViewController.h"
#import "SchemeCashPayment.h"
#import "BonusOptimize.h"
#import "BounsYouViewCell.h"
#import "MGLabel.h"

#define KBounsYouViewCell @"BounsYouViewCell"

@interface BounsYouHuaViewController ()<UITableViewDelegate,UITableViewDataSource,BounsYouViewCellDelegate,UITextFieldDelegate,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet SelectView *svInputMoney;
@property (weak, nonatomic) IBOutlet MGLabel *labTopInfo;
@property (weak, nonatomic) IBOutlet UITableView *tabBounsList;
@property (weak, nonatomic) IBOutlet MGLabel *labZhuInfo;
@property (weak, nonatomic) IBOutlet MGLabel *labBounsInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;
@property(nonatomic,strong)NSMutableArray *showChuanfa;
@end

@implementation BounsYouHuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showChuanfa = [NSMutableArray arrayWithCapacity:0];
    for (NSString *chuanfa in self.transcation.selectItems) {
        [_showChuanfa addObject:chuanfa];
    }
    
    [self.transcation.selectItems removeAllObjects];
    for (NSString *chuanfa in _showChuanfa) {
        NSArray * chuanFaCodeDic = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
        NSString * index = [chuanfa substringToIndex:1];
        NSDictionary * sectionCodeDic = chuanFaCodeDic[[index intValue]-1];
        NSDictionary * codeDic = sectionCodeDic[chuanfa];
        NSString * baseNum = codeDic[@"baseNum"];
        for (NSString *itemChuanfa in [baseNum componentsSeparatedByString:@","]) {
            NSString *item = [NSString stringWithFormat:@"%@串1",itemChuanfa];
//            if (![self.transcation.selectItems containsObject:itemChuanfa]) {
                [self.transcation .selectItems addObject:item];
//            }
        }
    }
    
    if (self.fromSchemeType == SchemeTypeFaqiGenDan) {
        [self.btnTouzhu setTitle:@"发单" forState:0];
    }else{
        [self.btnTouzhu setTitle:@"预约" forState:0];
    }
    self.lotteryMan.delegate =  self;
    [self setTableView];
    self.svInputMoney.beiShuLimit = 300000;
    [self.svInputMoney setTarget:self  rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    self.svInputMoney.labContent.text = [NSString stringWithFormat:@"%ld",self.transcation.betCost];
    self.svInputMoney.labContent.delegate =self;
    self.labTopInfo.text = [NSString stringWithFormat:@"  共%ld场比赛，过关方式：%@",self.transcation.selectMatchArray.count,[_showChuanfa componentsJoinedByString:@" "]];
    self.labTopInfo.keyWord = [_showChuanfa componentsJoinedByString:@" "];
    self.labTopInfo.keyWordColor = SystemGreen;

    self .zhuArray = [NSMutableArray arrayWithCapacity:0];
    [self bounsYouhua];
}

-(void)bounsYouhua{
    for (NSString *chuan in self.transcation.selectItems) {
        self.transcation.chuanFa = chuan;
        [self AllSelectMatchFenzu];
    }
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableArray  *  select in _zhuArray) {
        BounsModelItem *item = [[BounsModelItem alloc]init];
        item.selectItemList = select;
        item.multiple = @"1";
        [itemArray addObject:item];
    }
    _zhuArray  = itemArray;
    
    [self.tabBounsList reloadData];
    [self comMaxAndMinandAction:@selector(bonusOptimize)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text integerValue] < self.transcation.betCount * 2 ) {
        textField.text = [NSString stringWithFormat:@"%ld",self.transcation.betCount * 2];
    }
    
    if ([textField.text integerValue] %2 != 0) {
         textField.text = [NSString stringWithFormat:@"%ld",[textField.text integerValue] + 1];
    }
    self.transcation.betCost = [textField.text integerValue];
    [self.zhuArray removeAllObjects];
    [self bounsYouhua];
}

-(void)actionSub{
    NSInteger beiCount =[self.svInputMoney.labContent.text integerValue];
    if ( beiCount>self.transcation.betCount * 2 + 2 ) {
        beiCount -= 2;
    }
    self.svInputMoney.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    self.transcation.betCost = [ self.svInputMoney.labContent.text integerValue];
    [self.zhuArray removeAllObjects];
    [self bounsYouhua];
}

-(void)actionAdd{
    NSInteger  beiCount =[self.svInputMoney.labContent.text integerValue];
    if ( beiCount < self.svInputMoney.beiShuLimit - 2) {
        beiCount += 2;
    }
    self.svInputMoney.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    self.transcation.betCost = [ self.svInputMoney.labContent.text integerValue];
    [self.zhuArray removeAllObjects];
    [self bounsYouhua];
}

-(void)setTableView{
    self.tabBounsList.delegate = self;
    self.tabBounsList.dataSource = self;
    [self.tabBounsList registerNib:[UINib nibWithNibName:KBounsYouViewCell bundle:nil] forCellReuseIdentifier:KBounsYouViewCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _zhuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BounsYouViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KBounsYouViewCell];
    cell.delegate = self;
    [cell reloadModel:_zhuArray[indexPath.row]];
    cell.selectionStyle = 0;
    return cell;
}

-(void)doExchange:(NSMutableArray *) arrayLists{
    
    
    NSInteger len=arrayLists.count;
    //判断数组size是否小于2，如果小于说明已经递归完成了，否则你们懂得的，不懂？断续看代码
    if (len<2){
        [_zhuArray addObjectsFromArray:[arrayLists firstObject]];
        return;
    }
    //拿到第一个数组
    NSArray *arr0 = arrayLists[0];
    NSInteger  len0 = arr0.count;
    
    //拿到第二个数组
    NSArray * arr1= arrayLists[1];
    NSInteger len1=arr1.count;
    
    //计算当前两个数组一共能够组成多少个组合
    NSInteger lenBoth=len0*len1;
    
    //定义临时存放排列数据的集合
    NSMutableArray<NSMutableArray *>* tempArrayLists=[NSMutableArray arrayWithCapacity:0];
    
    //第一层for就是循环arrayLists第一个元素的
    for (int i=0;i<len0;i++){
        //第二层for就是循环arrayLists第二个元素的
        for (int j=0;j<len1;j++){
            //判断第一个元素如果是数组说明，循环才刚开始
            if (![arrayLists[0] isKindOfClass:[NSMutableArray class]]){
                NSArray * arr0= arrayLists[0];
                NSMutableArray * arr=[NSMutableArray arrayWithCapacity:0];
                [arr addObject:arr0[i]];;
                [arr addObject:arr1[j]];
                //把排列数据加到临时的集合中
                [tempArrayLists addObject:arr];
            }else {
                //到这里就明循环了最少一轮啦，我们把上一轮的结果拿出来继续跟arrayLists的下一个元素排列
                NSMutableArray <NSMutableArray *>* arrtemp= arrayLists[0];
                NSMutableArray * arr=[NSMutableArray arrayWithCapacity:0];
                for (int k=0;k<arrtemp[i].count;k++){
                    [arr addObject:arrtemp[i][k]];
                }
                [arr addObject:arr1[j]];
                [tempArrayLists addObject:arr];
            }
        }
    }
    
    //这是根据上面排列的结果重新生成的一个集合
    NSMutableArray * newArrayLists=[NSMutableArray arrayWithCapacity:0];
    //把还没排列的数组装进来，看清楚i=2的喔，因为前面两个数组已经完事了，不需要再加进来了
    for (int i=2;i<arrayLists.count;i++){
        [newArrayLists addObject:arrayLists[i]];;
    }
    //记得把我们辛苦排列的数据加到新集合的第一位喔，不然白忙了
    [newArrayLists insertObject:tempArrayLists atIndex:0];;
    
    //你没看错，我们这整个算法用到的就是递归的思想。
   [self doExchange:newArrayLists];
}

-(void)AllSelectMatchFenzu{
    BounsModelItem *modelItem  = [[BounsModelItem alloc]init];
    self.title = @"奖金优化";
    NSArray *allgroup = [self.transcation getSelectItemAllGroup];
    for (NSArray *itemArray in allgroup) {
        NSMutableArray *matchArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0;i < itemArray.count ; i++) {
            NSString *indexStr = itemArray[i];
            JCZQMatchModel *model  = self.transcation.selectMatchArray[[indexStr integerValue]];
            
            NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0 ; j< model.matchBetArray.count ; j ++) {
                NSString *item = model.matchBetArray[j];
                BounsModelBet *bet = [[BounsModelBet alloc]init];
                bet.playType = item;
                bet.sp = [NSString stringWithFormat:@"%.2f",[model getSpByMatchBet:item]];
                bet.homeName = model.homeName;
                bet.lineId = model.lineId;
                bet.matchKey  = model.matchKey;
                bet.clash  = [NSString stringWithFormat:@"%@VS%@",model.homeName,model.guestName];
                [itemArray addObject:bet];
                }
            NSArray *arr = [NSArray arrayWithArray:itemArray];
            [matchArray addObject:arr];
            }
            [self doExchange:matchArray];
        }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)bonusOptimize{
    CGFloat avgSp =[BonusOptimize getMincCommonDivisor:[self getAllSp]];
    CGFloat subOptimize = 0;
    for (BounsModelItem * model in _zhuArray) {
        subOptimize += avgSp / [model getSp];
    }
    NSInteger totalBei = self.transcation.betCost / 2;// _zhuArray.count * [self.transcation.beitou integerValue];
    for (BounsModelItem * model in _zhuArray) {
        if ([self.transcation.beitou integerValue] == 1) {
            NSString *itembei = [NSString stringWithFormat:@"%.0f",(avgSp /  [model getSp]) / subOptimize * _zhuArray.count * [self.transcation.beitou integerValue]];
                model.multiple = itembei;
        }else{
            model.multiple = @"1";
        }
        totalBei -= [model.multiple integerValue];
    }
    
    for (NSInteger i = totalBei; i > 0; i--) {
        BounsModelItem *minBounsModel = [_zhuArray firstObject];
        for (BounsModelItem * model in _zhuArray) {
            if ([model getSp] * [model.multiple integerValue] < [minBounsModel getSp] * [minBounsModel.multiple integerValue]) {
                minBounsModel = model;
            }
        }
        minBounsModel.multiple =  [NSString stringWithFormat:@"%ld",([minBounsModel.multiple integerValue] + 1)];
    }
    self.labZhuInfo.text = [NSString stringWithFormat:@"%ld注，共%ld元",self.transcation.betCount,self.transcation.betCost];
    
    [self hideLoadingView];
    
    for (BounsModelItem *model in _zhuArray) {
        
        NSLog(@"%.2f=========%@========%.2f",[model getSp],model.multiple,[model bouns]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BounsModelItem *model = _zhuArray[indexPath.row];
    return model.selectItemList.count * 30;
}

-(NSArray *)getAllSp{
    NSMutableArray *spList = [NSMutableArray arrayWithCapacity:0];
    for ( BounsModelItem *model in _zhuArray) {
        [spList addObject:@([model getSp])];
    }
    return spList;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTouzhu:(UIButton *)sender {
    
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }

        if (self.transcation.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }

    
    
    [self showLoadingText:@"正在提交订单"];
    
    self.transcation.maxPrize = 1.00;
    
    self.transcation.units = self.transcation.betCount;
    self.transcation.costType = CostTypeCASH;

    
    self.transcation.secretType = SecretTypeFullOpen;
    if (self.fromSchemeType == SchemeTypeFaqiGenDan) {
        self.transcation.schemeType = SchemeTypeFaqiGenDan;
        if (self.transcation.betCost < 10) {
            [self showPromptText:@"发单金额不能小于10元" hideAfterDelay:1.9];
            return;
        }
    }else{
        self.transcation.schemeType = SchemeTypeZigou;
    }
    NSMutableArray *betContent = [NSMutableArray arrayWithCapacity:0];
    for (BounsModelItem *item in _zhuArray) {
        NSArray * matches = [item lottDataScheme];
        NSString *chuanFaString = @"";
        if (item.selectItemList.count == 1) {
            chuanFaString = @"P1";
        }else{
            
            chuanFaString = [NSString stringWithFormat:@"P%ld_%d",item.selectItemList.count,1];
        }
        [betContent  addObject:@{
                                 @"betMatches":matches,
                                 @"passTypes":@[chuanFaString],
                                 @"multiple":item.multiple
                                 }];
    }
    [self.lotteryMan betLotteryScheme:self.transcation andBetContentArray:betContent];
}

- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.lotteryName = @"竞彩足球";
    schemeCashModel.schemeNo = schemeNO;
    
    schemeCashModel.subCopies = 1;
        schemeCashModel.costType = CostTypeCASH;
        if (self.transcation.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    [self hideLoadingView];
    payVC.schemetype = self.transcation.schemeType;
    schemeCashModel.subscribed = self.transcation.betCost;
    schemeCashModel.realSubscribed = self.transcation.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)actionUpdagte{
    [self.tabBounsList reloadData];
    NSInteger beiNum = 0;
    for (BounsModelItem *item in _zhuArray) {
        beiNum += [item.multiple integerValue];
    }
    self.svInputMoney.labContent.text = [NSString stringWithFormat:@"%ld",beiNum * 2];
    self.transcation.betCost = beiNum * 2;
    self.labZhuInfo.text = [NSString stringWithFormat:@"%ld注，共%ld元",self.transcation.betCount,self.transcation.betCost];
    [self comMaxAndMinandAction:NULL];
}

-(void)comMaxAndMinandAction:(SEL)action{
    
    CGFloat Max = 0.0;
    for (NSString *chuan in self.transcation.selectItems) {
        self.transcation.chuanFa = chuan;
        if (action != NULL) {
            [self performSelector:action];
        }
        
        [self.transcation peilvJiSuanBy:_zhuArray];
        Max += [self.transcation.mostBounds doubleValue];
    }
    
    CGFloat Min = CGFLOAT_MAX;
    for (BounsModelItem * model in _zhuArray) {
        if (Min > model.bouns) {
            Min = model.bouns;
        }
    }
    [self show:Min and:Max];
}

-(void)show:(CGFloat )min and:(CGFloat )max{
    if ([Utility toStringByInteger:min] == [Utility toStringByInteger:max]) {
        self.labBounsInfo.text = [NSString stringWithFormat:@"预计可中：%.2f元",max];
    }else{
        self.labBounsInfo.text = [NSString stringWithFormat:@"奖金区间：%.2f元~%.2f元",min,max];
    }
}

-(void)navigationBackToLastPage{
    [self.transcation.selectItems removeAllObjects];
    [self.transcation.selectItems addObjectsFromArray:_showChuanfa];
    [super navigationBackToLastPage];
}

@end

@implementation BounsModelBet

@end

@implementation BounsModelItem

-(instancetype)init{
    if (self == [super init]) {
        self.selectItemList = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(CGFloat)bouns{
    return [self getSp]* 2 * [self.multiple integerValue];
}

-(CGFloat)getSp{
    CGFloat item = 1;
    for (BounsModelBet *bet in self.selectItemList) {
        item *= [bet.sp doubleValue];
    }
    return item;
}

- (NSArray *)lottDataScheme{
    
    NSMutableArray *passTypes = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];
    
    for (BounsModelBet *bet in self.selectItemList) {
        
        NSMutableArray *betPlayTypes = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *option1 = [[NSMutableArray alloc]init];
        NSMutableArray *option2 = [[NSMutableArray alloc]init];
        NSMutableArray *option3 = [[NSMutableArray alloc]init];
        NSMutableArray *option4 = [[NSMutableArray alloc]init];
        NSMutableArray *option5 = [[NSMutableArray alloc]init];
        NSInteger play = [bet.playType integerValue]  / 100;
        NSString *itemPlay = [Utility toStringByInteger:[bet.playType integerValue]];
        if (play == 1) {
            contentArray = dic[@"SPF"];
            
            NSDictionary *dic = contentArray[itemPlay];
            NSString *option = [self getOption:dic];
             [option1 addObject:option];
        }
        
        if (play == 2) {
            contentArray = dic[@"RQSPF"];
            NSDictionary *dic = contentArray[itemPlay];
            NSString *option = [self getOption:dic];
            [option2 addObject:option];
        }
      
        
        if (play == 3) {
            contentArray = dic[@"BF"];
            NSDictionary *dic = contentArray[itemPlay];
            NSString *option = [self getOption:dic];
            [option3 addObject:option];
        }
        if (play == 4) {
            contentArray = dic[@"BQC"];
            NSDictionary *dic = contentArray[itemPlay];
            NSString *option = [self getOption:dic];
            [option4 addObject:option];
        }
        if (play == 5) {
            contentArray = dic[@"JQS"];
            NSDictionary *dic = contentArray[itemPlay];
            NSString *option = [self getOption:dic];
            [option5 addObject:option];
        }
        
        if (option1.count > 0) {
            NSDictionary * dic = @{@"options":option1,@"playType":@"1"};
            [betPlayTypes addObject:dic];
        }
        if (option2.count > 0) {
            NSDictionary * dic = @{@"options":option2,@"playType":@"5"};
            [betPlayTypes addObject:dic];
        }
        if (option3.count > 0) {
            NSDictionary * dic = @{@"options":option3,@"playType":@"3"};
            [betPlayTypes addObject:dic];
        }
        if (option4.count > 0) {
            NSDictionary * dic = @{@"options":option4,@"playType":@"4"};
            [betPlayTypes addObject:dic];
        }
        if (option5.count > 0) {
            NSDictionary * dic = @{@"options":option5,@"playType":@"2"};
            [betPlayTypes addObject:dic];
        }
        
        
        NSDictionary *dicMatches = @{@"dan":@NO,
                                     @"matchId": bet.lineId,
                                     @"clash":bet.clash,
                                     @"matchKey":bet.matchKey,
                                     @"betPlayTypes":betPlayTypes
                                     };
        [betMatches addObject:dicMatches];
    }
    
    return betMatches;
    
}

-(NSString*)getOption:(NSDictionary*)dic{
    
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        if (dic[@"code"] != nil) {
            return dic[@"code"];
        }
    }
    return  nil;
}

@end



