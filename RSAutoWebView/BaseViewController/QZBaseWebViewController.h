//
//  QZBaseWebViewController.h
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/15.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "QZBaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import "RSAutoWebView.h"

@interface QZBaseWebViewController : QZBaseViewController<RSAutoWebViewDelegate>
#pragma mark - 设置加载
/* 
 * url    请求地址
 * isOpen 是否开启自动选择WebView功能
 *        是: usingUIWebView 设置无效
 *        否: usingUIWebView 设定是否使用 UIWebView
 */
- (void)loadWebViewWithURL:(NSString *)url autoChoose:(BOOL)isOpen ifCloseAutoChooseUsingUIWebView:(BOOL)usingUIWebView;


#pragma mark - 参数、方法
// URL地址
@property (nonatomic,copy) NSString *url;

// 加载URL方法
- (void)reloadRequest:(NSString *)url;

// 返回顶端
- (void)scrollToTop;

// 图片适应 JavaScript 注入
- (void)imgAutoFit;

// WebView中收起键盘方法
- (void)packupKeyboard;

// 返回方法
- (void)webViewBackAction:(UIBarButtonItem *)sender;

// 清理缓存
- (void)clearCache;


#pragma mark - 代理方法
/**
 *  统一wk ui加载状态代理方法，二合一
 */
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView, NSError *error);

#pragma mark - WebViewJavascriptBridge JS交互方法
//callHandler【OC向JS发生消息】
- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData;
@property (nonatomic,copy) void(^javaScriptCallReturnBlock)(id response);

//registerHandler 【OC接收JS的消息】
- (void)JSRegisterHandlerWithFuncName:(NSString *)name;
@property (nonatomic,copy) void(^javaScriptRegisterReturnBlock)(id response, WVJBResponseCallback responseCallback);

@end
