//
//  LotteryProfileSelectView.m
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "X115LotteryProfileSelectView.h"

#define CellViewHeight  80
#define CellViewWidth   100
#define CellViewCountPerRow   3
@implementation X115LotteryProfileSelectView
@dynamic delegate;

- (void) initUIWithLottery: (Lottery *) lottery resource:(NSString *)vcResourceName{
    if (nil == scrollViewContent_) {
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        UIButton *hideMeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        hideMeButton.frame = self.bounds;
        [hideMeButton addTarget: self action: @selector(hideMeButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: hideMeButton];
        
        //draw content view
        CGRect scrollViewContentFrame = self.bounds;
        scrollViewContentFrame.origin.y = NaviHeight;
        scrollViewContentFrame.size.height -= 84;
        scrollViewContent_ = [[UIScrollView alloc] initWithFrame: scrollViewContentFrame];
        scrollViewContent_.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);;
        [self addSubview: scrollViewContent_];
        
        curLottery = lottery;
      

        int countPerRow = 1;
        
        if ([lottery.identifier isEqualToString:@"SX115"] || [lottery.identifier isEqualToString:@"SD115"]) {
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
        
        CGFloat cellViewHeight = cellViewWidth / 1.4;

        
        __block CGSize contentSize = scrollViewContent_.frame.size;
        NSUInteger rowCount = curLottery.profiles.count/countPerRow;
        if (curLottery.profiles.count%countPerRow > 0) {
            rowCount++;
        }
       
        contentSize.height = rowCount*(cellViewHeight+cellPadding) + cellPadding;

        [curLottery.profiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LotteryXHProfile *profile = (LotteryXHProfile *) obj;
            LotteryProfileSelectCellView *cellView = [[LotteryProfileSelectCellView alloc] initWithFrame: CGRectMake(curX, curY, cellViewWidth, cellViewHeight)];
            cellView.delegate = self;
            NSLog(@"77980%@",profile.title);

            if ([profile.profileID isEqualToString: lottery.activeProfile.profileID]) {
                cellView.isSelectedProfile = YES;
                selectedCellView = cellView;
            }
            selectedCellView.typeString = self.typeString;
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
                
            }
            if(cellView.isSelectedProfile == YES){
                cellView.backgroundColor =SystemGreen;
            }else{
                cellView.backgroundColor = [UIColor clearColor];
            }
            cellView.layer.borderColor = [[UIColor whiteColor] CGColor];
            cellView.layer.borderWidth = 1;
            cellView.layer.cornerRadius = 4;
            cellView.layer.masksToBounds = YES;
            [scrollViewContent_ addSubview: cellView];
        }];

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
    line.backgroundColor = SystemGreen;
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

    for(LotteryProfileSelectCellView *cell in [[self.subviews lastObject] subviews]){
        
        if([cell isKindOfClass:[LotteryProfileSelectCellView class]]){
            cell.isSelectedProfile = NO;
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    selectedCellView.isSelectedProfile = YES;
        selectedCellView.backgroundColor = SystemGreen;

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
