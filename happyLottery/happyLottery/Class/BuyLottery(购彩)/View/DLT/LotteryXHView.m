//
//  LotteryXuanHaoView.m
//  Lottery
//
//  Created by AMP on 5/21/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryXHView.h"
#import "LotteryManager.h"
#import "LotteryXHSection.h"
#import "LotteryNumber.h"
#import "XHSectionTitleView.h"


@interface LotteryXHView() {
    LotteryManager *lotteryMan;
    Lottery *lottery;
    UIView *viewXuanHaoSection;
    NSArray *xhNumberViews;
    NSDictionary *xhViewDic;
    
    NSArray * randomViewArray;
}

@end

#define SectionLabelWidth 49
#define SectionLabelLeftPadding 15
#define SectionLabelRightPadding 6
#define SectionLabelTopPadding 7
#define SectionLabelHeight 21
#define SectionNumberPadding 10
#define NumberCellWidth 40
#define NumberCellPadding 7
#define NumberCellRowPadding 5
@implementation LotteryXHView
@dynamic delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) drawWithLottery: (Lottery *) lotteryToShow {
    _isEableSelect = YES;
    self.randomStatus = RandomBetStatusShow;
    lottery = lotteryToShow;
    if (nil == lottery.activeProfile || lottery.activeProfile.details.count == 0) {
        //TODO: no config, show error page
    } else {
        self.lotteryBet.lotteryDetails = lottery.activeProfile.details;
        [self drawXuanHaoSection];
    }
}

