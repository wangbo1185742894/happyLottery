//
//  Macro.h
//
//  Created by Yang on 10/5/11.
//  Copyright 2011 AMP. All rights reserved.
//



#define TitleTextFont [UIFont systemFontOfSize: 18]
#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]
#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]

#define NumFromBOOL(B)      [NSNumber numberWithBool : B]
#define NumFromInt(I)       [NSNumber numberWithInt : I]
#define NumFromDouble(D)    [NSNumber numberWithDouble : D]
#define NumFromFloat(f)     [NSNumber numberWithFloat : f]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_7P (IS_IPHONE && SCREEN_MAX_LENGTH == 756.0)
#define IS_IPHONE_7PANDIOS11 ([device isEqualToString:@"iPhoneSimulator"] || [device isEqualToString:@"iPhone7Plus"]) && [Utility isIOS11Later]
#define IS_IOS11 [Utility isIOS11Later]
#define FormatStr(fmt, ...) [NSString stringWithFormat : fmt, ## __VA_ARGS__]

#define SafeRelease(obj)    [obj release], obj=nil;

#define ShowLog

#ifdef ShowLog
#define DLog(A) NSLog(@ "Debug:%@", A)
#define ILog(A) NSLog(@ "Info:%@", A)
#define ELog(A) NSLog(@ "Error:%@", A)

#define DFLog(fmt, ...) NSLog( (@ "Debug: " fmt), ## __VA_ARGS__ )
#define IFLog(fmt, ...) NSLog( (@ "Info: " fmt), ## __VA_ARGS__ )
#define EFLog(fmt, ...) NSLog( (@ "Error: " fmt), ## __VA_ARGS__ )
#else
#define DLog(A)
#define ILog(A)
#define ELog(A)

#define DFLog(fmt, ...)
#define IFLog(fmt, ...)
#define EFLog(fmt, ...)
#endif


//{ 以下是2.0 版本所需要用到的  颜色 素材。

//用于所有界面的 背景色
#define MAINBGC RGBCOLOR(245, 245, 245)



#define KTUIJIANCELLHEIGHT 35.0
#define KTUIJIANCELLWIDTH 65.0
#define YUCEREDCOlOR RGBCOLOR(231 , 94, 61)
//分割线颜色
#define ISIOS11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11
#ifdef ISIOS11
#define SEPCOLOR RGBCOLOR(240, 240, 240)
#else
#define SEPCOLOR RGBCOLOR(218, 218, 218)
#endif

#define SEPHEIGHT 0.5
#define SEPLEADING 15

//这是 NavigationBar 的背景颜色
#define NAVORANGECOLOR RGBCOLOR(200, 85, 62)

#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

//所有tableviewCell的选中颜色 使用下列语句设定
//cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
#define CellSelectedColor RGBCOLOR(247, 247, 247)

//橘黄色字体颜色(橘色button nor 字色)
#define TextCharColor RGBCOLOR(232, 79, 42)
// 倒计时字体橘黄色颜色
#define TextTimeColor RGBCOLOR(239, 132, 85)
//橘色button high 字色
#define TextOrangeColor RGBCOLOR(232, 79, 42)

//一种字体颜色，显示在主背景颜色上的 普通字体颜色  灰色btn nor字色
#define TEXTGRAYCOLOR RGBCOLOR(72, 72, 72) //偏黑色
// 灰色btn high 字色
#define TextLightgrayColor [UIColor lightGrayColor]
// 开奖结果显示背景的颜色
#define TextCTZQGreen RGBCOLOR(71, 153, 106)
//推送中开奖结果显示颜色
#define TextCTZQBlue  RGBCOLOR(79, 155, 234)

//时间显示的颜色
#define TIMECOLOR RGBCOLOR(174, 174, 174)


#define TextCharColorNomal RGBCOLOR(232, 79, 42)

#define SystemRed  RGBCOLOR(209, 57, 34)
#define SystemGreen  RGBCOLOR(73, 165, 29)
#define SystemBlue  RGBCOLOR(94, 154, 210)
#define SystemGray RGBCOLOR(213, 213, 213)
#define Systemorange RGBCOLOR(188, 126, 24)

//视图左边留白距离
#define LEFTPADDING 15

//十一选五每天最大期数
#define MAXQI11X5 88

//}

#define ColorFromImage(imageName) [UIColor colorWithPatternImage: [UIImage imageNamed: imageName]]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HEXCOLORALPHA(c) [UIColor colorWithRed : ( (c >> 24) & 0xFF ) / 255.0 green : ( (c >> 16) & 0xFF ) / 255.0 blue : ( (c >> 8) & 0xFF ) / 255.0 alpha : ( (c) & 0xFF ) / 255.0]
#define HEXCOLOR(c) ([UIColor colorWithRed : ( (c >> 16) & 0xFF ) / 255.0 green : ( (c >> 8) & 0xFF ) / 255.0 blue : ( (c) & 0xFF ) / 255.0 alpha : 1.0])

#define isArray(A)      [A isKindOfClass :[NSArray class ]]
#define isDictionary(A)      [A isKindOfClass :[NSDictionary class ]]

#define FirstObjectOfArray(A) ([A count] > 0) ? [A objectAtIndex : 0] : nil

//#define LegalString(str)     if (str == nil) { return @ ""; } \
//    return str;
//#define isLegalString(str)   if ( (str == nil) ||[str length] < 1 ) { return NO; } \
//    return YES;



//debug stuff
#define ShowCurrentPosition(button) NSLog(@ "\n Function: %s\n Pretty function: %s\n Line: %d\n File: %s\n Object: %@", __func__, __PRETTY_FUNCTION__, __LINE__, __FILE__, button)

#define ShowCurrentLocation NSLog(@ "Current selector: %@, Object class: %@, Filename: %@", NSStringFromSelector(_cmd), NSStringFromClass([self class ]), [[NSString stringWithUTF8String : __FILE__] lastPathComponent])

#define ShowStackSymbols NSLog(@ "Stack trace: %@", [NSThread callStackSymbols])



#define ThumbnailDownloadPrefix @"thumbnailPhoto"


#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MBLabelAlignmentCenter NSTextAlignmentCenter
#else
#define MBLabelAlignmentCenter UITextAlignmentCenter
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif


#define NotificationNameUserLogin @"user_login_notification"
#define OrderPaySuccessNotification @"OrderPaySuccessNotification"
#define KscreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define KscreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
// 登录名验证：4到16位，数字或英文或下划线
#define REG_LOGINNAME_STR   @"^[a-zA-Z0-9_\u4e00-\u9fa5]{4,16}+$"
// 真实姓名验证：汉字 [\u4e00-\u9fa5]
#define REG_NICKNAME_STR    @"^([\u4e00-\u9fa5]){0,}$"
// 密码验证：6到16位数字和英文
#define REG_PASSWORD_STR    @"^[A-Za-z0-9]{6,16}+$"
// 邮箱验证
#define REG_MAIL_STR        @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
// 手机号码验证
#define REG_PHONENUM_STR    @"^((13[0-9])|(147)|(15[^4,\\D])|(17[^4,\\D])|(18[0-9]))\\d{8}$"
// 身份证验证：15或18位
#define REG_IDCARDNUM_STR   @"\\d{15}|\\d{18}"

//银行卡号 11.17   16位或19位
#define REG_BANKCARD_STR    @"\\d{16}|\\d{19}"
