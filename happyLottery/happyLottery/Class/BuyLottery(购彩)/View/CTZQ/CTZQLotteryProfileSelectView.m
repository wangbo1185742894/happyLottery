//
//  LotteryProfileSelectView.m
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "CTZQLotteryProfileSelectView.h"

#define CellViewHeight  80
#define CellViewWidth   100
#define CellViewCountPerRow   3
@implementation CTZQLotteryProfileSelectView
@dynamic delegate;

- (void) initUIWithLottery: (Lottery *) lottery resource:(NSString *)vcResourceName{
    if (nil == scrollViewContent_) {
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        UIButton *hideMeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        hideMeButton.frame = self.bounds;
        [hideMeButton addTarget: self action: @selector(hideMeButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: hideMeButton];
        
        //draw content view
        CGRect scrollViewContentFrame = self.bounds;
        scrollViewContentFrame.origin.y = 64;
        scrollViewContentFrame.size.height -= 84;
        scrollViewContent_ = [[UIScrollView alloc] initWithFrame: scrollViewContentFrame];
        scrollViewContent_.backgroundColor = RGBCOLOR(255, 254, 233);
        [self addSubview: scrollViewContent_];
        
        curLottery = lottery;
        int countPerRow = 1;
        
        if ([lottery.identifier isEqualToString:@"X115"]) {
            countPerRow = 4;
        }else if([lottery.identifier isEqualToString:@"JCZQ"]){
            countPerRow = 3;
        }else if([lottery.identifier isEqualToString:@"RJC"] || [lottery.identifier isEqualToString:@"SFC"]){
            countPerRow = 3;
        }else if ([lottery.identifier isEqualToString:@"JCLQ"]){
            countPerRow = 3;
        }else if ([lottery.identifier isEqualToString:@"PL3"]){
            countPerRow = 4;
        }
        CGFloat cellPadding = 8;
        CGFloat cellViewWidth = (self.bounds.size.width - cellPadding*(countPerRow+1)) / countPerRow;
        
        __block CGFloat curX = cellPadding;
        __block CGFloat curY = cellPadding;
        
        CGFloat cellViewHeight = 0;
        if ([lottery.identifier isEqualToString:@"X115"]) {
            cellViewHeight = cellViewWidth / 1.8;
        }else if([lottery.identifier isEqualToString:@"JCZQ"]){
            cellViewHeight = cellViewWidth / 3;
        }else if ([lottery.identifier isEqualToString:@"RJC"] || [lottery.identifier isEqualToString:@"SFC"]){
            cellViewHeight = cellViewWidth / 3;
            curX = KscreenWidth/2 - cellViewWidth - cellPadding/2;
        }else if ([lottery.identifier isEqualToString:@"JCLQ"] ){
            cellViewHeight = cellViewWidth / 3;
        }else if ([lottery.identifier isEqualToString:@"PL3"] ){
            cellViewHeight = cellViewWidth-25;
        }
        
        
        __block CGSize contentSize = scrollViewContent_.frame.size;
        NSUInteger rowCount = curLottery.profiles.count/countPerRow;
        if (curLottery.profiles.count%countPerRow > 0) {
            rowCount++;
        }
        contentSize.height = rowCount*(cellViewHeight+cellPadding) + cellPadding;
        
        if (([lottery.identifier isEqualToString:@"JCLQ"]||[lottery.identifier isEqualToString:@"JCZQ"])&&![vcResourceName isEqualToString:@"winHistory"]) {
            UIView *guoguanTitle = [self titleViewWith:@"过关"];
            guoguanTitle.mj_x = 0;
            guoguanTitle.mj_y = 0;
            [scrollViewContent_ addSubview:guoguanTitle];
            curY = CGRectGetMaxY(guoguanTitle.frame)+cellPadding/2;
        }
      

        [curLottery.profiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LotteryXHProfile *profile = (LotteryXHProfile *) obj;
            LotteryProfileSelectCellView *cellView = [[LotteryProfileSelectCellView alloc] initWithFrame: CGRectMake(curX, curY, cellViewWidth, cellViewHeight)];
            cellView.delegate = self;
            NSLog(@"77980%@",lottery.activeProfile.title);
            if (self.isP3P5) {
                if ([profile.profileID isEqualToString: lottery.activeProfile.profileID] &&[profile.title isEqualToString:self.typeString]) {
                    cellView.isSelectedProfile = YES;
                    selectedCellView = cellView;
                    selectedCellView.isSelectedProfile = YES;
                }
            }else{
                if ([profile.profileID isEqualToString: lottery.activeProfile.profileID]) {
                    cellView.isSelectedProfile = YES;
                    selectedCellView = cellView;
                }
            }
            selectedCellView.isP3P5 = self.isP3P5;
            selectedCellView.typeString = self.typeString;
            cellView.isP3P5 = self.isP3P5;
            cellView.typeString = self.typeString;
            [cellView initWithLotteryProfile: profile resource:vcResourceName andguoGuanType:1];
            
            if (idx > 1 && (idx+1)%countPerRow == 0) {
                curX = cellPadding;
                curY = CGRectGetMaxY(cellView.frame) + cellPadding;
            } else {
                curX = CGRectGetMaxX(cellView.frame) + cellPadding;
                
                if([vcResourceName isEqualToString:@"winHistory"])
                {
                    if(idx == 4)
                    {
                        curX -= cellViewWidth;
                        curX -= cellPadding;
                    }
                }
                //profileDic
                if ([lottery.identifier isEqualToString:@"X115"]) {
                   
                }else{
                
//                if(myDelegate.jzGuanKaType == JingCaiGuanKaTypeDanGuan)
//                {
//                    
//
//                    if(idx == 4)
//                    {
//                                            curY = cellPadding;
//                    curX = cellPadding*3 + cellViewWidth*2;
//                    }
//                    
//                }
                }
            }
            [scrollViewContent_ addSubview: cellView];
        }];
        NSLog(@"curY:%f",curY);
        
        if(![vcResourceName isEqualToString:@"winHistory"]){
            if ([lottery.identifier isEqualToString:@"JCLQ"]||[lottery.identifier isEqualToString:@"JCZQ"]) {
                rowCount*=2;
                
                
                UIView *guoguanTitle = [self titleViewWith:@"单关"];
                guoguanTitle.mj_x = 0;
                guoguanTitle.mj_y = curY;
                [scrollViewContent_ addSubview:guoguanTitle];
                curY = CGRectGetMaxY(guoguanTitle.frame)+cellPadding/2;
                
                [curLottery.profiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    LotteryXHProfile *profile = (LotteryXHProfile *) obj;
                    LotteryProfileSelectCellView *cellView = [[LotteryProfileSelectCellView alloc] initWithFrame: CGRectMake(curX, curY, cellViewWidth, cellViewHeight)];
                    cellView.delegate = self;
                    
                    //                if ([profile.profileID isEqualToString: lottery.activeProfile.profileID]) {
                    //                    cellView.isSelectedProfile = YES;
                    //                    selectedCellView = cellView;
                    //                }
                    [cellView initWithLotteryProfile: profile resource:vcResourceName andguoGuanType:0];
                    
                    if (idx > 1 && (idx+1)%countPerRow == 0) {
                        curX = cellPadding;
                        curY = CGRectGetMaxY(cellView.frame) + cellPadding;
                    } else {
                        curX = CGRectGetMaxX(cellView.frame) + cellPadding;
                        
                        if([vcResourceName isEqualToString:@"winHistory"])
                        {
                            if(idx == 4)
                            {
                                curX -= cellViewWidth;
                                curX -= cellPadding;
                            }
                        }
                        //profileDic
                        if ([lottery.identifier isEqualToString:@"X115"]) {
            
                        }else{
                            
                        }
                    }
                    [scrollViewContent_ addSubview: cellView];
                }];
                
                
               
            }

            
            
        }
        
//        contentSize.height = rowCount*(cellViewHeight+cellPadding) + cellPadding;
//        竞彩足球和竞彩篮球 的高度是双倍的。需要重新设定
        if ([lottery.identifier isEqualToString:@"JCLQ"]||[lottery.identifier isEqualToString:@"JCZQ"]) {
            contentSize.height = curY;
        }
        
       

        
        
        //update content view frame
        if (scrollViewContent_.frame.size.height > contentSize.height) {
            CGRect newFrame = scrollViewContent_.frame;
            newFrame.size = contentSize;
            scrollViewContent_.frame = newFrame;
        } else {
            scrollViewContent_.contentSize = contentSize;
        }
    }
}



