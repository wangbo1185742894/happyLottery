

//
//  JCZQMatchViewCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQMatchViewCell.h"
#import "MGLabel.h"


@interface  JCZQMatchViewCell ()
{
    JCZQMatchModel *curModel;
}
@property (weak, nonatomic) IBOutlet UILabel *labLeaName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchLine;
@property (weak, nonatomic) IBOutlet UILabel *labDeadLine;
@property (weak, nonatomic) IBOutlet UIButton *btBottom;
@property (weak, nonatomic) IBOutlet MGLabel *labHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UIView *playItemContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLabRangqiu;
@property(nonatomic,strong)NSDictionary *titleDic;
@property (weak, nonatomic) IBOutlet UIImageView *iconIsDanGuan;
@property (weak, nonatomic) IBOutlet UIButton *btnForecastItem1;
@property (weak, nonatomic) IBOutlet UIButton *btnForecastItem2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthPreNum;
@property (weak, nonatomic) IBOutlet UILabel *labPreBack;
@property (weak, nonatomic) IBOutlet UILabel *labPre;
@property (weak, nonatomic) IBOutlet UILabel *labPreIndex;
@property (weak, nonatomic) IBOutlet UIView *viewForecastContent;


@end

@implementation JCZQMatchViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JCZQMatchViewCell" owner:nil options:nil] lastObject];
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)initHHGGCellSubItem{
    self.widthLabRangqiu.constant = 28;
    [self creatBtnWithFrame:CGRectMake(0.5, 0, 24, self.playItemContentView.mj_h / 2 - 5 ) normal:@{@"nTitle":@"0",@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@""} andTag:0 andSelect:@"0"];
    UIButton *handicap = [self creatBtnWithFrame:CGRectMake(0,self.playItemContentView.mj_h / 2 - 5, 25, self.playItemContentView.mj_h / 2 -5) normal:@{@"nTitle":curModel.handicap == nil?@"0":curModel.handicap,@"nImage":@"",@"sImage":@""} andTag:0 andSelect:@"0"];
    handicap.selected  = YES;
    [handicap setTitleColor:[UIColor whiteColor] forState:0];
    if ([curModel.handicap integerValue] >0) {
        [handicap setBackgroundImage:[UIImage imageNamed:@"rangqiuzheng"] forState:0];
        
    }else{
        [handicap setBackgroundImage:[UIImage imageNamed:@"rangqiufu"] forState:0];
    }
    float marginRight = 3;
    float marginTop = 5;
    float curX;
    float curY;
    float width =( KscreenWidth - 135 ) / 3;
    float height = (_playItemContentView.mj_h - 15 ) / 2;
    NSDictionary *titRQDic = self.titleDic[@"RQSPF"];
    NSDictionary *titDic = self.titleDic[@"SPF"];
    
    for (int i = 0; i < 6; i ++ ) {
        curX = i % 3 *(width + marginRight) + marginRight + 25;
        curY = i / 3 *(height + marginTop);
        
        if (i < 3) {
            NSString *title = [NSString stringWithFormat:@"%@%@",titDic[[NSString stringWithFormat:@"%d",100 + i]][@"appear"],[self getSpTitle:curModel.SPF_OddArray index:i]];
            [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":title,@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:100 + i andSelect:curModel.SPF_SelectMatch[i]];
        }else{
            NSString *title = [NSString stringWithFormat:@"%@%@",titRQDic[[NSString stringWithFormat:@"%d",200 + i%3]][@"appear"],[self getSpTitle:curModel.RQSPF_OddArray index:i%3]];
            [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":title,@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:200 + i%3 andSelect:curModel.RQSPF_SelectMatch[i%3]];
        }
        
    }
    if ([curModel selectItemNum] == 0) {
        
        [self creatBtnWithFrame:CGRectMake(KscreenWidth - 97, 0, 30, self.playItemContentView.mj_h - 10) normal:@{@"nTitle":@"全部玩法",@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:1000 andSelect:@"0"];
    }else{
        
        [self creatBtnWithFrame:CGRectMake(KscreenWidth - 97, 0, 30, self.playItemContentView.mj_h - 10) normal:@{@"nTitle":[NSString stringWithFormat:@"已选%ld项",[curModel selectItemNum]],@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:1000 andSelect:@"1"];
    }
}

-(NSString *)getSpTitle:(NSArray *)oddArray index:(NSInteger)i{
    float sp = 0.00;
    if (oddArray.count > i ) {
        sp = [oddArray[i] doubleValue];
    }
    NSString *itemStr = [NSString stringWithFormat:@"(%.2f)",sp];
    return itemStr;
}

-(UILabel *)creatLab:(CGRect )frame withDic:(NSDictionary *)dic{
    
    UILabel *itemlab = [[UILabel alloc]initWithFrame:frame];
    itemlab.backgroundColor = dic[@"bgColor"];
    itemlab.textColor = dic[@"tColor"];
    itemlab.font = [UIFont systemFontOfSize:12];
    itemlab.text = dic[@"title"];
    [self.playItemContentView addSubview:itemlab];
    return itemlab;
    
}

-(UIButton *)creatBtnWithFrame:(CGRect)frame attribute:(NSDictionary *)dic{
    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.frame =  frame;
    [item setAttributedTitle:dic[@"aNTitle"] forState:UIControlStateNormal];
    [item setAttributedTitle:dic[@"aSTitle"] forState:UIControlStateSelected];
    [item setBackgroundImage:[UIImage imageNamed: dic[@"nImage"]] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed: dic[@"sImage"]] forState:UIControlStateSelected];
    [self.playItemContentView addSubview:item];
    return item;
    
}

-(UIButton *)creatBtnWithFrame:(CGRect)frame normal:(NSDictionary *)dic andTag:(NSInteger )tag andSelect:(NSString *)isselect{
    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.frame =  frame;
    item.tag = tag;
    item.selected = [isselect boolValue];
    NSMutableAttributedString *attrStrN = [[NSMutableAttributedString alloc] initWithString:dic[@"nTitle"]];
    NSMutableAttributedString *attrStrS = [[NSMutableAttributedString alloc] initWithString:dic[@"nTitle"]];
    if ([self isCanBuyThisType:item]) {
        NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72)};
        [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
        
        
        NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
        
    }else{
        NSDictionary * firstAttributesN = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
        [attrStrN setAttributes:firstAttributesN range:NSMakeRange(0, attrStrN.string.length)];
        [item setAttributedTitle:attrStrN forState:0];
        
        NSDictionary * firstAttributesS = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBCOLOR(72, 72, 72),NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
        [attrStrS setAttributes:firstAttributesS range:NSMakeRange(0, attrStrS.string.length)];
        [item setAttributedTitle:attrStrS forState:0];
    }
    [item setAttributedTitle:attrStrS forState:UIControlStateSelected];
    [item setAttributedTitle:attrStrN forState:0];
//    [item setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
//    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    item.titleLabel.numberOfLines = 0;
    item.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    item.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [item setBackgroundImage:[UIImage imageNamed: dic[@"nImage"]] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:dic[@"sImage"]]  forState:UIControlStateSelected];
    [self.playItemContentView addSubview:item];
    
    [item addTarget:self action:@selector(jczqCellItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
    
}

-(BOOL)isCanBuyThisType:(UIButton *)sender{
    
    if (sender.tag == 0) {  //无效button
        
        return YES;
    }
    
    if (sender.tag == 1000) {  //全部玩法 展开
        
        return YES;
    }
    if (sender.tag == 2000) { //半全场  展开
        
        return YES;
    }
    if (sender.tag == 3000) { // 比分展开
        
        return YES;
    }
    
    NSInteger playType = sender.tag / 100;
    NSInteger index = sender.tag % 100;
    NSString *title;
    BOOL isCanBuy = YES;
    switch (playType) {
        case 1:
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:0];
            title = [self getSpNOTitle:curModel.SPF_OddArray index:index];
            break;
        case 2:
            title = [self getSpNOTitle:curModel.RQSPF_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:4];
            
            break;
        case 3:
            title = [self getSpNOTitle:curModel.BF_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:2];
            
            break;
        case 4:
            title = [self getSpNOTitle:curModel.BQC_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:3];
            
            break;
        case 5:
            title = [self getSpNOTitle:curModel.JQS_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:1];
            
            break;
        default:
            break;
    }
    
    if (isCanBuy == NO || [title doubleValue] == 0) {
        return NO;
    }else{
        if ([curModel.status isEqualToString:@"ENDED"]) {
            
            return NO;
        }
        
        if ([curModel.status isEqualToString:@"CANCLE"]) {
            
            return NO;
        }
        
        if ([curModel.status isEqualToString:@"PAUSE"]) {
            
            return NO;
        }
        return YES;
        
    }
}

-(void)jczqCellItemClick:(UIButton *)sender{
    if (sender.tag == 0) {  //无效button
        
        return;
    }
    
    if (sender.tag == 1000) {  //全部玩法 展开
        [self.delegate showAllPlayType:curModel :self.titleDic];
        return;
    }
    if (sender.tag == 2000) { //半全场  展开
        [self.delegate showBQCPlayType:curModel:self.titleDic[@"BQC"]];
        return;
    }
    if (sender.tag == 3000) { // 比分展开
        [self.delegate showBFPlayType:curModel:self.titleDic[@"BF"]];
        return;
    }
    //选择了赛事
    NSInteger playType = sender.tag / 100;
    NSInteger index = sender.tag % 100;
    NSString *title;
    BOOL isCanBuy = YES;
    switch (playType) {
        case 1:
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:0];
             title = [self getSpNOTitle:curModel.SPF_OddArray index:index];
            break;
        case 2:
            title = [self getSpNOTitle:curModel.RQSPF_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:4];
         
            break;
        case 3:
            title = [self getSpNOTitle:curModel.BF_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:2];
           
            break;
        case 4:
            title = [self getSpNOTitle:curModel.BQC_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:3];
            
            break;
        case 5:
            title = [self getSpNOTitle:curModel.JQS_OddArray index:index];
            isCanBuy = [self.delegate canBuyThisMatch:curModel andIndex:1];
        
            break;
        default:
            break;
    }
    
    if (isCanBuy == NO) {
        [self.delegate showSPFARQSPFSelecedMsg:@"该玩法暂不支持投注"];
        return;
    }
    
    if ([title doubleValue] == 0) {
        [self.delegate showSPFARQSPFSelecedMsg:@"该玩法暂不支持投注"];
        return;
    }
    if ([curModel.status isEqualToString:@"ENDED"]) {
        [self.delegate showSPFARQSPFSelecedMsg:@"该场比赛已结束"];
        return;
    }
    
    if ([curModel.status isEqualToString:@"CANCLE"]) {
        [self.delegate showSPFARQSPFSelecedMsg:@"该场比赛已取消"];
        return;
    }
    
    if ([curModel.status isEqualToString:@"PAUSE"]) {
        [self.delegate showSPFARQSPFSelecedMsg:@"该场比赛已暂停"];
        return;
    }
  
    sender.selected  = !sender.selected;
    switch (playType) {
        case 1:
            [curModel.SPF_SelectMatch replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",sender.selected]];
            break;
        case 2:
            [curModel.RQSPF_SelectMatch replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",sender.selected]];
            break;
        case 3:
            [curModel.BF_SelectMatch replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",sender.selected]];
            break;
        case 4:
            [curModel.BQC_SelectMatch replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",sender.selected]];
            break;
        case 5:
            [curModel.JQS_SelectMatch replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",sender.selected]];
            break;
        default:
            break;
    }
    UIButton  *temp = (UIButton*)[self viewWithTag:1000];
    
    if ([curModel selectItemNum] == 0) {
        
        [temp setTitle:[NSString stringWithFormat:@"全部玩法"] forState:0];
        temp.selected = NO;
    }else{
        
        [temp setTitle:[NSString stringWithFormat:[NSString stringWithFormat:@"已选%ld项",[curModel selectItemNum]]] forState:0];
        temp.selected = YES;
    }
    
    [self.delegate showSPFARQSPFSelecedMsg:nil];
}
-(void)reloadDataMatch:(JCZQMatchModel *)match andProfileTitle:(NSString *)title andGuoguanType:(JCZQPlayType )playType{
    for (UIView *subView in self.playItemContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (match.isShow == YES) {
        self.viewForecastContent.hidden = NO;
    }else{
        self.viewForecastContent.hidden = YES;
    }
    
    self.labPre.layer.cornerRadius = 2;
    self.labPre.layer.masksToBounds = YES;
    self.labPreBack.layer.cornerRadius = 2;
    self.labPreBack.layer.masksToBounds = YES;
    
    curModel = match;
    if (curModel.isDanGuan == YES) {
        self.iconIsDanGuan. hidden = NO;
    }else{
        self.iconIsDanGuan. hidden = YES;
    }
    _titleDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiCode" ofType:@"plist"]];
    
    self.labLeaName.text = match.leagueName;
    if (match.stopBuyTime.length >0) {
        self.labDeadLine.text =[NSString stringWithFormat:@"截止%@",[match.stopBuyTime substringWithRange:NSMakeRange(11, 5)]];
    }
    
    self.labHomeName.text = [NSString stringWithFormat:@"%@(主)",match.homeName];

    self.labHomeName.keyWord = @"(主)";
    self.labHomeName.keyWordFont = [UIFont systemFontOfSize:12];
    self.labHomeName.keyWordColor = SystemBlue;
    self.labGuestName.text = match.guestName;
    self.labMatchLine .text = match.lineId;
    NSString *funname = [NSString stringWithFormat:@"init%@CellSubItem",title];
    SEL function = NSSelectorFromString(funname);
    if ([self respondsToSelector:function]) {
        [self performSelector:function withObject:nil];
    }
}

-(void)initRQSPFCellSubItem{
    self.widthLabRangqiu.constant = 28;
    UIButton* handicap =[self creatBtnWithFrame:CGRectMake(0, 5, 25, 40) normal:@{@"nTitle":curModel.handicap,@"nImage":@"",@"sImage":@""} andTag:0 andSelect:@"0"];
    [handicap setTitleColor:[UIColor whiteColor] forState:0];
    if ([curModel.handicap integerValue] >0) {
        [handicap setBackgroundImage:[UIImage imageNamed:@"rangqiuzheng"] forState:0];
    }else{
        [handicap setBackgroundImage:[UIImage imageNamed:@"rangqiufu"] forState:0];
        
    }
    float marginRight = 3;
    float marginTop = 5;
    float curX;
    float curY;
    float width =( KscreenWidth - 106 ) / 3;
    float height = 40;
    NSDictionary *titDic = self.titleDic[@"RQSPF"];
    for (int i = 0; i < 3; i ++ ) {
        curX = i % 3 *(width + marginRight) + marginRight + 25;
        curY = i / 3 *(height + marginTop) + 5;
        NSString *title = [NSString stringWithFormat:@"%@%@",titDic[[NSString stringWithFormat:@"%d",200 + i]][@"appear"],[self getSpTitle:curModel.RQSPF_OddArray index:i]];
        [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":title,@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:200 + i andSelect:curModel.RQSPF_SelectMatch[i]];
    }
}

-(void)initSPFCellSubItem{
    self.widthLabRangqiu.constant = 28;
    NSDictionary *titDic = self.titleDic[@"SPF"];
    float marginRight = 3;
    float marginTop = 5;
    float curX;
    float curY;
    float width =( KscreenWidth - 80 ) / 3;
    float height = 40;
    
    for (int i = 0; i < 3; i ++ ) {
        curX = i % 3 *(width + marginRight) + marginRight;
        curY = i / 3 *(height + marginTop)+marginTop ;
        NSString *title = [NSString stringWithFormat:@"%@%@",titDic[[NSString stringWithFormat:@"%d",100 + i]][@"appear"],[self getSpTitle:curModel.SPF_OddArray index:i]];
        [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":title,@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag: 100 + i andSelect:curModel.SPF_SelectMatch[i]];
    }
}

-(void)initJQSCellSubItem{
    self.widthLabRangqiu.constant = 0;
    NSDictionary *titDic = self.titleDic[@"JQS"];
    float marginRight = 3;
    float marginTop = 5;
    float curX;
    float curY;
    float width =( KscreenWidth - 84 ) / 4;
    float height = (_playItemContentView.mj_h - 20 ) / 2;
    
    for (int i = 0; i < 8; i ++ ) {
        curX = i % 4 *(width + marginRight) + marginRight;
        curY = i / 4 *(height + marginTop) + marginTop;
         NSString *title = [NSString stringWithFormat:@"%@%@",titDic[[NSString stringWithFormat:@"%d",500 + i]][@"appear"],[self getSpTitle:curModel.JQS_OddArray index:i]];
        [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":title,@"nImage":@"yuanjiaowubiankuangnomal",@"sImage":@"yuanjiaowukuangselect"} andTag:500 + i andSelect:curModel.JQS_SelectMatch[i]];
    }
}

-(void)initBQCCellSubItem{
    self.widthLabRangqiu.constant = 0;
    float curX = 3;
    float curY = 10;
    float width =KscreenWidth - 73;
    float height = 37;
    if ([curModel selectItemNum] == 0) {
            [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":@"点击展开全部",@"nImage":@"jczqshowallback",@"sImage":@"wukuangwuyuanjiaoselect"} andTag:2000 andSelect:@"0"];
    }else{
            [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":[NSString stringWithFormat:@"已选%ld项",[curModel selectItemNum]],@"nImage":@"jczqshowallback",@"sImage":@"wukuangwuyuanjiaoselect"} andTag:2000 andSelect:@"1"];
    }

}

-(void)initBFCellSubItem{
    self.widthLabRangqiu.constant = 0;
    float curX = 3;
    float curY = 10;
    float width =KscreenWidth - 73;
    float height = 37;
    if ([curModel selectItemNum] == 0) {
        [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":@"点击展开全部",@"nImage":@"jczqshowallback",@"sImage":@"wukuangwuyuanjiaoselect"} andTag:3000 andSelect:@"0"];
    }else{
        [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":[NSString stringWithFormat:@"已选%ld项",[curModel selectItemNum]],@"nImage":@"jczqshowallback",@"sImage":@"wukuangwuyuanjiaoselect"} andTag:3000 andSelect:@"1"];
    }
//    [self creatBtnWithFrame:CGRectMake(curX, curY, width, height) normal:@{@"nTitle":@"点击展开全部",@"nImage":@"jczqshowallback",@"sImage":@"wukuangwuyuanjiaoselect"} andTag:3000 andSelect:@"0"] ;
    
}
- (IBAction)actionForecastDetail:(UIButton *)sender {
    [self.delegate showMatchDetailWith:curModel.ycModel];
}
- (IBAction)labSchemeRecom:(UIButton *)sender {
    [self.delegate showSchemeRecom];
}

-(NSString *)getSpNOTitle:(NSArray *)oddArray index:(NSInteger)i{
    float sp = 0.00;
    if (oddArray.count > i ) {
        sp = [oddArray[i] doubleValue];
    }
    NSString *itemStr = [NSString stringWithFormat:@"%.2f",sp];
    return itemStr;
}



- (IBAction)actionShowForecastDetail:(UIButton *)sender {
    
    curModel.isShow = !curModel.isShow;
    self.viewForecastContent.hidden = !curModel.isShow;
    [self.delegate showForecastDetailForCellBottom:curModel];
}

-(void)refreshWithYcInfo:(HomeYCModel *)homeModel{
    
    if (homeModel == nil) {
        return;
    }
    self.widthPreNum.constant = [homeModel.predictIndex doubleValue] / 100 * self.labPreBack.mj_w;
    self.labPreIndex.text = [NSString stringWithFormat:@"%.0f%%",[homeModel.predictIndex doubleValue]];
    self.btnForecastItem1.hidden = YES;
    self.btnForecastItem2.hidden = YES;
    
    for (JcForecastOptions  * op in homeModel.predict) {
        NSString *title;
        BOOL isselect = [op.forecast boolValue];
        if (!isselect) {
            continue;
        }
        switch ([op.options integerValue]) {
            case 0:
                
                title = [NSString stringWithFormat:@"胜 %@",op.sp];
                
                break;
                
            case 1:
                title = [NSString stringWithFormat:@"平 %@",op.sp];
                
                break;
                
                
            case 2:
                title = [NSString stringWithFormat:@"负 %@",op.sp];
                
                break;
            default:
                break;
        }
        if (_btnForecastItem1.hidden == YES) {
            [_btnForecastItem1 setTitle:title forState:0];
            _btnForecastItem1.hidden = NO;
        }else{
            [_btnForecastItem2 setTitle:title forState:0];
            _btnForecastItem2.hidden = NO;
        }
    }
    
}

-(void)canBuy{
    
}

@end