#define RandomNumberButtonWidth 103
- (void) drawXuanHaoSection {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationSelectAllNumbers" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAll) name:@"NSNotificationSelectAllNumbers" object:nil];
    CGFloat curY = 0;
    NSMutableArray *xhNumberViewsTMP = [NSMutableArray array];
    NSMutableDictionary *xhViewDicTMP = [NSMutableDictionary dictionary];
    NSMutableArray *randomArrayTemp = [NSMutableArray array];
    for (LotteryXHSection *lotteryXH in lottery.activeProfile.details) {
        CGFloat curX = LEFTPADDING;
        lotteryXH.numbersDanHao = [NSMutableArray array];
        lotteryXH.numbersSelected = [NSMutableArray array];
        //add separate line
        UILabel *labelSeprateLine = [[UILabel alloc] initWithFrame: CGRectMake(0, curY, self.frame.size.width, SEPHEIGHT)];
        labelSeprateLine.backgroundColor = SEPCOLOR;
        [self addSubview: labelSeprateLine];   
        curY = CGRectGetMaxY(labelSeprateLine.frame) + NumberCellRowPadding*3;
        CGFloat sectionWidth = self.frame.size.width;
        CGFloat sectionDrawingWidth = self.frame.size.width - SectionLabelLeftPadding*2;
        if ([lotteryXH.needLabel boolValue]) {
            //add title lable
            CGFloat sectionTitleViewWidth = sectionDrawingWidth;
            if ([lottery.needSectionRandom boolValue]) {
                if ([lottery.identifier isEqualToString:@"X115"]) {
                    if ([lotteryXH.sectionID intValue] ==1) {
                        //need add random button on the right of this line
                        sectionTitleViewWidth -= (SectionLabelRightPadding+RandomNumberButtonWidth);
                        // 修改机选按钮的 x 坐标  右移 15
                        XHSectionRandomView *randomView = [[XHSectionRandomView alloc] initWithFrame: CGRectMake(sectionTitleViewWidth+15, curY, RandomNumberButtonWidth, SectionLabelHeight)];
                        randomView.lotteryIdenty = lottery.identifier;
                        [randomView initUIWithLotteryXH: lotteryXH curlottery:lottery];
                        randomView.delegate = self;
                        randomView.numberSelectView = self.numberSelectView;
                        [self addSubview: randomView];
                    }
                }else{
                    //need add random button on the right of this line
                    //大乐透篮球区 不用显示机选按钮
                    if ([lotteryXH.sectionID intValue] ==1) {
                        
                        sectionTitleViewWidth -= (SectionLabelRightPadding+RandomNumberButtonWidth);
                        XHSectionRandomView *randomView = [[XHSectionRandomView alloc] initWithFrame: CGRectMake(KscreenWidth - 150, curY, RandomNumberButtonWidth+80, SectionLabelHeight)];
                        randomView.lotteryIdenty = lottery.identifier;
                        [randomView initUIWithLotteryXH: lotteryXH curlottery:lottery];
                        randomView.delegate = self;
                        randomView.numberSelectView = self.numberSelectView;
                        [self addSubview: randomView];
                        [randomArrayTemp addObject:randomView];
                    
                    }
                }
            }
            CGRect sectionTitleViewFrame = CGRectMake(curX, curY, sectionTitleViewWidth, SectionLabelHeight);
            XHSectionTitleView *titleView = [[XHSectionTitleView alloc] initWithFrame: sectionTitleViewFrame];
            [self addSubview: titleView];
            [titleView initWithLotteryXH: lotteryXH];
            lotteryXH.titleView = titleView;
            
            curY = CGRectGetMaxY(titleView.frame) + NumberCellRowPadding;
        }
        randomViewArray = randomArrayTemp;
        //calcualte the start x for number area
        CGFloat cellWidth = NumberCellWidth + NumberCellPadding;
        
        //lc  修改小球开始的y坐标 多加 5
        curY += 5;
        curX += (sectionDrawingWidth - (floorf(sectionDrawingWidth/cellWidth) * cellWidth) + NumberCellPadding)/2;
        
        CGFloat initXValue = curX;
        int startIndexNum = [lotteryXH.startIndex intValue];
        int numCount = [lotteryXH.numberCount intValue];
        for (int lotteryNum=0; lotteryNum<numCount; lotteryNum++) {
            if ((curX + NumberCellWidth + NumberCellPadding) > sectionWidth) {
                //need new line
                curY += NumberCellWidth + NumberCellPadding;
                curX = initXValue;
            }
            int ballNumber = startIndexNum+lotteryNum;
            LotteryNumber *numberObj = [[LotteryNumber alloc] init];
            numberObj.number = @(ballNumber);
            if ([lotteryXH.forceTwoNumber boolValue] && ballNumber < 10) {
                numberObj.numberDesc = [NSString stringWithFormat: @"0%d", ballNumber];
//            } else {
//                numberObj.numberDesc = [NSString stringWithFormat: @"%d", ballNumber];
//            }
            }
            //格式化x115数字格式1，2，3………更改为01，02，03  
            else if(ballNumber< 10){
                numberObj.numberDesc = [NSString stringWithFormat: @"0%d", ballNumber];
            }
            else {
                numberObj.numberDesc = [NSString stringWithFormat: @"%d", ballNumber];
            }
            
            
            numberObj.numberColor = lotteryXH.normalColor;
            
            XHNumberView *xhCellView = [[XHNumberView alloc] initWithFrame: CGRectMake(curX, curY, NumberCellWidth, NumberCellWidth)];
            xhCellView.lotteryXH = lotteryXH;
            xhCellView.delegate = self;
            xhCellView.numberState = NumberViewStateNormal;
            xhCellView.numberObj = numberObj;
            [xhCellView drawNumber];
            [self addSubview: xhCellView];
            numberObj.xHNumberView = xhCellView;
            [xhNumberViewsTMP addObject: xhCellView];
            //section: lotteryXHSection id, row: lottery number
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: ballNumber
                                                        inSection: [lotteryXH.sectionID intValue]];
            xhViewDicTMP[indexPath] = xhCellView;
            curX = CGRectGetMaxX(xhCellView.frame) + NumberCellPadding;
        }
        curY += NumberCellRowPadding * 3;
        curY += NumberCellWidth;
    }
    
    xhNumberViews = xhNumberViewsTMP;
    xhViewDic = xhViewDicTMP;
    curY += NumberCellRowPadding;
    CGRect newFrame = self.frame;
    newFrame.size.height = curY;
    self.frame = newFrame;
}

- (NSArray *) selectedNumbers {
    return nil;
}

- (void) clearAllSelection {
    for (LotteryXHSection *lotteryXH in lottery.activeProfile.details) {
        [lotteryXH.numbersDanHao removeAllObjects];
        [lotteryXH.numbersSelected removeAllObjects];
        [lotteryXH updateSelectedNumberDesc];
    }
    [xhNumberViews makeObjectsPerformSelector: @selector(reset)];
}

- (void) clearSelectionForSection: (LotteryXHSection*) lotteryXH {
   
    for (XHNumberView *numberView in xhNumberViews) {
        if ([lotteryXH.numbersDanHao containsObject: numberView.numberObj]
            || [lotteryXH.numbersSelected containsObject: numberView.numberObj]) {
            [numberView reset];
        }
    }
    [lotteryXH.numbersDanHao removeAllObjects];
    [lotteryXH.numbersSelected removeAllObjects];
}


