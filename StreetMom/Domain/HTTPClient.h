#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SuccessBlock)(id object);
typedef void(^FailureBlock)(NSError *error);

@interface HTTPClient : NSObject <NSURLSessionDelegate>

- (void)reportCrisisWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                  coordinate:(CLLocationCoordinate2D)coordinate
                   onSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

- (void)getResponderProfileForPhoneNumber:(NSString*)phoneNumber
                                onSuccess:(SuccessBlock)success
                                onFailure:(FailureBlock)failure;
- (void)updateResponder:(NSDictionary*)updates onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure;

- (void)updateCrisisWithReportID:(NSInteger)reportID
                          params:(NSDictionary *)params
                       onSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure;

@end
