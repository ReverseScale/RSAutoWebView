#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Sonic.h"

@interface SonicWebViewController : UIViewController<SonicSessionDelegate,UIWebViewDelegate>
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,assign)long long clickTime;
@property (nonatomic,strong)JSContext *jscontext;

- (instancetype)initWithUrl:(NSString *)aUrl useSonicMode:(BOOL)isSonic;

@end
