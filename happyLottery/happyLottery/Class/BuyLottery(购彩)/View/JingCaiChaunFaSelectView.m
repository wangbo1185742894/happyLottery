//
//  JingCaiChaunFaSelectView.m
//  Lottery
//
//  Created by 王博 on 2017/7/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#define ROWNUM 4
#import "JingCaiChaunFaSelectView.h"

@interface JingCaiChaunFaSelectView ()

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labSingle;

@property (weak, nonatomic) IBOutlet UILabel *labMutiple;
@property (weak, nonatomic) IBOutlet UIView *viewSingle;
@property (weak, nonatomic) IBOutlet UIView *viewMutiple;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewSingle;
@property (weak, nonatomic) IBOutlet JingCaiChaunFaSelectView *viewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightIViewMutiple;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewContent;

@property(strong,nonatomic)NSMutableArray *singleTitles;
@property(strong,nonatomic)NSMutableArray *mutipleTitles;


@property(strong,nonatomic)NSMutableArray *singleBtnItems;
@property(strong,nonatomic)NSMutableArray *mutipleBtnItmew;

@property (nonatomic , strong) NSArray * dataSource;

@end
@implementation JingCaiChaunFaSelectView


-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JingCaiChaunFaSelectView" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    self.singleTitles = [NSMutableArray arrayWithCapacity:0];
    self.mutipleTitles = [NSMutableArray arrayWithCapacity:0];
    
    self.singleBtnItems = [NSMutableArray arrayWithCapacity:0];
    self.mutipleBtnItmew = [NSMutableArray arrayWithCapacity:0];
    return self;
}

-(void)setTitle:(NSString *)title andSingleTitle:(NSArray *)singleTitles andMutipleTitle:(NSArray *)mutipleTitles{

    if (self.mutipleTitles.count == 0) {
        self.labMutiple.hidden =  YES;
    }else{
        self.labMutiple.hidden =  NO;
    }
    self.labTitle.text = title;
    float width =( KscreenWidth - 40-9) /ROWNUM;
    float height = 25;
    
    for (int i = 0; i < self.singleTitles.count ; i++) {
        
        float curX = (i % ROWNUM) * (width+3);
        float curY = (i/ROWNUM)*(height + 3);
        
        UIButton *singleItem = [self creatBtnItem:self.singleTitles[i] andFrame:CGRectMake(curX, curY, width, height)];
        if ([self.selectedItems containsObject:self.singleTitles[i]]) {
            singleItem.selected = YES;
        }
        [self.viewSingle addSubview:singleItem];
        [self.singleBtnItems addObject:singleItem];
    }
    
    if (self.singleTitles .count %ROWNUM != 0) {
       self.heightViewSingle.constant = (self.singleTitles.count / ROWNUM  +1) *(height + 3) ;
    }else{
       self.heightViewSingle.constant = (self.singleTitles.count / ROWNUM) *(height + 3) ;
    }
    
  
    for (int i = 0; i < self.mutipleTitles.count ; i++) {
        
        float curX = (i % ROWNUM) * (width+3);
        float curY = (i/ROWNUM)*(height + 3);
        
        UIButton *mutipleItem = [self creatBtnItem:self.mutipleTitles[i] andFrame:CGRectMake(curX, curY, width, height)];
        if ([self.selectedItems containsObject:self.mutipleTitles[i]]) {
            mutipleItem.selected = YES;
        }
        [self.viewMutiple addSubview:mutipleItem];
        [self.mutipleBtnItmew addObject:mutipleItem];
    }
    
    if (self.mutipleTitles.count % ROWNUM != 0) {
       self.heightIViewMutiple.constant = (self.mutipleTitles.count / ROWNUM  +1) *(height + 3) ;
    }else{
        
        self.heightIViewMutiple.constant = (self.mutipleTitles.count / ROWNUM) *(height + 3) ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heightViewContent.constant = self.viewMutiple.mj_h + self.viewMutiple.mj_y + 30;
    });
}

