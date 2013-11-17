#import "HTTPClient.h"
#import "AFNetworking.h"
#import "UserInfoViewController.h"

@interface HTTPClient ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation HTTPClient

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000"]];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)getResponderProfileForPhoneNumber:(NSString*)phoneNumber
                                onSuccess:(SuccessBlock)success
                                onFailure:(FailureBlock)failure {
    [self.manager GET:@"/responders/by_phone"
           parameters: @{@"phone": phoneNumber}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(error);
            }];
}

- (void)updateResponder:(NSDictionary*)updates
              onSuccess:(SuccessBlock)success
              onFailure:(FailureBlock)failure {
    NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];
    NSString *url = [NSString stringWithFormat:@"/responders/%@", phone];

    [self.manager PATCH:url
             parameters: @{@"responder": updates}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    success(responseObject);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(error);
                }];
}

- (void)reportCrisisWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                  coordinate:(CLLocationCoordinate2D)coordinate
                     address:(NSString *)address
                neighborhood:(NSString *)neighborhood
                   onSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"name": name,
                                         @"phone": phoneNumber,
                                         @"lat": @(coordinate.latitude),
                                         @"long": @(coordinate.longitude)
                                         }];
    if (address) {
        postParams[@"address"] = address;
    }

    if (neighborhood) {
        postParams[@"neighborhood"] = neighborhood;
    }

    [self.manager POST:@"/reports"
            parameters:@{@"report": postParams}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   success(responseObject);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   failure(error);
               }];
}

- (void)updateCrisisWithReportID:(NSInteger)reportID
                          params:(NSDictionary *)params
                       onSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    NSDictionary *postParams = @{@"report": params};
    NSString *path = [NSString stringWithFormat:@"/reports/%ld", (long)reportID];

    [self.manager PATCH:path
             parameters:postParams
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    success(responseObject);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(error);
                }];
}

@end
