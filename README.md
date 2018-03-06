# RSAutoWebView


![image](http://og1yl0w9z.bkt.clouddn.com/17-6-30/79072301.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-512K-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

For different versions of iOS WebView fragmentation, sorting package, the main function is based on the system version automatically select UI / WK-WebView to load.

Package function:

* Block Method JavaScript <-> Objective-C Interaction.
* Swipe to the top function
* Extended script
* Cookies for WKWebView and UIWebView cache interoperability
* Content rendering interventions
* New Features: Join Tencent VAS · Sonic technology, a framework that claims WebView can be seconds off.

* No need to set up, without plug-ins, to create a base class Inheritance Management Global WebView page. *

## 🎨 What does the test UI look like?
| Name |1. List Page |2.AutoWebView Load Page |3.VAS · Sonic Load Page|4. Clear Cache Page|
| ------------- | ------------- | ------------- | ------------- | ------------- |
| Screenshots | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/29345693.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/12523713.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/3035790.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/2650558.jpg) |
| Description | Main.storyboard | Auto-adapted AutoWebView Framework | Tencent's Seconds WebView Framework | Clear Cache Operations |

## 🚀 Advantage
* 1. Less documents, code concise
* 2. According to the system version automatically choose to use UI / WK WebView, enhance the user experience
* 3. Support both WebView Delegate system callbacks and WebView JavaScriptBridge library callbacks
* 4. The structure of the excellent structure, centralized management through the base class to load the page
* 5 have a higher custom

## 🤖 Requirements 
* iOS 7+
* Xcode 8+

## 🎯 Usage Usage
### 1. RSAutoWebView wrapper method
#### 1.1 Foreign methods
```objc
//Use UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

//Will be transferred WKUIDelegate, WKNavigationDelegate unimplemented callback.
@property (weak, nonatomic) id<RSAutoWebViewDelegate> delegate;

//Internal use of webView
@property (nonatomic, readonly) id realWebView;
//Whether you are using UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
//Estimate the progress of webpage loading
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

//Only ios7 above UIWebView can be obtained, WKWebView use the following method.
@property (nonatomic, readonly) JSContext* jsContext;
//WKWebView way to interact with the web page.
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

//back layer
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

```
#### 1.2 internal methods

```objc
//---- UI or WK API
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
// Clean up the cache
- (void)clearCache;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;
// It is not recommended to use this method because it will wait for the execution of the webView internally
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

// Whether to scale the page by view size defaults to YES
@property (nonatomic) BOOL scalesPageToFit;

```
### 2. BaseWebViewController base class method
#### 2.1 The basic method
```objc
/ *
* url request address
* isOpen Whether to enable automatic selection of WebView features
* Is: usingUIWebView setting is invalid
* No: usingUIWebView set whether to use UIWebView
* /
- (void)loadWebViewWithURL:(NSString *)url autoChoose:(BOOL)isOpen ifCloseAutoChooseUsingUIWebView:(BOOL)usingUIWebView;
```
#### 2.2 Enhance the method
```objc
#pragma mark - Parameters, methods
// URL address
@property (nonatomic,copy) NSString *url;

// Load URL method
- (void)reloadRequest:(NSString *)url;

// Back to top
- (void)scrollToTop;

// Image adapted to JavaScript injection
- (void)imgAutoFit;

// Collapse the keyboard method in WebView
- (void)packupKeyboard;

// Return method
- (void)webViewBackAction:(UIBarButtonItem *)sender;

// Clean up the cache
- (void)clearCache;


#pragma mark - Proxy method
/**
*  Unified wk ui loading state proxy method, combo
*/
@property (nonatomic,copy) void(^startLoadBlock)(id webView);
@property (nonatomic,copy) void(^finishLoadBlock)(id webView);
@property (nonatomic,copy) void(^failLoadBlock)(id webView, NSError *error);

#pragma mark - WebViewJavascriptBridge JS interaction method
// callHandler [OC news to JS]
- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData;
@property (nonatomic,copy) void(^javaScriptCallReturnBlock)(id response);

// registerHandler [OC receive JS news]
- (void)JSRegisterHandlerWithFuncName:(NSString *)name;
@property (nonatomic,copy) void(^javaScriptRegisterReturnBlock)(id response, WVJBResponseCallback responseCallback);
```

### 3. Tencent VAS · Sonic seconds to open the WebView framework
#### 3.1 Introduction
VasSonic named after the Sony animated image sound speed kid, is Tencent QQ membership VAS team developed a lightweight high-performance Hybrid framework, focusing on improving the first page of the page loading speed, the perfect support for static straight out of the page and the dynamic straight out of the page, Compatible with offline packages and other programs. Currently QQ members, QQ shopping, QQ wallet, penguins and other businesses have been using e-sports, the average daily PV in more than 120 million, and this number is still rapidly growing.

![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/37643772.jpg)

The first time you access VasSonic, you can request the page resources in parallel while initializing your app and have the ability to load side-edges. When not opening for the first time, the app can quickly load the last time the page resource was dynamically cached in the local page, and then dynamically refresh the page. Tencent mobile QQ through the VasSonic framework makes the first page of the screen consumes less than 1S average time below.

Official open source address: https://github.com/Tencent/vassonic

#### 3.2 The basic method
Quote the header file

