#import "HTTPClient.h"
#import "AFNetworking.h"

@interface HTTPClient ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation HTTPClient

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://streetmom.herokuapp.com"]];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)reportCrisisWithName:(NSString *)name
                 phoneNumber:(NSString *)phoneNumber
                  coordinate:(CLLocationCoordinate2D)coordinate
                   onSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure {
    NSDictionary *postParams = @{@"report": @{@"name": name,
                                              @"phone": phoneNumber,
                                              @"lat": @(coordinate.latitude),
                                              @"long": @(coordinate.longitude)}};
    [self.manager POST:@"/reports"
            parameters:postParams
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

    [self.manager PUT:path
           parameters:postParams
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success(responseObject);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

@end
