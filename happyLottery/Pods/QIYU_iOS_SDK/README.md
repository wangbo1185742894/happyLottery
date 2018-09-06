# 网易七鱼 iOS SDK 开发指南

## 简介

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 APP 中。iOS SDK 支持 iOS 7 以上版本，同时支持 iPhone、iPad，同时支持竖屏和横屏。

## 将SDK导入工程（必须）

### 手动集成

* 下载 QY SDK，得到3个 .a 文件、 QYResouce 文件夹和 ExportHeaders 文件夹，将他们导入工程
* 添加 QY SDK 依赖库

	* UIKit.framework
	* CoreText.framework
	* MobileCoreService.framework
	* SystemConfiguration.framework
	* AVFoundation.framwork
	* CoreTelephony.framework
	* CoreMedia.framework
	* AudioToolbox.framework
	* libz.tbd
	* libstdc++.6.0.9.tbd
	* libsqlite3.0.tbd
	* libxml2.tbd
	* AssetsLibrary.framework

* 在 Build Settings -> Other Linker Flags 中添加 -ObjC 

### CocoaPods集成

在 Podfile 文件中加入 

```
	pod    'QIYU_iOS_SDK',    '~> x.x.x'
```
"x.x.x" 代表版本号，比如想要使用 3.0.0 版本，就写

```
	pod    'QIYU_iOS_SDK',    '~> 3.0.0'
```

如果无法安装 SDK 最新版本，运行以下命令更新本地的 CocoaPods 仓库列表

```
	pod repo update
```

### 解决符号重复的冲突

从 v3.1.0 开始，没有 QIYU_iOS_SDK_Exclude_Libcrypto、QIYU_iOS_SDK_Exclude_NIM 版本了，统一使用 QIYU_iOS_SDK，此SDK中将各个第三方库独立出来了，总共3个.a：libQYSDK.a、libaacplus.a、libevent.a。

1. 如果您同时使用了网易云信 iOS SDK，请只导入 libQYSDK.a，不要导入其他2个 .a 文件。
2. 如果您同时使用了 OpenSSL 库，或者您集成的其它静态库使用了 OpenSSL 库（比如支付宝 SDK），请只导入 libQYSDK.a、libevent.a，不要导入 libcrypto.a。
3. 如果是其他情况的冲突，请根据实际情况有选择的导入 libevent.a、libcrypto.a

### https相关

* v3.1.3 版本开始，SDK已经全面支持https，但是聊天消息中可能存在链接，点击链接会用UIWebView打开，链接地址有可能是http的，为了能够正常打开，需要增加配置项。在Info.plist中加入以下内容：

```
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
    </dict>
```

加了这些配置项，在 iOS9 下，会放开所有 http 请求，在 iOS10 下，因为 iOS10 规定，如果有 NSAllowsArbitraryLoadsInWebContent，就会忽略 NSAllowsArbitraryLoads，所以效果是只允许 UIWebView 中使用 http。

### iOS10权限设置

在Info.plist中加入以下内容：

```
    <key>NSPhotoLibraryUsageDescription</key>
    <string>需要照片权限</string>
    <key>NSCameraUsageDescription</key>
    <string>需要相机权限</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>需要麦克风权限</string>
```

如果不加，会crash。

### iOS11权限设置

在Info.plist中加入以下内容：

```
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>App需要您的同意,才能添加照片到相册</string>
```

如果不加，会crash。请注意，iOS11需要的是 NSPhotoLibraryAddUsageDescription，跟iOS10需要的 NSPhotoLibraryUsageDescription 不一样的。

### iOS11兼容性

请使用 3.11.0 以上的版本。

### 其它说明

* 在需要使用 SDK 的地方 import "QYSDK.h"。
* 由于 SDK 是静态库，且为了方便开发者使用，我们将 armv7 arm64 i386 x86_64 平台的静态库合并成一个 Fat Library ，导致整个 SDK 比较大。但实际编译后大约只会增加 app 4-5M 大小。

### 可能遇到的问题1
1. 无法用 CocoaPods 下载到最新的 SDK。有可能是使用了淘宝源，尝试使用默认源。

## 初始化SDK（必须）

