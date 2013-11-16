#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id object);
typedef void(^FailureBlock)(NSError *error);

@class CLLocation;

@interface HTTPClient : NSObject <NSURLSessionDelegate>

- (void)reportCrisisWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                    location:(CLLocation *)location
                   onSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

@end
