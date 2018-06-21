//
//  ChannelModel.m
//  happyLottery
//
//  Created by 王博 on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel
-(NSString*)channelIcon{
    NSDictionary *iconDic = @{@"YUE":@"icon_yue",@"UNION":@"icon_yinlian",@"WFTWX":@"icon_weixin",@"SDALI":@"icon_zhifubao",@"BOINGWX":@"icon_weixin"};
    return iconDic[self.channel];
}
-(NSString*)channelTitle{
    NSDictionary *iconDic = @{@"YUE":@"余额支付",@"UNION":@"银联支付",@"WFTWX":@"微信支付(推荐)",@"SDALI":@"支付宝支付",@"BOINGWX":@"微信支付2"};
    return iconDic[self.channel];
}

@end

@implementation RechargeModel

@end
