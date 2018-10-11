//
//  TableViewController.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/7/6.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "TableViewController.h"
#import <SVProgressHUD.h>

/// AutoWebView
#import "TestWebViewController.h"
#import "RSWKCookieSyncManager.h"

static NSString *testAliYunURL = @"https://pan.baidu.com";
static NSString *testTencentURL = @"http://mc.vip.qq.com/demo/indexv3?offline=1";

@interface TableViewController ()
@property (nonatomic, strong)TestWebViewController *webView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/// 跳转 AutoWebView 页面
- (void)openAutoWebView {
    self.webView = [self createAutoWebViewWithURL:testAliYunURL isAutoChoose:YES];
    self.webView.title = @"WebView";
    [self.navigationController pushViewController:self.webView animated:YES];
}

/// 清理缓存
- (void)clearCache {
    [self.webView clearCache];
    [SVProgressHUD showSuccessWithStatus:@"清理缓存成功"];
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self openAutoWebView];
            break;
        default:
            [self clearCache];
            break;
    }
}

#pragma mark - create AutoWebView & Delegate
- (TestWebViewController *)createAutoWebViewWithURL:(NSString *)url isAutoChoose:(BOOL)isAuto {
    TestWebViewController *webView = [TestWebViewController new];
    [webView loadWebViewWithURL:url];
    self.webView.finishLoadBlock = ^(id webView) {
        NSLog(@"finishLoadBlock");
        //创建设置cookie单例
        RSWKCookieSyncManager *cookiesManager = [RSWKCookieSyncManager sharedWKCookieSyncManager];
        //搬移cookies
        [cookiesManager setCookie];
        NSLog(@"cookiesManager:%@ \n", cookiesManager.processPool);
    };
    [self.webView JSCallHandlerWithFuncName:@"testJavascriptHandler" Data:@{ @"greetingFromObjC": @"Hi there, JS!" }];
    self.webView.javaScriptCallReturnBlock = ^(id response) {
        NSLog(@"response:%@", response);
    };
    
    return webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
