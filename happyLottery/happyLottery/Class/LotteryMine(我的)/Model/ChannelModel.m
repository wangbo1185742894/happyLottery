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
    NSDictionary *iconDic = @{@"YUE":@"icon_yue",@"UNION":@"icon_yinlian",@"WFTWX":@"icon_weixin",@"WFTWX_HC":@"icon_weixin",@"SDALI":@"icon_zhifubao",@"BOINGWX":@"icon_weixin",@"YUN_WX_XCX":@"icon_weixin",@"HAWKEYE_ALI":@"icon_zhifubao",@"SDWX":@"weixinsaoma"};
    return iconDic[self.channel];
}
-(NSString*)channelTitle{
    NSDictionary *iconDic = @{@"YUE":@"余额支付",@"UNION":@"银联支付",@"WFTWX":@"微信支付(推荐)",@"WFTWX_HC":@"微信支付(推 荐)",@"SDALI":@"支付宝支付",@"BOINGWX":@"微信支付",@"YUN_WX_XCX":@"微信",@"HAWKEYE_ALI":@"支付宝",@"SDWX":@"微信扫码支付"};
    return iconDic[self.channel];
}

@end

@implementation RechargeModel

@end