```objc
	- (BOOL)application:(UIApplication *)application
							didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		......

	    [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];

	    ......

	    return YES;
	}
```
AppKey可以在“管理后台” -> “设置” -> “App接入” -> “2. App Key” 找到。
appName 对应管理后台添加一个 app 时填写的 “App 名称”。如果管理后台还没有添加一个 app，请及时添加。如果 appName 跟管理后台 app 的 “App 名称” 不一致，会导致无法正常收到苹果的消息推送。

## 集成聊天组件（必须）

```objc
	[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，必须嵌入到 UINavigationcontroller 中，就可以获得聊天窗口的UI以及所有功能。 sessionViewController 只会使用到导航栏的 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem 。 self.navigationItem.title 放置标题栏； self.navigationItem.rightBarButtonItem 放置"人工客服"、“评价”入口。必须注意， 不能在 sessionViewController 外层套其他 viewController 之后再嵌入到 UINavigationcontroller。

如果调用代码所在的viewController在UINavigationcontroller中，可以如下方式集成（第一种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
```

如果调用代码所在的viewController不在UINavigationcontroller中，可如下方式集成（第二种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    UINavigationController *nav =
    			[[UINavigationController alloc] initWithRootViewController:sessionViewController];
        [self presentViewController:nav animated:YES completion:nil];
    [self presentViewController:nav animated:YES completion:nil];
```
一般来说，第二种方式会需要在左上角加一个返回按钮，在 “initWithRootViewController:sessionViewController” 之前加上：

```objc
    sessionViewController.navigationItem.leftBarButtonItem =
    			[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered
    								target:self action:@selector(onBack:)];
```

“onBack” 的样例：

```objc
- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
```

如果您的代码要求所有viewController继承某个公共基类，并且公共基类对UINavigationController统一做了某些处理；或者对UINavigationController做了自己的扩展，并且这会导致集成之后有某些问题；或者其他原因导致使用第一种方式集成会有问题；这些情况下，建议您使用第二种方式集成。

### 可能遇到的问题2
1. 进入访客聊天界面马上crash。
	* 检查app工程配置－> Build Phases -> copy Bundle Resources 里面有没有QYResource.bundle；如果没有，必须加上。

2. 一直显示正在连接客服
	* 可能是AppKey填写错误
		
3. 能否同时创建多个sessionVieController
	* 不能，需要保持全局唯一。每次调用 [[QYSDK sharedSDK] sessionViewController]; 会得到一个全新的 QYSessionViewController 对象，开发者需要保证此对象全局唯一。

4. 怎么知道sessionVieController被pop了
	* 请参考 UINavigationControllerDelegate 中这个函数：

 ```objc
 -(nullable id <UIViewControllerAnimatedTransitioning>)navigationController:
 					(UINavigationController *)navigationController
 					animationControllerForOperation:(UINavigationControllerOperation)operation
 					fromViewController:(UIViewController *)fromVC
 					toViewController:(UIViewController *)toVC;