#pragma XuanHaoNumberViewDelegae methods
- (void) numberView: (XHNumberView*) numberView lotteryXuanHao: (LotteryXHSection*) lotteryXH numberStateUpdate: (NumberViewState) state{
    
    if (numberView.numberObj == nil) {
        return;
    }
    if (NumberViewStateNormal == state) {
        [lotteryXH.numbersSelected removeObject: numberView.numberObj];
        [lotteryXH.numbersDanHao removeObject: numberView.numberObj];
    } else if (NumberViewStateSelected == state) {
        [lotteryXH.numbersSelected addObject: numberView.numberObj];
    } else if (NumberViewStateDanHao == state) {
        [lotteryXH.numbersSelected removeObject: numberView.numberObj];
        [lotteryXH.numbersDanHao addObject: numberView.numberObj];
    }
    [lotteryXH updateSelectedNumberDesc];
    [self.lotteryBet updateBetInfo];
    
    [self.delegate betInfoUpdated];
}


/*
 1. 如果选号已经达到数量最大数，不可以再选；
 2. 如果选号最大数，但是胆号还未到最大数，单击直接变胆号；
 3. 如果选号最大数，单击胆号直接变正常状态；
 4. 如果胆号最大数，选号未到最大数，只在正常和选号中切换；
 5. 如果选号胆号都到最大数，不能选择
 */

