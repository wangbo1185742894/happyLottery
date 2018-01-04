//
//  Macro.h
//
//  Created by Yang on 10/5/11.
//  Copyright 2011 AMP. All rights reserved.
//



#define TitleTextFont [UIFont systemFontOfSize: 18]
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


#define MAINBGC             RGBCOLOR(245, 245, 245)
#define SystemGray          RGBCOLOR(38, 38, 38)
#define SystemGreen         RGBCOLOR(18, 199, 146)
#define SystemBlue          RGBCOLOR(49, 137, 253)
#define SystemLightGray     RGBCOLOR(141, 141, 141)
#define BtnDisAbleBackColor RGBCOLOR(238,238,238)
#define BtnDisAbleTitleColor RGBCOLOR(158,158,158)
#define TFBorderColor        RGBCOLOR(227,227,227)
#define TEXTGRAYCOLOR       RGBCOLOR(72, 72, 72) //偏黑色

//这是 NavigationBar 的背景颜色


#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

#define ColorFromImage(imageName) [UIColor colorWithPatternImage: [UIImage imageNamed: imageName]]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HEXCOLORALPHA(c) [UIColor colorWithRed : ( (c >> 24) & 0xFF ) / 255.0 green : ( (c >> 16) & 0xFF ) / 255.0 blue : ( (c >> 8) & 0xFF ) / 255.0 alpha : ( (c) & 0xFF ) / 255.0]
#define HEXCOLOR(c) ([UIColor colorWithRed : ( (c >> 16) & 0xFF ) / 255.0 green : ( (c >> 8) & 0xFF ) / 255.0 blue : ( (c) & 0xFF ) / 255.0 alpha : 1.0])

#define isArray(A)      [A isKindOfClass :[NSArray class ]]
#define isDictionary(A)      [A isKindOfClass :[NSDictionary class ]]

#define FirstObjectOfArray(A) ([A count] > 0) ? [A objectAtIndex : 0] : nil

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
#define KSELECTMATCHCLEAN @"touZhuSelectMatchDelete"

#define KscreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define KscreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
// 登录名验证：4到16位，数字或英文或下划线
#define REG_LOGINNAME_STR   @"^[a-zA-Z0-9_\u4e00-\u9fa5]{4,16}+$"
// 真实姓名验证：汉字 [\u4e00-\u9fa5]
#define REG_NICKNAME_STR    @"^([\u4e00-\u9fa5]){0,}$"
// 密码验证：6到16位数字和英文@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
#define REG_PASSWORD_STR    @"^[A-Za-z0-9]{6,16}+$"
// 邮箱验证
#define REG_MAIL_STR        @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
// 手机号码验证
#define REG_PHONENUM_STR    @"^((13[0-9])|(166)|(199)|(147)|(15[^4,\\D])|(17[^4,\\D])|(18[0-9]))\\d{8}$"
// 身份证验证：15或18位
#define REG_IDCARDNUM_STR   @"\\d{15}|\\d{18}"

//银行卡号 11.17   16位或19位
#define REG_BANKCARD_STR    @"\\d{16}|\\d{19}"

//channelCode
#define CHANNEL_CODE    @"TBZ"

