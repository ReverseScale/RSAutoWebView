//
//  QZBaseWebViewController.h
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/15.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <WebViewJavascriptBridge.h>
#import "RSAutoWebView.h"

@interface QZBaseWebViewController : UIViewController<RSAutoWebViewDelegate>
#pragma mark - 设置加载
/// url请求地址
- (void)loadWebViewWithURL:(NSString *)url;


#pragma mark - 其他方法
/// 加载URL方法
- (void)reloadRequest:(NSString *)url;
/// 返回顶端
- (void)scrollToTop;
/// 图片适应 JavaScript 注入
- (void)imgAutoFit;
/// WebView 中收起键盘方法
- (void)packupKeyboard;
/// 返回方法
- (void)webViewBackAction:(UIBarButtonItem *)sender;
/// 清理缓存
- (void)clearCache;


#pragma mark - 代理方法
// 统一wk ui加载状态代理方法，二合一
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView, NSError *error);


#pragma mark - WebViewJavascriptBridge JS交互方法
@property (nonatomic,copy) void(^javaScriptCallReturnBlock)(id response);
@property (nonatomic,copy) void(^javaScriptRegisterReturnBlock)(id response, WVJBResponseCallback responseCallback);

///registerHandler 【OC接收JS的消息】
- (void)JSRegisterHandlerWithFuncName:(NSString *)name;
///callHandler【OC向JS发生消息】
- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData;
@end