- (NumberViewState) numberView: (XHNumberView*) numberView lotteryXuanHao: (LotteryXHSection*) lotteryXH nextViewState: (NumberViewState) maxState {
    // 选号
    
    NumberViewState newState = numberView.numberState + 1;
    BOOL needMaxErrorPrompt = NO;
    if (newState > maxState) {
        newState = NumberViewStateNormal;
    }else {
        BOOL moreNumber = [lotteryXH couldHaveMoreNumber];
        BOOL moreDanHao = [lotteryXH couldHaveMoreDanHao];
        if (newState == NumberViewStateSelected) {
            if (!moreNumber) {
                if (moreDanHao) {
                    newState = NumberViewStateDanHao;
                        [lotteryXH.numbersDanHao addObject:numberView.numberObj];
                        lotteryXH.numberObjTemp = numberView.numberObj;
                } else {
                    
                    if ([lottery.activeProfile.profileID integerValue] == 21 || [lottery.activeProfile.profileID integerValue] == 22) {
                        BOOL isCanSelect = YES;
                        if (![lottery.activeProfile.couldRepeatSelect boolValue]){
                            //  区域间不可重复选择
                            for (LotteryXHSection *lotteryXH_ in lottery.activeProfile.details) {
                                if ([lotteryXH_.sectionID intValue] != [lotteryXH.sectionID intValue]) {
                                    
                                    for (LotteryNumber * number in lotteryXH_.numbersSelected){
                                        if (number.numberValue == numberView.numberObj.numberValue) {
                                            isCanSelect = NO;
                                            [self.delegate showPromptViewWithText: @"各位之间不能选择相同号码" hideAfter: 1];
                                            newState = NumberViewStateNormal;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        if (isCanSelect) {
                            for (LotteryNumber * number in lotteryXH.numbersSelected){
                                number.xHNumberView.numberState = NumberViewStateNormal;
                                [number.xHNumberView updateButtonForCurrentState];
                            }
                            [lotteryXH.numbersSelected removeAllObjects];
                            [lotteryXH.numbersSelected addObject:numberView.numberObj];
                            numberView.numberState = NumberViewStateSelected;
                            [numberView updateButtonForCurrentState];
                            
                            [lotteryXH updateSelectedNumberDesc];
                            needMaxErrorPrompt = NO;
                        }
                       
                    }else
                    {
                        newState = NumberViewStateNormal;
                        if (numberView.numberState == NumberViewStateNormal) {
                            needMaxErrorPrompt = YES;
                        }
                    }
                }
            }else{
                if ([lottery.activeProfile.profileID integerValue] == 21 || [lottery.activeProfile.profileID integerValue] == 22) {
                    BOOL isCanSelect = YES;
                    if (![lottery.activeProfile.couldRepeatSelect boolValue]){
                        //  区域间不可重复选择
                        for (LotteryXHSection *lotteryXH_ in lottery.activeProfile.details) {
                            if ([lotteryXH_.sectionID intValue] != [lotteryXH.sectionID intValue]) {
                                
                                for (LotteryNumber * number in lotteryXH_.numbersSelected){
                                    if (number.numberValue == numberView.numberObj.numberValue) {
                                        isCanSelect = NO;
                                        [self.delegate showPromptViewWithText: @"各位之间不能选择相同号码" hideAfter: 1];
                                        newState = NumberViewStateNormal;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (isCanSelect) {
                        for (LotteryNumber * number in lotteryXH.numbersSelected){
                            number.xHNumberView.numberState = NumberViewStateNormal;
                            [number.xHNumberView updateButtonForCurrentState];
                        }
                        [lotteryXH.numbersSelected removeAllObjects];
                        [lotteryXH.numbersSelected addObject:numberView.numberObj];
                        numberView.numberState = NumberViewStateSelected;
                        [numberView updateButtonForCurrentState];
                        
                        [lotteryXH updateSelectedNumberDesc];
                        needMaxErrorPrompt = NO;
                    }
                    
                }else{
                    [lotteryXH.numbersSelected addObject:numberView.numberObj];
                    lotteryXH.numberObjTemp = numberView.numberObj;
                }
                
      
            }
        } else if (newState == NumberViewStateDanHao) {
            if (!moreDanHao) {
                newState = NumberViewStateNormal;
                if (numberView.numberState == NumberViewStateNormal) {
                    needMaxErrorPrompt = YES;
                }
            }else{
                [lotteryXH.numbersDanHao addObject:numberView.numberObj];
                lotteryXH.numberObjTemp = numberView.numberObj;
            }
        }
    }
    
    [self.lotteryBet updateBetInfo];
    //  是否超额
    BOOL isExceed = [self.delegate isExceedAmountLimit];

    if (isExceed) {
        [self.delegate showPromptViewWithText: TextTouzhuExceedLimit hideAfter: 1];
        newState = NumberViewStateNormal;
    }
    if ([lotteryXH.numbersDanHao containsObject:numberView.numberObj]) {
        [lotteryXH.numbersDanHao removeObject:numberView.numberObj];
        [lotteryXH.numbersSelected addObject:numberView.numberObj];
    }else{
        if ([lotteryXH.numbersSelected containsObject:numberView.numberObj]) {
            [lotteryXH.numbersSelected removeObject:numberView.numberObj];
        }
    }
    [self.lotteryBet updateBetInfo];

    if ([lottery.activeProfile.profileID integerValue]<21) {
        if (![lottery.activeProfile.couldRepeatSelect boolValue]){
            //  区域间不可重复选择
            for (LotteryXHSection *lotteryXH_ in lottery.activeProfile.details) {
                if ([lotteryXH_.sectionID intValue] != [lotteryXH.sectionID intValue]) {
                    LotteryNumber * numberMustToRemove;
                    for (LotteryNumber * number in lotteryXH_.numbersSelected){
                        if (number.numberValue == numberView.numberObj.numberValue) {
                            number.xHNumberView.numberState = NumberViewStateNormal;
                            [number.xHNumberView updateButtonForCurrentState];
                            numberMustToRemove = number;
                            break;
                        }
                    }
                    if (numberMustToRemove) {
                        [lotteryXH_.numbersSelected removeObject:numberMustToRemove];
                        [lotteryXH_ updateSelectedNumberDesc];
                    }
                }
            }
        }
    }
  
    
    if (needMaxErrorPrompt) {
        [self.delegate showPromptViewWithText: TextErrorExceedLimitation hideAfter: 1];
    }
    // 判断是否超额
    [self.delegate isExceedAmountLimit];
    return newState;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

    [self clearAllSelection];
    if ( event.subtype == UIEventSubtypeMotionShake)
    {
        //vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self addRandomBet];
        if (self.randomStatus == RandomBetStatusAdd) {
            [self.delegate addedNewRandomBet];
        }
    }
    
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
}

- (void) addRandomBet {
    for (LotteryXHSection *lotteryXH in lottery.activeProfile.details) {

        if ([_lotteryBet.betLotteryIdentifier isEqualToString:@"DLT"]) {
//            XHSectionRandomView * view = (XHSectionRandomView *)randomViewArray[[lotteryXH.sectionID intValue]-1];
//            [self randomNumberAction: view.randomCount lotteryXHSection: lotteryXH];
            int randomcout;
            if([lotteryXH.sectionID isEqualToString:@"1"])
            {
                randomcout = 5;
            }
            else
            {
                randomcout = 2;
            }
            [self randomNumberAction:randomcout lotteryXHSection: lotteryXH];
        } else if ([_lotteryBet.betLotteryIdentifier isEqualToString:@"SSQ"]){
            int randomcout;
            if([lotteryXH.sectionID isEqualToString:@"1"])
            {
                randomcout = 6;
            }
            else
            {
                randomcout = 1;
            }
            [self randomNumberAction:randomcout lotteryXHSection: lotteryXH];
        }
        else{
            [self randomNumberAction: [lotteryXH.minNumCount intValue] lotteryXHSection: lotteryXH];
        }
    }
}

- (void) selectNumber: (int) lotteryNumVal lotteryXHSection: (LotteryXHSection *) lotteryXH isDanHao: (BOOL) danhao{
    //get section index
    NSIndexPath *viewIndexPath = [NSIndexPath indexPathForRow: lotteryNumVal inSection: [lotteryXH.sectionID intValue]];
    XHNumberView *xhView = xhViewDic[viewIndexPath];
    NumberViewState state = NumberViewStateSelected;
    if (danhao) {
        state = NumberViewStateDanHao;
    }
    [xhView setNumberState: state];
    //  选号
    [xhView updateButtonForCurrentState];
    [self numberView: xhView lotteryXuanHao: lotteryXH numberStateUpdate: state];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) randomNumberAction: (int) numberCount lotteryXHSection: (LotteryXHSection*) lotteryXH {
    if ([_lotteryBet.betLotteryIdentifier isEqualToString:@"DLT"]||[_lotteryBet.betLotteryIdentifier isEqualToString:@"SSQ"]) {
        NSArray *numbersArray = [lotteryXH generateRandomNumber: numberCount];
        
        // 判断是否超过金额限制
        
        NSMutableArray * numObjArray = [NSMutableArray arrayWithCapacity:numbersArray.count];
        for (NSNumber * num in numbersArray){
        
            NSIndexPath *viewIndexPath = [NSIndexPath indexPathForRow: [num intValue] inSection: [lotteryXH.sectionID intValue]];
            XHNumberView *xhView = xhViewDic[viewIndexPath];
            [numObjArray addObject:xhView.numberObj];
        }
        
        NSArray * originNumArray = [NSArray arrayWithArray:lotteryXH.numbersSelected];
        
        [lotteryXH.numbersSelected removeAllObjects];
        [lotteryXH.numbersSelected addObjectsFromArray:numObjArray];
        [self.lotteryBet updateBetInfo];
        //  是否超额
        BOOL isExceed = [self.delegate isExceedAmountLimit];

        [lotteryXH.numbersSelected removeObjectsInArray:numObjArray];
        [lotteryXH.numbersSelected addObjectsFromArray:originNumArray];
        [self.lotteryBet updateBetInfo];

        if (isExceed) {
            [self.delegate showPromptViewWithText: TextTouzhuExceedLimit hideAfter: 1];
            return;
        }
        // 合理金额
        [self clearSelectionForSection:lotteryXH];

        [lotteryXH.numbersDanHao removeAllObjects];
        [lotteryXH.numbersSelected removeAllObjects];
        
        for (NSNumber *number in  numbersArray) {
            [self selectNumber: [number intValue]
              lotteryXHSection: lotteryXH
                      isDanHao: NO];
        }
    }else if ([_lotteryBet.betLotteryIdentifier isEqualToString:@"X115"]){

        int randomNum = [lottery.activeProfile.randomTotalNum intValue];
        NSArray * lotteryXHSection = lottery.activeProfile.details;
        if (lotteryXHSection.count == 1) {
            LotteryXHSection *lotteryXH = lotteryXHSection[0];
            [self clearSelectionForSection:lotteryXH];
            NSArray *numbersArray = [lotteryXH generateRandomNumber: randomNum];
            for (NSNumber *number in  numbersArray) {
                [self selectNumber: [number intValue]
                  lotteryXHSection: lotteryXH
                          isDanHao: NO];

            }
        }else{
            int profileID = [lottery.activeProfile.profileID intValue];
            if (profileID > 12&& profileID != 22) {
                //  任选n胆拖系类
                LotteryXHSection *lotteryXH = lotteryXHSection[0];
                            [self clearSelectionForSection:lotteryXH];
                NSArray *numbersArray = [lotteryXH generateRandomNumber: 1];
                for (NSNumber *number in  numbersArray) {
                    [self selectNumber: [number intValue]
                      lotteryXHSection: lotteryXH
                              isDanHao: NO];
                }
                LotteryXHSection *lotteryXH_ = lotteryXHSection[1];
                [self clearSelectionForSection:lotteryXH_];
                
                NSArray *numbersArray_ = [lotteryXH generateRandomNumber:randomNum - 1 withOutRepeatArray:numbersArray];


                for (NSNumber *number in  numbersArray_) {
                    [self selectNumber: [number intValue]
                      lotteryXHSection: lotteryXH_
                              isDanHao: NO];
                }
            }else{
                NSMutableArray * numTemp = [NSMutableArray array];
                for (LotteryXHSection *lotteryXH in lottery.activeProfile.details) {
                    [self clearSelectionForSection:lotteryXH];
                    int minNum = [lotteryXH.minNumCount intValue];
                    
                    
                    NSArray *numbersArray_ = [lotteryXH generateRandomNumber:minNum withOutRepeatArray:numTemp];
                    [numTemp addObjectsFromArray:numbersArray_];
                 
                    
                    for (NSNumber *number in  numbersArray_) {
                        [self selectNumber: [number intValue]
                          lotteryXHSection: lotteryXH
                                  isDanHao: NO];
                }
            }
        }
        }
        [self.lotteryBet updateBetInfo];
    }
}

-(void)rebuyDLTnum:(NSArray *)seletArray{
    {
        NSDictionary *selecDic = [seletArray firstObject];
        
        LotteryXHSection *lotteryXHRed = [lottery.activeProfile.details firstObject];
          LotteryXHSection *lotteryXHBlue = [lottery.activeProfile.details lastObject];
        NSArray *redList = selecDic[@"redList"];
        NSArray *redDanList = selecDic[@"redDanList"];
        NSArray *blueList = selecDic[@"blueList"];
        NSArray *blueDanList = selecDic[@"blueDanList"];
        
        [self randomDlt:redList :lotteryXHRed andIsDan:NO];
        [self randomDlt:redDanList :lotteryXHRed andIsDan:YES];
        
        [self randomDlt:blueList :lotteryXHBlue andIsDan:NO];
        [self randomDlt:blueDanList :lotteryXHBlue andIsDan:YES];
        
      
   
       
        
        [self.lotteryBet updateBetInfo];
        //  是否超额
        BOOL isExceed = [self.delegate isExceedAmountLimit];
        
        if (isExceed) {
            [self.delegate showPromptViewWithText: TextTouzhuExceedLimit hideAfter: 1];
            return;
        }
    
    }
}

-(void)randomDlt:(NSArray *)selectArray :(LotteryXHSection*)lotteryXHSection andIsDan:(BOOL)isDan{
    NSMutableArray * numObjArray = [NSMutableArray arrayWithCapacity:0];
    for (NSNumber * num in selectArray){
        
        NSIndexPath *viewIndexPath = [NSIndexPath indexPathForRow: [num intValue] inSection: [lotteryXHSection.sectionID intValue]];
        XHNumberView *xhView = xhViewDic[viewIndexPath];
        [numObjArray addObject:xhView.numberObj];
    }
    NSArray * originNumArray;
    if (isDan) {
        originNumArray = [NSArray arrayWithArray:lotteryXHSection.numbersDanHao];
        [lotteryXHSection.numbersDanHao removeAllObjects];
        [lotteryXHSection.numbersDanHao addObjectsFromArray:numObjArray];
    }else{
        originNumArray = [NSArray arrayWithArray:lotteryXHSection.numbersSelected];
        [lotteryXHSection.numbersSelected removeAllObjects];
        [lotteryXHSection.numbersSelected addObjectsFromArray:numObjArray];
    }

    [self.lotteryBet updateBetInfo];
    //  是否超额
    BOOL isExceed = [self.delegate isExceedAmountLimit];
    
    if (isDan) {
        [lotteryXHSection.numbersDanHao removeObjectsInArray:numObjArray];
        [lotteryXHSection.numbersDanHao addObjectsFromArray:originNumArray];
    }else{
        [lotteryXHSection.numbersSelected removeObjectsInArray:numObjArray];
        [lotteryXHSection.numbersSelected addObjectsFromArray:originNumArray];
    }

    [self.lotteryBet updateBetInfo];
    
    if (isExceed) {
        [self.delegate showPromptViewWithText: TextTouzhuExceedLimit hideAfter: 1];
        return;
    }
    // 合理金额
   
    if (isDan) {
        [lotteryXHSection.numbersDanHao removeAllObjects];
    }else{
        
        [lotteryXHSection.numbersSelected removeAllObjects];
    }
   
    for (NSNumber *number in  selectArray) {
        [self selectNumber: [number intValue]
          lotteryXHSection: lotteryXHSection
                  isDanHao: isDan];
    }
    
}

-(void)rebuyShowNum:(NSArray *)selectArray{
    {
        
        
        NSArray * lotteryXHSection = lottery.activeProfile.details;
        if (lotteryXHSection.count == 1) {
            LotteryXHSection *lotteryXH = lotteryXHSection[0];
            [self clearSelectionForSection:lotteryXH];
            NSArray *numbersArray = [selectArray firstObject];
            for (NSNumber *number in  numbersArray) {
                [self selectNumber: [number intValue]
                  lotteryXHSection: lotteryXH
                          isDanHao: NO];
                
            }
        }else{
            int profileID = [lottery.activeProfile.profileID intValue];
            if (profileID > 12&& profileID != 22) {
                //  任选n胆拖系类
                LotteryXHSection *lotteryXH = lotteryXHSection[0];
                [self clearSelectionForSection:lotteryXH];
                NSArray *numbersArray =selectArray[0];
                for (NSNumber *number in  numbersArray) {
                    [self selectNumber: [number intValue]
                      lotteryXHSection: lotteryXH
                              isDanHao: NO];
                }
                LotteryXHSection *lotteryXH_ = lotteryXHSection[1];
                [self clearSelectionForSection:lotteryXH_];
                
                NSArray *numbersArray_ = selectArray[1];
                
                
                for (NSNumber *number in  numbersArray_) {
                    [self selectNumber: [number intValue]
                      lotteryXHSection: lotteryXH_
                              isDanHao: NO];
                }
            }else{
                NSMutableArray * numTemp = [NSMutableArray array];
                int i =0;
                for (LotteryXHSection *lotteryXH in lottery.activeProfile.details) {
                    [self clearSelectionForSection:lotteryXH];
                    
                    NSArray *numbersArray_ = selectArray[i];
                    [numTemp addObjectsFromArray:numbersArray_];
                    
                    
                    for (NSNumber *number in  numbersArray_) {
                        [self selectNumber: [number intValue]
                          lotteryXHSection: lotteryXH
                                  isDanHao: NO];
                    }
                    i++;
                }
            }
        }
        [self.lotteryBet updateBetInfo];
    }
}

-(void)selectAll{

   
    NSArray * lotteryXHSection = lottery.activeProfile.details;
    
    int profileID = [lottery.activeProfile.profileID intValue];
    if (profileID > 12) {
        //  任选n胆拖系类
        LotteryXHSection *lotteryXH_ = lotteryXHSection[1];
        LotteryXHSection *lotteryX = lotteryXHSection[0];
        
       [self clearSelectionForSection:lotteryXH_];
        if (lotteryX.numbersSelected.count == 0) {
            return;
        }
        
        
        NSArray *numbersArray_ = [self selectAllTuoArray:lotteryXHSection[0]];
        
        
        for (NSNumber *number in  numbersArray_) {
            [self selectNumber: [number intValue]
              lotteryXHSection: lotteryXH_
                      isDanHao: NO];
        }
    }
}

-(NSArray *)selectAllTuoArray:(LotteryXHSection *)lotteryXH{

    NSMutableArray *select = [NSMutableArray arrayWithCapacity:0];
    NSInteger flag = 0;
    for (int i = 1; i < 12; i++) {
        flag = 0;
        for (LotteryNumber *number in lotteryXH.numbersSelected) {
            if ([number.number integerValue] == i) {
                flag =1;
            }
        }
        if (flag == 0) {
            [select addObject:@(i)];
        }
        
    }
    

    return select;
}


#pragma XHSectionRandomViewDelegate methods
- (void) generateRandomNumber: (int) numberCount lotteryXHSection: (LotteryXHSection*) lotteryXH {

    [self randomNumberAction: numberCount lotteryXHSection: lotteryXH];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
