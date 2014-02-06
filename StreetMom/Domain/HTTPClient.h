#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SuccessBlock)(id object);
typedef void(^FailureBlock)(NSError *error);

@interface HTTPClient : NSObject <NSURLSessionDelegate>

- (void)getResponderProfileForPhoneNumber:(NSString*)phoneNumber
                                onSuccess:(SuccessBlock)success
                                onFailure:(FailureBlock)failure;

- (void)updateResponder:(NSDictionary*)updates
              onSuccess:(SuccessBlock)success
              onFailure:(FailureBlock)failure;

- (void)reportCrisisWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                  coordinate:(CLLocationCoordinate2D)coordinate
                     address:(NSString *)address
                neighborhood:(NSString *)neighborhood
                   onSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

- (void)updateCrisisWithReportID:(NSInteger)reportID
                          params:(NSDictionary *)params
                           image:(NSData*)data
                       onSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure;

@end
