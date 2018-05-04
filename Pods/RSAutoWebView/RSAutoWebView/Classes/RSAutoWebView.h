//
//  RSAutoWebView.h
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/9.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WKScriptMessageHandler;
@class RSAutoWebView, JSContext;

@protocol RSAutoWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(RSAutoWebView*)webView;
- (void)webViewDidFinishLoad:(RSAutoWebView*)webView;
- (void)webView:(RSAutoWebView*)webView didFailLoadWithError:(NSError*)error;
- (BOOL)webView:(RSAutoWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface RSAutoWebView : UIView
//使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

//会转接 WKUIDelegate，WKNavigationDelegate 内部未实现的回调。
@property (weak, nonatomic) id<RSAutoWebViewDelegate> delegate;

//内部使用的webView
@property (nonatomic, readonly) id realWebView;
//是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
//预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

//只有ios7以上的UIWebView才能获取到，WKWebView 请使用下面的方法.
@property (nonatomic, readonly) JSContext* jsContext;
//WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

//back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

//---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView* scrollView;

- (id)loadRequest:(NSURLRequest*)request;
- (id)loadHTMLString:(NSString*)string baseURL:(NSURL*)baseURL;

@property (nonatomic, readonly, copy) NSString* title;
@property (nonatomic, readonly) NSURLRequest* currentRequest;
@property (nonatomic, readonly) NSURL* URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;
// 清理缓存
- (void)clearCache;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;
// 不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

// 是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

@end