-(UIButton *)creatBtnItem:(NSString *)title andFrame:(CGRect )frame{

    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item .frame = frame;
    [item setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    [item setTitleColor:SystemGreen forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:14];
    [item setTitle:title forState:0];
    [item setBackgroundImage:[UIImage imageNamed:@"button_default"] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:@"button_checked"] forState:UIControlStateSelected];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}

-(void)itemClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    [self.selectedItems removeAllObjects];
    for (UIButton *item in self.singleBtnItems) {
        if (item.selected == YES) {
            [self.selectedItems addObject:item.currentTitle];
        }
    }
    
    for (UIButton * item in self.mutipleBtnItmew) {
        if (item.selected == YES) {
            [self.selectedItems addObject:item.currentTitle];
        }
    }
    
    [self.delegate selectChuanFa:self.selectedItems];
}


-(void)handleDataSource:(UIView *)supview{
    for (NSString *title in self.dataSource) {
        if ([title isEqualToString:@"单关"] || [title isEqualToString:@"单场"]) {
            [self.singleTitles addObject:title];
        }else if ([[[title componentsSeparatedByString:@"串"] lastObject] integerValue] == 1) {
            [self.singleTitles addObject:title];
        }else if ([[[title componentsSeparatedByString:@"串"] lastObject] integerValue] != 1){
            [self.mutipleTitles addObject:title];
        }
    }
    [supview addSubview:self];
    [self setTitle:[NSString stringWithFormat:@"%lu场比赛",(unsigned long)_transation.selectMatchArray.count] andSingleTitle:self.singleTitles andMutipleTitle:self.mutipleTitles];
}

