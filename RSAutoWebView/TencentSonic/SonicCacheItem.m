#import "SonicCacheItem.h"
#import "SonicCache.h"
#import "SonicConstants.h"
#import "SonicUitil.h"


@implementation SonicCacheItem

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithSessionID:(NSString *)aSessionID
{
    if (self = [super init]) {
        
        _sessionID = aSessionID;
                
    }
    return self;
}

- (void)dealloc
{
    if (_cacheResponseHeaders) {
        _cacheResponseHeaders = nil;
    }
    if (self.config) {
        self.config = nil;
    }
    if (self.htmlData) {
        self.htmlData = nil;
    }
    if (self.templateString) {
        self.templateString = nil;
    }
    if (self.diffData) {
        self.diffData = nil;
    }
    if (self.dynamicData) {
        self.dynamicData = nil;
    }
}

- (BOOL)hasLocalCache
{
    return self.htmlData.length > 0? NO:YES;
}

- (void)setConfig:(NSDictionary *)config
{
    if (_config) {
        _config = nil;
    }
    _config = config;
    
    NSString *csp = _config[kSonicCSP];
    if (csp.length > 0) {
        if (_cacheResponseHeaders) {
            _cacheResponseHeaders = nil;
        }
        _cacheResponseHeaders = @{SonicHeaderKeyCSPHeader:csp};
    }
}

- (NSString *)lastRefreshTime
{
    if (!self.config) {
        return nil;
    }
    return self.config[kSonicLocalRefreshTime];
}

@end
