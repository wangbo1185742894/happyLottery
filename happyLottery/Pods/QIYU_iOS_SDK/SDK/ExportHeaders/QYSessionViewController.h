//
//  QYSessionViewController.h
//  QYSDK
//
//  Created by towik on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//
#import <UIKit/UIKit.h>

@class QYSource;
@class QYCommodityInfo;

/**
 *  输入区域上方工具栏内的按钮信息
 */
@interface QYButtonInfo : NSObject

@property (nonatomic,strong)    id      buttonId;
@property (nonatomic,copy)      NSString *title;
@property (nonatomic,strong)    id      userData;

@end


/**
 *  输入区域上方工具栏内的按钮点击回调
 */
typedef void (^QYButtonClickBlock)(QYButtonInfo *action);


/**
 *  客服会话ViewController,必须嵌入到UINavigationcontroller中
 */
@interface QYSessionViewController : UIViewController

/**
 *  会话窗口标题
 */
@property (nonatomic,copy)      NSString    *sessionTitle;

/**
 *  访客分流 分组Id
 */
@property (nonatomic,assign)    int64_t groupId;

/**
 *  访客分流 客服Id
 */
@property (nonatomic,assign)    int64_t staffId;

/**
 *  机器人Id
 */
@property (nonatomic,assign)    int64_t robotId;

/**
 *  vip等级
 */
@property (nonatomic,assign)    NSInteger   vipLevel;

/**
 *  访客分流 是否开启机器人
 */
@property (nonatomic,assign)    BOOL openRobotInShuntMode;

/**
 *  常见问题 模版Id
 */
@property (nonatomic,assign)    int64_t commonQuestionTemplateId;

/**
 *  会话窗口来源
 */
@property (nonatomic,strong)    QYSource   *source;

/**
 *  商品信息展示
 */
@property (nonatomic, strong) QYCommodityInfo *commodityInfo;

/**
 *  输入区域上方工具栏内的按钮信息
 */
@property (nonatomic, copy) NSArray<QYButtonInfo *> *buttonInfoArray;

/**
 *  输入区域上方工具栏内的按钮点击回调
 */
@property (nonatomic, copy) QYButtonClickBlock buttonClickBlock;

/**
 *  发送商品信息展示
 */
- (void)sendCommodityInfo:(QYCommodityInfo *)commodityInfo;

@end