- (void) hideMeButtonAction: (UIButton *) button {
    if ([self.delegate respondsToSelector: @selector(userCancelLottertProfileSelection)]) {
        [self.delegate userCancelLottertProfileSelection];
    }
    [self hideMe];
}

- (void) hideMe {
    self.meShown = NO;
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         //do something
                         [self.superview sendSubviewToBack: self];
                     }];
}
- (UIView *)titleViewWith:(NSString *)title{
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = [UIColor clearColor];
    back.mj_w = self.mj_w;
    back.mj_h = 30;
    
    
    UILabel *line = [[UILabel alloc] init];

    line.mj_w = self.mj_w - 2 * 10;
    line.mj_h = SEPHEIGHT;
    line.center = back.center;
    [back addSubview:line];
    
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    titleLa.text = title;
    titleLa.textColor = TEXTGRAYCOLOR;
    titleLa.center = back.center;
    titleLa.font = [UIFont systemFontOfSize:15];
    titleLa.textAlignment = NSTextAlignmentCenter;
    [back addSubview:titleLa];
    titleLa.backgroundColor = RGBCOLOR(255, 254, 233);
    
   
    
    return back;
}
- (void) showMe {
    self.alpha = 0;
    self.meShown = YES;
    [self.superview bringSubviewToFront: self];
    [UIView animateWithDuration: 0.3
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         //do something
                     }];
}
#pragma LotteryProfileSelectCellViewDelegate
- (void) cellView: (LotteryProfileSelectCellView*) view didSelectLotteryProfile: (LotteryXHProfile *) profile andGuoguanType:(CGFloat)guoGuanType{
    if (selectedCellView != nil) {
        [selectedCellView toggleSelect: NO];
        [selectedCellView buttonSelect: NO curtitle:curLottery.activeProfile.title];
    }
    selectedCellView = view;
    selectedCellView.isP3P5 = self.isP3P5;
    if (curLottery.activeProfileForExtrend) {
        curLottery.activeProfileForExtrend = profile;
    }else{
        curLottery.activeProfile = profile;
    }
 
     AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    if ([self.delegate respondsToSelector: @selector(userDidSelectLotteryProfile)]) {
        [self.delegate userDidSelectLotteryProfile];
        [self hideMe];
    }
}

@end
