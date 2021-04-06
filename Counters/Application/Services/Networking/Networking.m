
#import "Networking.h"

// MARK: - Base URL
NSString *const baseURL = @"http://127.0.0.1:3000";

// MARK: - Error
NSErrorDomain const CountersErrorDomain = @"counters.network.error.domain";

// MARK: - Headers
NSString * const ContentType = @"Content-Type";
NSString * const JSONContentType = @"application/json";

@interface Networking ()
@property (nonatomic, strong) NSURLSession *client;
@end

@implementation Networking

- (instancetype)init
{
    self = [super init];
    if (self) {
        __auto_type *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _client = [NSURLSession sessionWithConfiguration: configuration];
    }
    return self;
}

-(instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (self) {
        _client = [NSURLSession sessionWithConfiguration: configuration];
    }
    
    return self;
}

- (NSURLSessionTask *)dataRequestURL:(NSURL *)url
                      HTTPMethod:(NSString *)method
                      parameters:(NSDictionary<NSString*, NSString*>*)parameters
               completionHandler:(DataCompletionHandler)completion
{
    __auto_type *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    if ([method isEqual: @"GET"]) {
        request.URL = [self componentsFor:url parameters:parameters].URL;
    } else if (JSONData) {
        request.HTTPBody = JSONData;
        [request setValue:JSONContentType forHTTPHeaderField:ContentType];
    }
    return [self.client dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(data, response, error);
    }];
}

- (NSURLComponents *)componentsFor:(NSURL *)url
                        parameters:(NSDictionary<NSString*, NSString*>*)parameters
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in parameters) {
        [queryItems addObject: [NSURLQueryItem queryItemWithName:key value:parameters[key]]];
    }
    components.queryItems = queryItems;
    
    return components;
}


- (NSError *)error:(CountersErrorCode)code
{
    return [NSError errorWithDomain:CountersErrorDomain
                               code:code
                           userInfo:nil];
}

@end
