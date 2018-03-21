//
//  LotteryBetsPopView.m
//  Lottery
//
//  Created by AMP on 5/28/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryBetsPopView.h"
#import "LotteryBet.h"
#import "ZLAlertView.h"


@interface LotteryBetsPopView() {
    
    //view content
    __weak IBOutlet UIView *viewContent_;
    //view content constraint
    __weak IBOutlet NSLayoutConstraint *viewContentHeightConstraint;
    
    //view top
    __weak IBOutlet UIView *viewTop_;
    __weak IBOutlet UILabel *labelTitle_;
    __weak IBOutlet UIButton *buttonClean_;
    //view bottom
    __weak IBOutlet UIView *viewBottom_;
    __weak IBOutlet UILabel *labelSummary_;
    __weak IBOutlet UIButton *buttonKeepBet_;
    __weak IBOutlet UIButton *buttonFinishBet_;
    
    //middle view
    __weak IBOutlet UIActivityIndicatorView *spinnerLoading_;
    __weak IBOutlet UIImageView *shoppingCartBG;
    __weak IBOutlet UIView *viewBetListContent;
    
    __weak IBOutlet UITableView *tableViewBetList;
    
    
    LotteryTransaction *lotteryTransaction;
    NSArray *betsList;
    
    CGFloat viewContentResetHeight;
    
    __block CGFloat betListCellHeightSum;
    CGFloat betListMaxHeight;
    UINib *cellNib;
    
    BOOL needScrol;
}
@end

#define ViewContentSidePadding 20


@implementation LotteryBetsPopView
@dynamic delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib {
    [super awakeFromNib];
    tableViewBetList.delegate = self;
    tableViewBetList.dataSource = self;
    self.meShown = NO;
}

- (void) initUI {
    labelTitle_.text = TextBetListTitle;
    [buttonClean_ setTitle: TextBetListCleanButtonTitle forState: UIControlStateNormal];
    [buttonKeepBet_ setTitle: TextBetListKeepBetButtonTitle forState:UIControlStateNormal];
    [buttonFinishBet_ setTitle: TextBetListFinishBetButtonTitle forState:UIControlStateNormal];
    
    viewContentResetHeight = viewContent_.frame.size.height;
    shoppingCartBG.image = [[UIImage imageNamed: @"shoppingCartBG.png"] stretchableImageWithLeftCapWidth: 30 topCapHeight: 14];
    
    //calculate betListMaxHeight
    betListMaxHeight = self.frame.size.height - viewContentResetHeight - ViewContentSidePadding*2;
    UIButton *actionButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [actionButton addTarget: self action: @selector(hideMe) forControlEvents: UIControlEventTouchUpInside];
    actionButton.frame = self.bounds;
    [self addSubview: actionButton];
    [self sendSubviewToBack: actionButton];
}

- (void) refreshBetListView: (LotteryTransaction *) transaction {
    lotteryTransaction = transaction;
    betsList = [transaction allBets];
    if (!self.meShown) {
        [spinnerLoading_ startAnimating];
    }
    
    labelSummary_.hidden = YES;
    tableViewBetList.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval: 0.01];
        //calculate the cell height
        betListCellHeightSum = -13;
        dispatch_async(dispatch_get_main_queue(), ^{
            [betsList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LotteryBet *bet = (LotteryBet*) obj;
                CGFloat popViewCellHeight = bet.popViewCellHeight;
                if (popViewCellHeight < 10) {
                    popViewCellHeight = [BetsListPopViewCell cellHeight: bet withFrame: tableViewBetList.bounds];
                    bet.popViewCellHeight = popViewCellHeight;
                }
                betListCellHeightSum += bet.popViewCellHeight;
                
                if (betListCellHeightSum > betListMaxHeight) {
                    betListCellHeightSum = betListMaxHeight;
                    tableViewBetList.scrollEnabled = YES;
                    *stop = YES;
                } else {
                    tableViewBetList.scrollEnabled = NO;
                }
            }];
            if ([lotteryTransaction betCount] > 0) {
                [self showBetListTableView];
            }
            //            zwl 16-01-13
            else
            {
                AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                myDelegate.betlistcount = 0;
                [self hideMe];
            }
        });
    });
//    tableViewBetList.hidden = YES;
    [self updateSummaryInfo];
    labelTitle_.hidden = NO;
}

- (void) updateSummaryInfo {
    labelSummary_.attributedText = [lotteryTransaction getAttributedSummaryText];
    labelSummary_.hidden = NO;
}