- (void)showFromSuperView:(UIView *)supview{
    _supportDanguan = false;
    
    if(_transation.playType  == JCZQPlayTypeDanGuan)
    {
            NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
            NSMutableArray * temp = [NSMutableArray array];
            int chuanFaKey = 0;
            if (([_transation.curProfile.Desc isEqualToString:@"SPF"] ||[_transation.curProfile.Desc isEqualToString:@"RQSPF"] )&&  _transation.selectMatchArray.count > 8) {
                chuanFaKey = 8;
            }else if ([_transation.curProfile.Desc isEqualToString:@"BQC"]){
                if (_transation.selectMatchArray.count>4) {
                    chuanFaKey = 4;
                }else{
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }else if ([_transation.curProfile.Desc isEqualToString:@"BF"]){
                if (_transation.selectMatchArray.count>4) {
                    chuanFaKey = 4;
                }else{
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }else if ([_transation.curProfile.Desc isEqualToString:@"JQS"]){
                if (_transation.selectMatchArray.count>6) {
                    chuanFaKey = 6;
                }else{
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }else if ([_transation.curProfile.Desc isEqualToString:@"HHGG"]){
                
                NSInteger bf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"BF"];
                NSInteger spf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"SPF"];
                NSInteger rqspf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"RQSPF"];
                NSInteger bqc_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"BQC"];
                NSInteger jqs_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"JQS"];
                
                if (!jqs_cunt == 0 && bf_cunt == 0 && bqc_cunt == 0) {
                    if (_transation.selectMatchArray.count > 6) {
                        chuanFaKey = 6;
                    }
                    else
                    {
                        chuanFaKey = (int)_transation.selectMatchArray.count;
                    }
                    
                }else if (!bf_cunt == 0) {
                    if (_transation.selectMatchArray.count > 4) {
                        chuanFaKey = 4;
                    }
                    else
                    {
                        chuanFaKey = (int)_transation.selectMatchArray.count;
                    }
                }else if (!bqc_cunt == 0){
                    if (_transation.selectMatchArray.count >4) {
                        chuanFaKey = 4;
                    }
                    else
                    {
                        chuanFaKey = (int)_transation.selectMatchArray.count;
                    }
                }else if (!spf_cunt ==0 || !rqspf_cunt == 0) {
                    if (_transation.selectMatchArray.count >8) {
                        chuanFaKey = 8;
                    }
                    else
                    {
                        chuanFaKey = (int)_transation.selectMatchArray.count;
                    }
                }
            }
            else{
                chuanFaKey = (int)_transation.selectMatchArray.count;
            }
            if([_transation.curProfile.Desc isEqualToString:@"BF"])
            {
                for (int i=0; i<chuanFaKey; i++) {
                    NSDictionary * info = array[i];
                    [temp addObjectsFromArray:[info allKeys]];
                }
            }
            else
            {
                for (int i=1; i<chuanFaKey; i++) {
                    NSDictionary * info = array[i];
                    [temp addObjectsFromArray:[info allKeys]];
                }
            }
            
            NSArray * sortResult  = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString * chuanFir = (NSString *)obj1;
                NSString * chuanSec = (NSString *)obj2;
                NSString * chuanFirNum = [chuanFir stringByReplacingOccurrencesOfString:@"串" withString:@""];
                NSString * chuanSecNum = [chuanSec stringByReplacingOccurrencesOfString:@"串" withString:@""];
                
                int firSubFir = [[chuanFirNum substringToIndex:1] intValue];
                int secSubFir = [[chuanSecNum substringToIndex:1] intValue];
                if (firSubFir > secSubFir) {
                    return NSOrderedDescending;
                }else if (firSubFir == secSubFir){
                    NSString *  firChuanSubNum = [chuanFir substringFromIndex:2];
                    NSString *  secChuanSubNum = [chuanSec substringFromIndex:2];
                    if ([firChuanSubNum intValue] > [secChuanSubNum intValue]) {
                        return NSOrderedDescending;
                    }else{
                        return NSOrderedAscending;
                    }
                }else{
                    return NSOrderedAscending;
                }
            }];
            [temp removeAllObjects];
            if (_transation.playType == JCZQPlayTypeDanGuan &&![_transation.curProfile.Desc isEqualToString:@"BF"]) {
                [temp addObject: @"单场"];
            }
            [temp addObjectsFromArray:sortResult];
            self.dataSource = temp;
        
    }else{
        NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
        NSMutableArray * temp = [NSMutableArray array];
        int chuanFaKey = 0;
        if (([_transation.curProfile.Desc isEqualToString:@"SPF"] ||[_transation.curProfile.Desc isEqualToString:@"RQSPF"] )&&  _transation.selectMatchArray.count > 8) {
            chuanFaKey = 8;
        }else if ([_transation.curProfile.Desc isEqualToString:@"BQC"]){
            if (_transation.selectMatchArray.count>4) {
                chuanFaKey = 4;
            }else{
                chuanFaKey = (int)_transation.selectMatchArray.count;
            }
        }else if ([_transation.curProfile.Desc isEqualToString:@"BF"]){
            if (_transation.selectMatchArray.count>4) {
                chuanFaKey = 4;
            }else{
                chuanFaKey = (int)_transation.selectMatchArray.count;
            }
        }else if ([_transation.curProfile.Desc isEqualToString:@"JQS"]){
            if (_transation.selectMatchArray.count>6) {
                chuanFaKey = 6;
            }else{
                chuanFaKey = (int)_transation.selectMatchArray.count;
            }
        }else if ([_transation.curProfile.Desc isEqualToString:@"HHGG"]){
            
            NSInteger bf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"BF"];
            NSInteger spf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"SPF"];
            NSInteger rqspf_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"RQSPF"];
            NSInteger bqc_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"BQC"];
            NSInteger jqs_cunt = [_transation hhggHasBetMatchNumWithPlayCode:@"JQS"];
            
            if (!jqs_cunt == 0 && bf_cunt == 0 && bqc_cunt == 0) {
                if (_transation.selectMatchArray.count > 6) {
                    chuanFaKey = 6;
                }
                else
                {
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
                
            }else if (!bf_cunt == 0) {
                if (_transation.selectMatchArray.count > 4) {
                    chuanFaKey = 4;
                }
                else
                {
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }else if (!bqc_cunt == 0){
                if (_transation.selectMatchArray.count >4) {
                    chuanFaKey = 4;
                }
                else
                {
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }else if (!spf_cunt ==0 || !rqspf_cunt == 0) {
                if (_transation.selectMatchArray.count >8) {
                    chuanFaKey = 8;
                }
                else
                {
                    chuanFaKey = (int)_transation.selectMatchArray.count;
                }
            }
        }
        else{
            chuanFaKey = (int)_transation.selectMatchArray.count;
        }
        if([_transation.curProfile.Desc isEqualToString:@"BF"])
        {
            for (int i=0; i<chuanFaKey; i++) {
                NSDictionary * info = array[i];
                [temp addObjectsFromArray:[info allKeys]];
            }
        }
        else
        {
            for (int i=1; i<chuanFaKey; i++) {
                NSDictionary * info = array[i];
                [temp addObjectsFromArray:[info allKeys]];
            }
        }
        
        NSArray * sortResult  = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * chuanFir = (NSString *)obj1;
            NSString * chuanSec = (NSString *)obj2;
            NSString * chuanFirNum = [chuanFir stringByReplacingOccurrencesOfString:@"串" withString:@""];
            NSString * chuanSecNum = [chuanSec stringByReplacingOccurrencesOfString:@"串" withString:@""];
            
            int firSubFir = [[chuanFirNum substringToIndex:1] intValue];
            int secSubFir = [[chuanSecNum substringToIndex:1] intValue];
            if (firSubFir > secSubFir) {
                return NSOrderedDescending;
            }else if (firSubFir == secSubFir){
                NSString *  firChuanSubNum = [chuanFir substringFromIndex:2];
                NSString *  secChuanSubNum = [chuanSec substringFromIndex:2];
                if ([firChuanSubNum intValue] > [secChuanSubNum intValue]) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            }else{
                return NSOrderedAscending;
            }
        }];
        [temp removeAllObjects];
        BOOL isDanGuan = YES;
        if(![_transation.curProfile.Desc isEqualToString:@"BF"]&& (_transation.playType == JCZQPlayTypeGuoGuan)){
            for (JCZQMatchModel *model in self.transation.selectMatchArray) {
                if (model.isDanGuan == NO) {
                    isDanGuan = NO;
                    break;
                }
            }
            
            if (isDanGuan == YES) {
                [temp addObject:@"单场"];
            }
        }
        
