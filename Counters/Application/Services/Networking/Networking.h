
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Base URL

extern NSString * const baseURL;

// MARK: - Handlers
typedef void (^DataCompletionHandler) (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

// MARK: - Error
extern NSErrorDomain const CountersErrorDomain;

typedef NS_ENUM(NSInteger, CountersErrorCode) {
    CountersErrorCodeNoData = -777
};

// MARK: - Networking
@interface Networking : NSObject
-(instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionTask *)dataRequestURL:(NSURL *)url
                      HTTPMethod:(NSString *)method
                      parameters:(NSDictionary<NSString*, NSString*>*)parameters
                   completionHandler:(DataCompletionHandler)completion;

- (NSError *)error:(CountersErrorCode)code;
@end

NS_ASSUME_NONNULL_END