- (void) hideMe {
    if (!self.meShown) {
        return;
    }
    self.meShown = NO;
    viewContentHeightConstraint.constant = viewContentResetHeight;
    [UIView animateWithDuration: 0.3
                     animations:^{
                         [viewContent_ layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         labelSummary_.hidden = YES;
                         tableViewBetList.hidden = YES;
                         viewContent_.transform = CGAffineTransformIdentity;
                         [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                             viewContent_.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         } completion:^(BOOL finished){
                             [self.superview sendSubviewToBack: self];
                         }];
                     }];
    [self.delegate betListPopViewHide];
}

- (IBAction)actionClean:(id)sender {
//    UIAlertView *cleanAlertView = [[UIAlertView alloc] initWithTitle: TextRemoveAllBets
//                                                             message: nil
//                                                            delegate: self
//                                                   cancelButtonTitle: TextDimiss
//                                                   otherButtonTitles: TextDelete, nil];
//    [cleanAlertView show];
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:TextRemoveAllBets];
    [alert addBtnTitle:TextDimiss action:^{
        
    }];
    [alert addBtnTitle:TextDelete action:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //do a delay
            [NSThread sleepForTimeInterval: 0.03];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeBetsAction: @[]];
            });
        });
    }];
    
    [alert showAlertWithSender:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (IBAction)actionFinishBet:(id)sender {
    [self.delegate touzhuSureAction];
}

- (IBAction)actionKeepBet:(id)sender {
    [self hideMe];
}

- (LotteryBet *) betForRow: (NSUInteger) rowIndex {
    if (rowIndex < [betsList count]) {
        return betsList[rowIndex];
    }
    return nil;
}

- (void) showBetListTableViewAction {
    if (betListCellHeightSum < 0) {
        betListCellHeightSum = 0;
    }
    viewContentHeightConstraint.constant = viewContentResetHeight + betListCellHeightSum;
    [UIView animateWithDuration: 0.3
                     animations:^{
                         [viewContent_ layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [tableViewBetList reloadData];
                         
                         self.meShown = YES;
                     }];
    labelSummary_.hidden = NO;
    tableViewBetList.hidden = NO;
}
- (void) showBetListTableView {
    if (self.meShown) {
        [self showBetListTableViewAction];
    } else {
        [spinnerLoading_ stopAnimating];
        viewContent_.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewContent_.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            [self showBetListTableViewAction];
        }];
    }
}

#pragma UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lotteryTransaction betCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BetsListPopViewCell *cell = (BetsListPopViewCell*)[tableView dequeueReusableCellWithIdentifier: @"betcell"];
    if (cell == nil) {
        cell = [[BetsListPopViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"betcell"];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    
    LotteryBet *bet = [self betForRow: indexPath.row];
    [cell updateWithBet: bet];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LotteryBet *bet = [self betForRow: indexPath.row];
    CGFloat popViewCellHeight = bet.popViewCellHeight;
    if (popViewCellHeight < 10) {
        popViewCellHeight = [BetsListPopViewCell cellHeight: bet withFrame: tableView.bounds];
        bet.popViewCellHeight = popViewCellHeight;
    }
    return popViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (void) removeBetsAction: (NSArray*)indexPaths {
    if (indexPaths.count > 0) {
        for (NSIndexPath *indexPath in indexPaths) {
            LotteryBet *bet = [self betForRow: indexPath.row];
            [lotteryTransaction removeBet: bet];
        }
        [tableViewBetList deleteRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self refreshBetListView: lotteryTransaction];
    } else {
        //remove all
        [lotteryTransaction removeAllBets];
        //ZWL 16-01-15
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        myDelegate.betlistcount = 0;

    }
    
    [self.delegate betTransactionUpdated];
    [self.delegate hideLoadingView];
    
    if ([lotteryTransaction betCount] == 0) {
        [self hideMe];
    }
}

#pragma BetsListPopViewCellDelegate
- (void) removeBetAction: (NSIndexPath *) indexPath {
    if (indexPath.row < [lotteryTransaction betCount]) {
        [self.delegate showBlockLoadingViewWithText: TextLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //do a delay
            [NSThread sleepForTimeInterval: 0.03];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeBetsAction: @[indexPath]];
            });
        });
    }
}

#pragma UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.delegate showBlockLoadingViewWithText: TextLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //do a delay
            [NSThread sleepForTimeInterval: 0.03];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeBetsAction: @[]];
            });
        });
    }
}
@end
