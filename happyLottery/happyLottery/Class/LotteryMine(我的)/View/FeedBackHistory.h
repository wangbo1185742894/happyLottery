//
//  FeedBackHistory.h
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackHistory : BaseModel

@property(nonatomic,strong)NSString * memberId;
@property(nonatomic,strong)NSString *cardCode;
@property(nonatomic,strong)NSString *feedbackContent;/** 会员提出的反馈内容 */
@property(nonatomic,strong)NSString* replyContent; /** 回馈内容*/
@property(nonatomic,strong)NSString *replyTime;
@property(nonatomic,strong)NSString* editor;
@property(nonatomic,strong)NSString* useTime;
@property(nonatomic,strong)NSString*  reply;
@property(nonatomic,strong)NSString * fkscore;
@property(nonatomic,strong)NSString* readed;
@property(nonatomic,strong)NSString* createTime;
@property(nonatomic,strong)NSString* _id;
@property(nonatomic,strong)NSString* version;
@end
