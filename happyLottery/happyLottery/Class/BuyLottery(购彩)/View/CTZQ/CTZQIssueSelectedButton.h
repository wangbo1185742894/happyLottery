//
//  CTZQIssueSelectedButton.h
//  Lottery
//
//  Created by only on 16/3/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTZQIssueSelectedButton : UIButton
@property(nonatomic, strong)NSString *issueNumber;
@property(nonatomic, strong)NSString *time;

- (void)setTitleIssueStr:(NSString *)issueStr andTimeStr:(NSString *)timeStr;
@end