//        if(![_transation.curProfile.Desc isEqualToString:@"BF"]&& (_transation.playType == JCZQPlayTypeDanGuan))
//        {
//
//
//
//        }
//        //过关玩法若选中场次都支持单关，则玩法支持单关
//        if(![_transation.curProfile.Desc isEqualToString:@"BF"]&& _supportDanguan)
//        {
//            [temp addObject:@"单场"];
//        }
        
        [temp addObjectsFromArray:sortResult];
        self.dataSource = temp;
        
    }
    
    
    [self handleDataSource:supview];
    
    
}

- (IBAction)actionClose:(UIButton *)sender {
    [self removeFromSuperview];
}

-(void)showFromSuperViewJCLQ:(UIView *)supview{
    
    
    NSMutableArray*chuanArray = [NSMutableArray arrayWithCapacity:0];
    NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
    if (self.jclqtransation.guanType == JCLQGuanTypeDanGuan) {
        
        NSInteger numGame =self.jclqtransation.matchSelectArray.count>8?8:self.jclqtransation.matchSelectArray.count;
        
        for (int i = 0; i<numGame; i++) {
            if ([self.jclqtransation.playType isEqualToString:@"JCLQSFC"]) {
                
                if (i>=4) {
                    break;
                }else{
                    
                    NSDictionary *dic = array[i];
                    NSArray *temp = [dic allKeys];
                    [chuanArray addObjectsFromArray:temp];
                }
            }else{
                NSDictionary *dic = array[i];
                NSArray *temp = [dic allKeys];
                [chuanArray addObjectsFromArray:temp];
            }
            
        }
        
        NSArray * sortResult  = [chuanArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * chuanFir = (NSString *)obj1;
            NSString * chuanSec = (NSString *)obj2;
            NSString * chuanFirNum = [chuanFir stringByReplacingOccurrencesOfString:@"串" withString:@""];
            NSString * chuanSecNum = [chuanSec stringByReplacingOccurrencesOfString:@"串" withString:@""];
            
            int firSubFir = [[chuanFirNum substringToIndex:1] intValue];
            int secSubFir = [[chuanSecNum substringToIndex:1] intValue];
            if (firSubFir > secSubFir) {
                return NSOrderedDescending;
            }else if (firSubFir == secSubFir){
                NSString *  firChuanSubNum = [chuanFir substringFromIndex:2];
                NSString *  secChuanSubNum = [chuanSec substringFromIndex:2];
                if ([firChuanSubNum intValue] > [secChuanSubNum intValue]) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            }else{
                return NSOrderedAscending;
            }
        }];
        
        NSString *lastType = [sortResult lastObject];
        
        self.dataSource = sortResult;
    }else{
        
        BOOL isDan = YES;
        
        NSInteger num = 0;
        for (JCLQMatchModel *model in self.jclqtransation.matchSelectArray) {
            for (NSString *state in model.SFCSelectMatch) {
                num += [state integerValue];
            }
        }
        
        NSInteger numGame =self.jclqtransation.matchSelectArray.count>8?8:self.jclqtransation.matchSelectArray.count;
        for (int i = 0; i< numGame; i++) {
            if ([self.jclqtransation.playType isEqualToString:@"JCLQSFC"]||num!=0) {
                
                if (i>=4) {
                    break;
                }else{
                    
                    NSDictionary *dic = array[i];
                    NSArray *temp = [dic allKeys];
                    [chuanArray addObjectsFromArray:temp];
                }
            }else{
                NSDictionary *dic = array[i];
                NSArray *temp = [dic allKeys];
                [chuanArray addObjectsFromArray:temp];
            }
            
        }
        
        for (JCLQMatchModel *selectModel in self.jclqtransation.matchSelectArray) {
            if (selectModel.isDanGuan == YES) {
                isDan = YES;
            }else{
                
                isDan = NO;
                break;
            }
        }
        
        if (!isDan) {
            [chuanArray removeObjectAtIndex:0];
        }
        
        
        
        NSArray * sortResult  = [chuanArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * chuanFir = (NSString *)obj1;
            NSString * chuanSec = (NSString *)obj2;
            NSString * chuanFirNum = [chuanFir stringByReplacingOccurrencesOfString:@"串" withString:@""];
            NSString * chuanSecNum = [chuanSec stringByReplacingOccurrencesOfString:@"串" withString:@""];
            
            int firSubFir = [[chuanFirNum substringToIndex:1] intValue];
            int secSubFir = [[chuanSecNum substringToIndex:1] intValue];
            if (firSubFir > secSubFir) {
                return NSOrderedDescending;
            }else if (firSubFir == secSubFir){
                NSString *  firChuanSubNum = [chuanFir substringFromIndex:2];
                NSString *  secChuanSubNum = [chuanSec substringFromIndex:2];
                if ([firChuanSubNum intValue] > [secChuanSubNum intValue]) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            }else{
                return NSOrderedAscending;
            }
        }];
        self.dataSource = sortResult;
    }
    [self handleDataSource:supview];
}


@end
