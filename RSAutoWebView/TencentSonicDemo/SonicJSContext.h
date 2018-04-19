#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SonicWebViewController.h"

@protocol SonicJSExport <JSExport>

JSExportAs(getDiffData,
- (void)getDiffData:(NSDictionary *)option withCallBack:(JSValue *)jscallback
);

JSExportAs(getPerformance,
- (NSString *)getPerformance:(NSDictionary *)option withCallBack:(JSValue *)jscallback
);

@end

@interface SonicJSContext : NSObject<SonicJSExport>

@property (nonatomic,weak)SonicWebViewController *owner;

- (void)getDiffData:(NSDictionary *)option withCallBack:(JSValue *)jscallback;

- (NSString *)getPerformance:(NSDictionary *)option withCallBack:(JSValue *)jscallback;

@end
