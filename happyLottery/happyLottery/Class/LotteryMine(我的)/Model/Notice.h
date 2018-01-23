//
//  Notice.h
//  happyLottery
//
//  Created by LYJ on 2018/1/19.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//
//{"auditStatus":"AUDITED","content":"多多买，总会中奖","createTime":"2018-01-19 09:53:30","creator":1,"deadLine":"2018-01-20 09:50:22","endTime":"2018-01-20 09:50:22","id":607,"linkUrl":"http://oy9n5uzrj.bkt.clouddn.com/ms/20180118/bde226ac8fb8410fa84a9cf5269cc1cb","releaseTime":"2018-01-19 09:53:13","status":"ENABLE","title":"多投多中奖","type":"H5PAGE","usageChannel":"TBZ","version":0}

#import <Foundation/Foundation.h>

@interface Notice : BaseModel

@property(nonatomic,strong)NSString *auditStatus;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *creator;
@property(nonatomic,strong)NSString *deadLine;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *linkUrl;
@property(nonatomic,strong)NSString *releaseTime;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *usageChannel;
@property(nonatomic,strong)NSString *linversionkUrl;
@property(nonatomic,strong)NSString *thumbnailCode;
@property(nonatomic,strong)NSString *cardcode;
@end