```
// Tencent VAS framework
#import "Sonic.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"
```

Use the jump method
```
SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:testTencentURL useSonicMode:YES];
webVC.title = @"VAS·Sonic";
[self.navigationController pushViewController:webVC animated:YES];
```

Simple to use, efficient, process-safe ~~~ If you have better suggestions, I hope have enlighten me!
### Your star is my motivation to keep updating!

## 📝 CocoaPods update log
* ** 2017.08.22 (tag: 0.9.0): ** </ br>
1. Sort open base class method, optimize the realization of the function; </ br>
2. Join Tencent open source VasSonic second open WebView framework. </ br>
* ** 2017.04.10 (tag: 0.8.0): ** </ br>
1. Add WebViewJavascriptBridge support, add JavaScript <-> Objective-C interaction; </ br>
2.Block callback package; </ br>
3.Cookie cache synchronization mechanism. </ br>
* ** 2016.09.18 (tag: 0.2.5): ** </ br>
   1. Automatically switch WK / UI-WebView by system version, </ br>
   2 functional package. </ br>
* ** 2016.08.26 (tag: 0.1.0): ** </ br>
   1. Create a manual WebView switch tool. </ br>

## ⚖ License License
RSAutoWebView uses a MIT license, as detailed in the LICENSE file.


## 😬 Contact :
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io


----
### 中文说明
针对 iOS 不同版本下 WebView 的碎片化，进行整理封装，主要功能是根据系统版本自动选择 UI/WK-WebView 进行加载。

封装功能：

* Block 方式 JavaScript <-> Objective-C 的交互。
* 滑动至顶部功能
* 扩展脚本
* 针对 WKWebView 和 UIWebView 的 Cookie 等缓存互通
* 内容渲染干预等
* 新增特征：加入腾讯 VAS·Sonic 技术，一种声称可以秒开 WebView 的框架。

*无需设置,无需插件,可创建基类继承管理全局WebView页面。*

## 🎨 测试 UI 样式

| 名称 |1.列表页 |2.AutoWebView 加载页 |3.VAS·Sonic 加载页|4.清除缓存页|
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/29345693.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/12523713.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/3035790.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/2650558.jpg) |
| 描述 | 通过 Main.storyboard 创建 | 自动适配的 AutoWebView 框架 | 腾讯的秒开 WebView 框架 | 清除缓存操作 |

## 🚀 框架的优势
* 1.文件少，代码简洁
* 2.根据系统版本自动选择使用 UI/WK WebView，提升用户体验
* 3.同时支持 WebView Delegate 系统回调和 WebViewJavascriptBridge 库回调
* 4.结构架构优良，可通过基类集中管理加载页面
* 5.具备较高自定义性

## 🤖 要求
* iOS 7+
* Xcode 8+

## 🎯 使用方法
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

### 3. 腾讯 VAS·Sonic 秒开 WebView框架
#### 3.1 简介
VasSonic 取名于索尼动画形象音速小子，是腾讯 QQ 会员 VAS 团队研发的一个轻量级的高性能的 Hybrid 框架，专注于提升页面首屏加载速度，完美支持静态直出页面和动态直出页面，兼容离线包等方案。目前 QQ 会员、QQ 购物、QQ 钱包、企鹅电竞等业务已经在使用，平均日均 PV 在 1.2 亿以上，并且这个数字还在快速增长。

![](http://og1yl0w9z.bkt.clouddn.com/17-8-22/37643772.jpg)

接入 VasSonic 后首次打开可以在初始化 APP 的时候并行请求页面资源，并且具备边加载边渲染的能力。非首次打开时，APP 可以快速加载上次打开动态缓存在本地的页面资源，然后动态刷新页面。腾讯手机 QQ 通过 VasSonic 框架使得页面首屏耗时平均低于 1S 以下。

官方开源地址：https://github.com/Tencent/vassonic

#### 3.2 基本方法
引用头文件

```
// 腾讯VAS框架
#import "Sonic.h"
#import "SonicWebViewController.h"
#import "SonicOfflineCacheConnection.h"
```

使用跳转方法
```
SonicWebViewController *webVC = [[SonicWebViewController alloc]initWithUrl:testTencentURL useSonicMode:YES];
webVC.title = @"VAS·Sonic";
[self.navigationController pushViewController:webVC animated:YES];
```

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!
### 你的star是我持续更新的动力!

## 📝 CocoaPods更新日志
* **2017.08.22(tag:0.9.0):** </br>
	 1.整理基类开放方法，优化实现功能;</br>
	 2.加入腾讯开源的 VasSonic 秒开 WebView 框架。</br>
* **2017.04.10(tag:0.8.0):** </br>
	 1.增加 WebViewJavascriptBridge 支持，增加JavaScript <-> Objective-C 交互;</br>
	 2.Block 方式回调封装;</br>
	 3.Cookie 缓存同步机制等。</br>
* **2016.09.18(tag:0.2.5):**</br>
  1.根据系统版本自动切换WK/UI-WebView,</br>
  2.功能性封装。</br>
* **2016.08.26(tag:0.1.0):**</br>
  1.创建手动的 WebView 切换工具。</br>

## ⚖ 许可证
RSAutoWebView 使用 MIT 许可证，详情见 LICENSE 文件。


## 😬 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io


