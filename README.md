# RSAutoWebView

![image](http://og1yl0w9z.bkt.clouddn.com/17-6-30/79072301.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/cocoapods/dt/PPNetworkHelper.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

针对 iOS 不同版本下 WebView 的碎片化，进行整理封装，主要功能是根据系统版本自动选择 UI/WK-WebView 进行加载。同时使用 Block 方式封装常见的 JavaScript <-> Objective-C的交互、滑动至顶部功能、扩展脚本、针对 WKWebView 和 UIWebView 的 Cookie 等缓存互通、内容渲染干预等功能。
无需设置,无需插件,可创建基类继承管理全局WebView页面。

### 我的技术博客：https://reversescale.github.io ~欢迎来踩

![image](http://og1yl0w9z.bkt.clouddn.com/17-6-30/42455761.jpg)

## Requirements 要求
* iOS 7+
* Xcode 8+

## Usage 使用方法
### 1. RSAutoWebView 封装方法
#### 1.1 对外方法 
```objc
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

```
#### 1.2 内部方法

```objc
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

```
### 2. BaseWebViewController 基类方法
#### 2.1 基本方法
```objc
/* 
* url    请求地址
* isOpen 是否开启自动选择WebView功能
*        是: usingUIWebView 设置无效
*        否: usingUIWebView 设定是否使用 UIWebView
*/
- (void)loadWebViewWithURL:(NSString *)url autoChoose:(BOOL)isOpen ifCloseAutoChooseUsingUIWebView:(BOOL)usingUIWebView;
```
#### 2.2 增强方法
```objc
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
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!
### 你的star是我持续更新的动力!
===
## CocoaPods更新日志
* **2017.04.10(tag:0.8.0):** </br>
	 1.增加 WebViewJavascriptBridge 支持，增加JavaScript <-> Objective-C 交互;</br>
	 2.Block 方式回调封装;</br>
	 3.Cookie缓存同步机制等</br>
* **2016.09.18(tag:0.2.5)--**</br>
  1.根据系统版本自动切换WK/UI-WebView,</br>
  2.功能性封装。</br>
* **2016.08.26(tag:0.1.0)--**创建手动的 WebView 切换工具。</br>

## 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* QQ : 1129998515


