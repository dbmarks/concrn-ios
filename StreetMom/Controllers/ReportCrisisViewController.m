#import <MapKit/MapKit.h>
#import "ReportCrisisViewController.h"
#import "HTTPClient.h"
#import "UpdateCrisisViewController.h"
#import "UserInfoViewController.h"

@interface ReportCrisisViewController ()
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIBarButtonItem *nineOneOneButton;
@property (nonatomic) HTTPClient *httpClient;
@end

@implementation ReportCrisisViewController

- (instancetype)initWithHTTPClient:(HTTPClient *)httpClient {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.httpClient = httpClient;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Street Mom";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    self.mapView.showsPointsOfInterest = NO;

    self.nineOneOneButton = [[UIBarButtonItem alloc] initWithTitle:@"Call 911"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(didTapCall911:)];
    self.navigationItem.rightBarButtonItem = self.nineOneOneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserEnteredUserInfoKey] == nil) {
        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
        [self presentViewController:userInfoViewController animated:NO completion:nil];
    }

    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Actions

- (void)didTapCall911:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
}

- (IBAction)didTapReportCrisisButton:(id)sender {
    self.reportCrisisButton.enabled = NO;
    [self.spinner startAnimating];

    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:UserNameKey];
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];

    [self.httpClient reportCrisisWithName:name
                              phoneNumber:phoneNumber
                                 location:self.locationManager.location
                                onSuccess:^(NSDictionary *reportJSON) {
                                    self.reportCrisisButton.enabled = YES;
                                    [self.spinner stopAnimating];

                                    NSInteger reportID = [reportJSON[@"id"] integerValue];
                                    UpdateCrisisViewController *updateCrisisVC = [[UpdateCrisisViewController alloc] initWithReportID:reportID];
                                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:updateCrisisVC];
                                    [self presentViewController:navController animated:YES completion:nil];

                                } failure:^(NSError *error) {
                                    self.reportCrisisButton.enabled = YES;
                                    [self.spinner stopAnimating];
                                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Something went wrong"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil] show];
                                }];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateSpan span = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake(manager.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}

@end
