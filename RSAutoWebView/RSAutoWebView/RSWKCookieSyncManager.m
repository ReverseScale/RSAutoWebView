//
//  RSWKCookieSyncManager.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/16.
//  Copyright © 2017年 StevenXie. All rights reserved.
//  WKWebView和UIWebView的Cookie共享工具

#import "RSWKCookieSyncManager.h"

@interface RSWKCookieSyncManager ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation RSWKCookieSyncManager
+ (instancetype)sharedWKCookieSyncManager {
    static RSWKCookieSyncManager *sharedWKCookieSyncManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWKCookieSyncManagerInstance = [[self alloc] init];
    });
    return sharedWKCookieSyncManagerInstance;
}

- (void)setCookie {
    //判断系统是否支持wkWebView
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (!wkWebView) {
        return;
    }
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.processPool = self.processPool;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];
}

#pragma - get
- (WKProcessPool *)processPool {
    if (!_processPool) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            _processPool = [[WKProcessPool alloc] init];
        });
    }
    
    return _processPool;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate;\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [webView evaluateJavaScript:JSCookieString completionHandler:nil];
}

@end
