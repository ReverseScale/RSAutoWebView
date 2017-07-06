//
//  TableViewController.m
//  RSAutoWebView
//
//  Created by WhatsXie on 2017/7/6.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "TableViewController.h"
#import "QZBaseWebViewController.h"
#import "RSWKCookieSyncManager.h"

@interface TableViewController ()
@property (nonatomic, strong)QZBaseWebViewController *webView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
// 跳转WebView
- (void)gotoWebView {
    self.webView = [QZBaseWebViewController new];
    
    [self.webView loadWebViewWithURL:@"https://pan.baidu.com" autoChoose:NO ifCloseAutoChooseUsingUIWebView:YES];
    
    // 1.WebView代理
    self.webView.finishLoadBlock = ^(id webView) {
        NSLog(@"finishLoadBlock");
        //创建设置cookie单例
        RSWKCookieSyncManager *cookiesManager = [RSWKCookieSyncManager sharedWKCookieSyncManager];
        //搬移cookies
        [cookiesManager setCookie];
        
        NSLog(@"cookiesManager:%@ \n", cookiesManager.processPool);
    };
    
    // 2.JS交互
    [self.webView JSCallHandlerWithFuncName:@"testJavascriptHandler" Data:@{ @"greetingFromObjC": @"Hi there, JS!" }];
    self.webView.javaScriptCallReturnBlock = ^(id response) {
        NSLog(@"response:%@", response);
    };
    
    [self.navigationController pushViewController:self.webView animated:YES];
}
// 清理缓存
- (void)clear {
    [self.webView clearCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self gotoWebView];
            break;
        default:
            [self clear];
            break;
    }
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
