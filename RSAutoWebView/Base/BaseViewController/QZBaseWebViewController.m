//
//  QZBaseWebViewController.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/6/15.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "QZBaseWebViewController.h"
// 宏
#define Version [[UIDevice currentDevice].systemVersion floatValue]

@interface QZBaseWebViewController ()
// 声明 WebViewJavascriptBridge 对象为属性
@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong)RSAutoWebView *webView;
@end

@implementation QZBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadWebViewWithURL:(NSString *)url {
    [self chooseWebViewUsingUIWebView:[self isSupportWKWebView]];
    [self reloadRequest:url];
}

- (void)chooseWebViewUsingUIWebView:(BOOL)isUsingUIWebView {
    self.webView = [[RSAutoWebView alloc] initWithFrame:self.view.bounds usingUIWebView:isUsingUIWebView];
    [self setupWebViewJavascriptBridge];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)reloadRequest:(NSString *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


// AutoWebView JavascriptBridge Delegate
- (void)setupWebViewJavascriptBridge {
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView.realWebView];
    [_bridge setWebViewDelegate:self];
}

- (void)JSRegisterHandlerWithFuncName:(NSString *)name {
    [_bridge registerHandler:name handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
        self.javaScriptRegisterReturnBlock(data, responseCallback);
    }];
}

- (void)JSCallHandlerWithFuncName:(NSString *)name Data:(NSDictionary *)dicData {
    [_bridge callHandler:name data:dicData responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
        self.javaScriptCallReturnBlock(response);
    }];
}


// AutoWebView WebView Delegate
- (void)webViewDidStartLoad:(RSAutoWebView*)webView {
    if (self.startLoadBlock) {
        self.startLoadBlock(_webView);
    }
}

- (void)webViewDidFinishLoad:(RSAutoWebView*)webView {
    if (self.finishLoadBlock) {
        self.finishLoadBlock(_webView);
    }
}

- (void)webView:(RSAutoWebView*)webView didFailLoadWithError:(NSError*)error {
    NSLog(@"%@",error);
    if (self.failLoadBlock) {
        self.failLoadBlock(_webView, error);
    }
}


#pragma mark - 返回顶端
- (void)scrollToTop {
    UIScrollView *scrollView;
    if (_webView) {
        scrollView = (UIScrollView *)[[_webView subviews] objectAtIndex:0];
    } else {
        scrollView = (UIScrollView *)[[_webView subviews] objectAtIndex:0];
    }
    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (BOOL)isSupportWKWebView {
   return Version >= 8.0 ? NO : YES;
}

// 图片适应 JavaScript 注入
- (void)imgAutoFit {
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [_webView evaluateJavaScript:js completionHandler:nil];
    [_webView evaluateJavaScript:@"imgAutoFit()" completionHandler:nil];
}

/// WebView中收起键盘方法
- (void)packupKeyboard {
    [_webView evaluateJavaScript:@"document.activeElement.blur()" completionHandler:nil];
}

/// 清理缓存
- (void)clearCache {
    [self.webView clearCache];
}

/// 返回方法
- (void)webViewBackAction:(UIBarButtonItem *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