```

5. sessionVieController的导航栏可以自定义吗
	* 部分自定义。 sessionVieController 会占用 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem；navigationItem的其它部分，比如leftBarButtonItem等，您可以根据需要做任何自定义。

6. 聊天界面可以自定义吗
	* 部分自定义。 具体可参考 QYCustomUIConfig 类，Demo源码中也有相关样例代码。

7. 评价按钮为什么不能点
	* 请求到客服之后，评价按钮才能点。如果客服不在线或者排队中，是不能点的。
	
8. 键盘有异常
	* 检查下app中是否用到了会影响全局的键盘处理，如果是这种情况，需要对 QYSessionViewController 做屏蔽处理。典型的比如第三方键盘库IQKeyboardManager,如果用的是 IQKeyboardManager v4.0.4 以前的版本（不包括 v4.0.4），加入以下屏蔽代码：

```objc
	[[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[QYSessionViewController class]];
```
如果用的是 IQKeyboardManager v4.0.4 或以后的版本，加入以下屏蔽代码：

```objc
[[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[KFSessionViewController class]];
```

9. 如何强制竖屏
	* 如果您的app是横屏的，但是希望聊天界面是竖屏的，可以使用以下代码实现
	* 用的是第二种集成方式。一般来说，第二种方式会需要在左上角加一个返回按钮，这方面内容请看第二种集成方式的介绍
	
```objc
	@interface PortraitNavigationController : UINavigationController
	@end
	
	@implementation PortraitNavigationController
	
	- (UIInterfaceOrientationMask)supportedInterfaceOrientations
	{
	    return UIInterfaceOrientationMaskPortrait;
	}
	
	@end

    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    PortraitNavigationController *nav =
    			[[PortraitNavigationController alloc] initWithRootViewController:sessionViewController];
        [self presentViewController:nav animated:YES completion:nil];
    [self presentViewController:nav animated:YES completion:nil];
```
	
## 注销（必须）

```objc
	[[QYSDK sharedSDK] logout:^(){}];
```

应用层退出自己的账号时需要调用 SDK 的注销操作。

## 完成各种设置（可选）

### 消息未读数处理

```objc
	[[QYSDK sharedSDK] conversationManager];
```

返回的是一个QYConversationManager；可通过这个类获得消息未读数以及设置Delegate,通过此Delegate可以监听未读数变化。

### 获取会话列表

```objc
	[[QYSDK sharedSDK] conversationManager] getSessionList];
```
返回结果是 QYSessionInfo 数组，QYSessionInfo 内容如下：

```objc
	/**
	 *  会话状态类型
	 */
	typedef NS_ENUM(NSInteger, QYSessionStatus) {
	    QYSessionStatusNone,        //无
	    QYSessionStatusWaiting,     //排队中
	    QYSessionStatusInSession    //会话中
	};
	
	/**
	 *  会话列表中的会话详情信息
	 */
	@interface QYSessionInfo : NSObject
	
	/**
	 *  会话最后一条消息文本
	 */
	@property (nonatomic, copy) NSString *lastMessageText;
	
	/**
	 *  消息类型
	 */
	@property (nonatomic, assign) QYMessageType lastMessageType;
	
	/**
	 *  会话未读数
	 */
	@property (nonatomic, assign) NSInteger unreadCount;
	
	/**
	 *  会话状态
	 */
	@property (nonatomic, assign) QYSessionStatus status;
	
	/**
	 *  会话最后一条消息的时间
	 */
	@property (nonatomic, assign) NSTimeInterval lastMessageTimeStamp;
	
	@end
```

### 监听列表项变化

```objc
	[[QYSDK sharedSDK] conversationManager setDelegate: ];
```

通过 “setDelegate” 接口设置 delegate，delegate中有一个 “onSessionListChanged” 方法，可以监听列表项变化。

### 接收消息

```objc
	[[QYSDK sharedSDK] conversationManager setDelegate: ];
```

通过 “setDelegate” 接口设置 delegate，delegate中有一个 “onReceiveMessage” 方法，可以接收消息。

### APNS推送
* [制作推送证书并在管理后台配置](./iOS_apns.html "target=_blank")
* 初始化

```objc
	- (BOOL)application:(UIApplication *)application
										didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		......

		//传入正确的App名称
	   [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];

		//注册 APNS
		if ([[UIApplication sharedApplication]
									respondsToSelector:@selector(registerForRemoteNotifications)])
		{
			UIUserNotificationType types = UIRemoteNotificationTypeBadge
									| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
			UIUserNotificationSettings *settings =
								[UIUserNotificationSettings settingsForTypes:types categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
			[[UIApplication sharedApplication] registerForRemoteNotifications];
		}
		else
		{
			UIRemoteNotificationType types = UIRemoteNotificationTypeAlert
								| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
		}

		......

	    return YES;
	}
```

* 把 APNS Token 传给 SDK

```objc
	- (void)application:(UIApplication *)app
					didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
	{
		......

	    [[QYSDK sharedSDK] updateApnsToken:deviceToken];

	    ......
	}
```
### 可能遇到的问题3
1. 无法正常推送
 * 检查管理后台应用中是否配置过推送证书 p12 文件，此证书是否就是此 app bundle id 关联的推送证书
 * 检查证书的线上、测试环境是否跟管理后台配置的相同
 * 检查初始化时填的 appName 是否和管理后台“添加一个App”时填写的“App名称”一致
 * 检查 provision profile 是否包含了推送证书
 * 检查推送证书中是否有 p12 文件
 * 检查代码调试是否可以获取到 devicetoken
 * 检查第三方推送工具是否可以正常推送,如果不能，说明是证书本身的问题

2. 可以同时使用第三方推送工具吗
 * 可以同时使用第三方推送工具和 SDK 的消息推送，两者可以共存，不会有任何冲突。

3. 能否区分出哪些推送消息是来自七鱼的
 * 所有来自七鱼的推送消息的payload中都带有"nim:1"，通过这个可以判断出是七鱼的推送消息。
 
### 自定义商品信息
获取到 sessionViewController 之后，可以指定自定义商品信息。带着商品信息进入聊天界面，分为两种情况：如果当前还没请求到客服， 是不会发送商品信息的，等请求到客服之后会自动发；如果当前已经请求到客服了，会立刻发送商品信息。

```objc
	QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"网易七鱼";
    commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
    commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
    commodityInfo.urlString = @"http://qiyukf.com/";
    commodityInfo.note = @"￥10000";
    commodityInfo.show = YES; //访客端是否要在消息中显示商品信息，YES代表显示,NO代表不显示

	sessionViewController.commodityInfo = commodityInfo;
```

#### 可能遇到的问题4
1. 商品链接的点击处理可自定义，请参看此文档关于 QYCustomActionConfig 的相关说明。

### 自定义聊天组件UI效果

获取自定义UI类对象

```objc
	[[QYSDK sharedSDK] customUIConfig];
```
QYCustomUIConfig是负责自定义UI的类；目前主要是定义聊天界面中的字体颜色、大小、头像等。相关设置必须在集成聊天组件之前进行。调整UI样例代码：

```objc
	/**
	 *  会话窗口上方提示条中的文本字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [UIColor blackColor];
    /**
	 *  会话窗口上方提示条中的文本字体大小
	 */
    [[QYSDK sharedSDK] customUIConfig].sessionTipTextFontSize = 16;
    /**
	 *  会话窗口上方提示条中的背景颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].sessionTipBackgroundColor = [UIColor whiteColor];
	/**
	 *  访客文本消息字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
    /**
	 *  访客文本消息超链接字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].customMessageHyperLinkColor = [UIColor blackColor];
    /**
	 *  访客文本消息字体大小
	 */
    [[QYSDK sharedSDK] customUIConfig].customMessageTextFontSize = 16;
    /**
	 *  客服文本消息字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
    /**
	 *  客服文本消息超链接字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageHyperLinkColor = [UIColor blueColor];
    /**
	 *  客服文本消息字体大小
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextFontSize = 16;
    /**
	 *  提示文本消息字体颜色；提示文本消息有很多种，比如“***为你服务”就是一种
	 */
    [[QYSDK sharedSDK] customUIConfig].tipMessageTextColor = [UIColor blackColor];
    /**
	 *  提示文本消息字体大小；提示文本消息有很多种，比如“***为你服务”就是一种
	 */
    [[QYSDK sharedSDK] customUIConfig].tipMessageTextFontSize = 16;
    /**
	 *  输入框文本消息字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].inputTextColor = [UIColor blackColor];
    /**
	 *  输入框文本消息字体大小
	 */
    [[QYSDK sharedSDK] customUIConfig].inputTextFontSize = 16;      
	/**
	 *  消息tableview的背景图片
	 */
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
	/**
	 *  访客头像
	 */
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"customer_head"];
    /**
	 *  访客头像url
	 */
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = @"http_url";
    /**
	 *  客服头像
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
    /**
	 *  客服头像url
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImageUrl = @"http_url";
    /**
	 *  访客消息气泡normal图片
	 */
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = 
										[[UIImage imageNamed:@"icon_sender_node"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                 resizingMode:UIImageResizingModeStretch];
    /**
	 *  访客消息气泡pressed图片
	 */
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = 
    									[[UIImage imageNamed:@"icon_sender_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                  resizingMode:UIImageResizingModeStretch];
	/**
	 *  客服消息气泡normal图片
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = 
    									[[UIImage imageNamed:@"icon_receiver_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                  resizingMode:UIImageResizingModeStretch];
    /**
	 *  客服消息气泡pressed图片
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = 
    									[[UIImage imageNamed:@"icon_receiver_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                  resizingMode:UIImageResizingModeStretch];
    /**
	 *  消息竖直方向间距
	 */
    [[QYSDK sharedSDK] customUIConfig].sessionMessageSpacing = 20;
    /**
	 *  是否显示头像
	 */
    [[QYSDK sharedSDK] customUIConfig].showHeadImage = NO;
    /**
	 *  默认是YES,默认rightBarButtonItem内容是黑色，设置为NO，可以修改为白色
	 */
    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
    /**
	 *  默认是YES,默认显示发送语音入口，设置为NO，可以修改为隐藏
	 */
    [QYCustomUIConfig sharedInstance].showAudioEntry = YES;
    /**
	 *  默认是YES,默认在机器人模式下显示发送语音入口，设置为NO，可以修改为隐藏
	 */
    [QYCustomUIConfig sharedInstance].showAudioEntryInRobotMode = YES;
    /**
	 *  默认是YES,默认显示发送表情入口，设置为NO，可以修改为隐藏
	 */
    [QYCustomUIConfig sharedInstance].showEmoticonEntry = YES;
	/**
	 *  默认是YES,默认进入聊天界面，是文本输入模式的话，会弹出键盘，设置为NO，可以修改为不弹出
	 */
    [QYCustomUIConfig sharedInstance].autoShowKeyboard = YES;
    /**
	 *  表示聊天组件离界面底部的间距，默认是0；比较典型的是底部有tabbar，这时候设置为tabbar的高度即可
	 */
    [QYCustomUIConfig sharedInstance].bottomMargin = self.tabBarController.tabBar.ysf_frameHeight;
    /**
	 *  是否显示关闭会话入口
	 */
	[QYCustomUIConfig sharedInstance].showCloseSessionEntry = YES;
```

### 自定义聊天组件事件处理

获取自定义事件处理类对象

```objc
	[[QYSDK sharedSDK] customActionConfig];
```
QYCustomActionConfig是负责自定义事件处理的类；目前支持自定义点击事件。

```objc

	/**
	 *  提供了所有自定义行为的接口;每个接口对应一个自定义行为的处理，
	 *  如果设置了，则使用设置的处理，如果不设置，则采用默认处理
	 */
	
	typedef void (^QYLinkClickBlock)(NSString *linkAddress);
	typedef void (^QYBotClickBlock)(NSString *target, NSString *params);
	
	@interface QYCustomActionConfig : NSObject
	
	+ (instancetype)sharedInstance;
	
	/**
	 *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
	 */
	@property (nonatomic, copy) QYLinkClickBlock linkClickBlock;
	
	/**
	 *  bot相关点击
	 */
	@property (nonatomic, copy) QYBotClickBlock botClick;
	
	/**
	 *  设置录制或者播放语音完成以后是否自动deactivate AVAudioSession
	 *
	 *  @param deactivate 是否deactivate，默认为YES
	 */
	- (void)setDeactivateAudioSessionAfterComplete:(BOOL)deactivate;
	
	/**
	 *  显示退出排队提示
	 *
	 *  @param quitWaitingBlock 选择结果回调
	 */
	- (void)showQuitWaiting:(QYQuitWaitingBlock)quitWaitingBlock;

@end

```

### 更换图片素材

QYCustomUIConfig只是负责替换部分皮肤相关内容，不包含所有的图片素材的替换。iOS SDK支持所有图片素材替换，只需要新建QYCustomResource.bundle，在其中放置跟QYResource.bundle中同名的图片素材，即可替换QYResource.bundle中的对应素材。为了效果好，应该放置同等尺寸的图片。

### 指定客服Id或客服组Id

在获取 sessionViewController 之后，可以指定客服 Id 或客服组 Id

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.groupId = groupId;
    sessionViewController.staffId = staffId;
```

指定之后，进入聊天界面时，会直接以此 id 去请求到对应的客服或者客服组。在 管理后台 -> 设置 -> 高级设置 -> 访客分配 -> ID 查询 中可查询到客服 Id 或客服组 Id 。

### 指定常见问题模版Id

在获取 sessionViewController 之后，可以指定常见问题模版Id

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.commonQuestionTemplateId = commonQuestionTemplateId;
```

指定之后，进入聊天界面时，会直接以此 id 去请求到对应的常见问题模版。在 管理后台 -> 设置 -> 机器人 -> 常见问题设置 中可查询到常见问题模版Id。

### 访客分流是否开启机器人 

在获取 sessionViewController 之后，可以指定访客分流是否开启机器人，默认不开启。如果开启机器人，则选择客服或者客服分组之后，先进入机器人模式。

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.openRobotInShuntMode = openRobotInShuntMode;
```

### 设置vip等级 

在获取 sessionViewController 之后，可以设置访客的vip等级，默认是非vip。vip等级分两种，一种是从非vip和vip1~vip10，vip对应的数值是1～10；另一种是非vip和vip，vip对应的数值是11。

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.vipLevel = 1;
```

### CRM

```objc
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = @"userId";
	 NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dictRealName = [NSMutableDictionary new];
    [dictRealName setObject:@"real_name" forKey:@"key"];
    [dictRealName setObject:@"边晨" forKey:@"value"];
    [array addObject:dictRealName];
    NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
    [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
    [dictMobilePhone setObject:@"13805713536" forKey:@"value"];
    [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
    [array addObject:dictMobilePhone];
    NSMutableDictionary *dictEmail = [NSMutableDictionary new];
    [dictEmail setObject:@"email" forKey:@"key"];
    [dictEmail setObject:@"bianchen@163.com" forKey:@"value"];
    [array addObject:dictEmail];
    NSMutableDictionary *dictAuthentication = [NSMutableDictionary new];
    [dictAuthentication setObject:@"0" forKey:@"index"];
    [dictAuthentication setObject:@"authentication" forKey:@"key"];
    [dictAuthentication setObject:@"实名认证" forKey:@"label"];
    [dictAuthentication setObject:@"已认证" forKey:@"value"];
    [array addObject:dictAuthentication];
    NSMutableDictionary *dictBankcard = [NSMutableDictionary new];
    [dictBankcard setObject:@"1" forKey:@"index"];
    [dictBankcard setObject:@"bankcard" forKey:@"key"];
    [dictBankcard setObject:@"绑定银行卡" forKey:@"label"];
    [dictBankcard setObject:@"622202******01116068" forKey:@"value"];
    [array addObject:dictBankcard];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:0
                                                     error:nil];
    if (data)
    {
        userInfo.data = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }

	[[QYSDK sharedSDK] setUserInfo:userInfo];
```
userInfo: 字段“id”表示用户id，字段“data”表示用户信息，具体请看官网CRM相关文档:
<a>http://qiyukf.com/newdoc/html/qiyu_crm_interface.html</a>

### 七鱼系统推送消息

七鱼系统推送消息(跟苹果的apns推送无关)

可以主动要求服务器返回指定的消息

```objc

/**
 *  获取推送消息
 *
 *  @param messageId 消息id
 */
- (void)getPushMessage:(NSString *)messageId;

```

可以接收服务器返回的消息，以进行界面展示；不管是主动获取的消息还是管理后台主动推送的消息，
都通过此接口获取。

```objc

/**
 *  注册推送消息通知回调
 *
 *  @param messageId 消息id
 */
- (void)RegisterPushMessageNotification:(QYPushMessageBlock)block;

```

### 清理文件缓存

文件消息接收并下载后可以通过此接口清理已下载到本地的文件。

```objc
/**
 清理接收文件缓存
 @param completeBlock 清理缓存完成block
 */
- (void)cleanResourceCacheWithBlock:(QYCleanResourceCacheCompleteBlock)completeBlock;
```

## 平台电商版本
平台电商版本相关头文件全部在 "QIYU_iOS_SDK/POP" 目录下。在需要使用 SDK 的地方 import "QYPOPSDK.h"。

### 删除会话项

```objc
	[[QYSDK sharedSDK] conversationManager] deleteRecent****SessionByShopId:@"shopId" deleteMessages:YES];
```

### 进入聊天窗口，请求特定商家

```objc
	[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，可以设置 "shopId":

```objc
    sessionViewController.shopId = @"shopId";
```

### 监听聊天窗口事件

设置 QYSessionViewDelegate：

```objc
	[[QYSDK sharedSDK] sessionViewController].delegate = ;
```
QYSessionViewDelegate 中可以获取“点击商铺入口按钮回调” 和 “点击聊天窗口右边或左边会话列表按钮回调”

## 参考DEMO源码

如果您看完此文档后，还有任何集成方面的疑问，可以参考下 iOS SDK Demo 源码: https://github.com/qiyukf/QIYU_iOS_SDK_Demo_Source.git 。源码充分的展示了 iOS SDK 的能力，并且为集成 iOS SDK 提供了样例代码。

## 更新说明

v3.7.0 :
	1. 新增富文本处理
	2. 新增对机器人答案进行评价
	注意事项：增加了对 libxml2.tbd 的依赖

v3.11.0 :
	1. 兼容 iOS 11
	2. 兼容 iPhone X
