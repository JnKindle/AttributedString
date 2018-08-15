//
//  ViewController.m
//  AttributedString
//
//  Created by Jn_Kindle on 2018/8/14.
//  Copyright © 2018年 JnKindle. All rights reserved.
//

#define JnScreenWidth [UIScreen mainScreen].bounds.size.width
#define JnScreenHeight [UIScreen mainScreen].bounds.size.height
#define JnContentSize 13

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //内容文本
    NSString *content = @"欢迎使用健康档案服务！为了让您放心使用产品及服务，请务必仔细阅读，充分理解协议中的条款内容后在点击同意，以便您更好的行使个人权利及保护个人隐私。\n\n注意：当你点击同意，即视为您已阅读并同意《健康档案服务协议》与《数字证书认证服务说明》。";
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 100, JnScreenWidth-24, 200)];
    contentTextView.attributedText = [self getContentLabelAttributedText:content];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.delegate = self;
    contentTextView.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    contentTextView.scrollEnabled = NO;
    [self.view addSubview:contentTextView];
    
    
    
    
    
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"healthservice"]) {
        //《健康档案服务协议》
        NSLog(@"点击了《健康档案服务协议》");
        return NO;
    }else if ([[URL scheme] isEqualToString:@"digitalcer"]) {
        //《数字证书认证服务说明》
        NSLog(@"点击了《数字证书认证服务说明》");
        return NO;
    }
    return YES;
}


#pragma Others

//----------------------------------
- (NSAttributedString *)getContentLabelAttributedText:(NSString *)text
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JnContentSize],NSForegroundColorAttributeName:[self colorWithHexString:@"#333333"]}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#528DF0"] range:NSMakeRange(text.length-24, 10)];
    [attrStr addAttribute:NSLinkAttributeName value:@"healthservice://" range:NSMakeRange(text.length-24, 10)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#528DF0"] range:NSMakeRange(text.length-13, 12)];
    [attrStr addAttribute:NSLinkAttributeName value:@"digitalcer://" range:NSMakeRange(text.length-13, 12)];
    return attrStr;
}


//----------------- UIColor -----------------
- (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
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
    //适配新方法
    return [self colorwithR:r G:g B:b alpha:alpha];
}

- (UIColor *)colorwithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha{
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    } else {
        // Fallback on earlier versions
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
