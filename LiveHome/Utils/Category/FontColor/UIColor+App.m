//
//  UIColor+App.m
//  HHFramework
//
//  Created by chh on 2017/7/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "UIColor+App.h"

@implementation UIColor (App)
//MARK:- Theme
+ (UIColor *)themeColor{
    return [UIColor colorWithHex:0x1b76d0];
}

//MARK:- Background
+ (UIColor *)bgColorMain{
    return [UIColor colorWithHex:0xf2f2f2];//灰色
}

+ (UIColor *)bgColorWhite{
    return [UIColor colorWithHex:0xffffff];
}

+ (UIColor *)bgColorLine{
    return [UIColor colorWithHex:0xececec];
}

+ (UIColor *)bgColorLineDarkGray{
    return [UIColor colorWithHex:0x4c4c4c];
}

//MARK:- Font
+ (UIColor *)fontColorBlack{
    return [UIColor colorWithHex:0x333333];
}

+ (UIColor *)fontColorDarkGray{
    return [UIColor colorWithHex:0x4c4c4c];
}

+ (UIColor *)fontColorLightGray{
    return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)fontColorOrange{
    return [UIColor colorWithHex:0xffb83c];
}

+ (UIColor *)fontColorMoneyGolden{
    return [UIColor colorWithHex:0xff890b];
}

//MARK:- Button
+ (UIColor *)buttonColorTheme{
    return [UIColor colorWithHex:0xcccccc];
}


//MARK:- Method
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)randomColor
{
    return [UIColor colorWithRed:(arc4random()%255)*1.0f/255.0
                           green:(arc4random()%255)*1.0f/255.0
                            blue:(arc4random()%255)*1.0f/255.0 alpha:1.0];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
