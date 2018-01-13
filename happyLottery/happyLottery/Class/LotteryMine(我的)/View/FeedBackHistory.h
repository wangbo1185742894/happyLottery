//
//  FeedBackHistory.h
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackHistory : NSObject

@property(nonatomic,strong)NSString * memberId;
@property(nonatomic,strong)NSString *cardCode;
@property(nonatomic,strong)NSString *feedbackContent;/** 会员提出的反馈内容 */
@property(nonatomic,strong)NSString* replyContent; /** 回馈内容*/
@property(nonatomic,strong)NSData *replyTime;
@property(nonatomic)NSInteger editor;
@property(nonatomic,strong)NSString* useTime;
@property(nonatomic,strong)NSString * reply;
@property(nonatomic)NSInteger fkscore;
@property(nonatomic)Boolean readed;
@end
