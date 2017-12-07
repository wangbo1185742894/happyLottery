//
//  Macro.h
//
//  Created by Yang on 10/5/11.
//  Copyright 2011 AMP. All rights reserved.
//

#define KscreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define KscreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]
#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]

#define NumFromBOOL(B)      [NSNumber numberWithBool : B]
#define NumFromInt(I)       [NSNumber numberWithInt : I]
#define NumFromDouble(D)    [NSNumber numberWithDouble : D]
#define NumFromFloat(f)     [NSNumber numberWithFloat : f]

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
