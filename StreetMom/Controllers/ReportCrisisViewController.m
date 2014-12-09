#import "ReportCrisisViewController.h"
#import "HTTPClient.h"
#import "UpdateCrisisViewController.h"
#import "UserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SMConstants.h"


@interface ReportCrisisViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) HTTPClient *httpClient;
@property (nonatomic) UIImageView *pinImageView;
@property (nonatomic) CLGeocoder *geocoder;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *neighborhood;
@property (nonatomic) BOOL centeredOnUserLocation;

@end

@implementation ReportCrisisViewController

- (instancetype)initWithHTTPClient:(HTTPClient *)httpClient {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.geocoder = [[CLGeocoder alloc] init];
        self.httpClient = httpClient;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *imageLogo = [UIImage imageNamed:@"concrn-crop_small"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:imageLogo];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:277/255.0 green:107/255.0 blue:110/255.0 alpha:1];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.delegate = self;

    self.pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];

    self.reportCrisisButton.clipsToBounds = YES;
    self.reportCrisisButton.layer.cornerRadius = 3;

    UIBarButtonItem *nineOneOneButton = [[UIBarButtonItem alloc] initWithTitle:@"911"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(didTapCall911:)];


    self.navigationItem.rightBarButtonItem = nineOneOneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.centeredOnUserLocation = NO;

    CGPoint mapCenter = self.mapView.center;
    self.pinImageView.center = CGPointMake(mapCenter.x, mapCenter.y - CGRectGetHeight(self.pinImageView.frame)/2);
    self.spinner.center = mapCenter;

    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserEnteredUserInfoKey] == nil) {
        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
        [self presentViewController:userInfoViewController animated:NO completion:nil];
    } else {
        NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];

        [self.locationManager startUpdatingLocation];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.locationManager stopUpdatingLocation];
    [self.pinImageView removeFromSuperview];
}

#pragma mark - Actions

- (void)didTapCall911:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Tap OK to call 911"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"OK", nil] show];
}

- (IBAction)didTapReportCrisisButton:(id)sender {
    self.reportCrisisButton.enabled = NO;
    [self.spinner startAnimating];
    [self reportCrisis];
//    
//    [[[UIAlertView alloc] initWithTitle:[@"Report Received"]
//            if agency.zip_code.match:
//                                message:@"Your report has been received by the {agency.name}. Please update it with detailed information."
//                                else:
//                                message:@"There isn't a concrned agency in your area yet. Please submit a detailed report and help Concrn bring compassionate response to your community."
//                               delegate:nil
//                      acceptButtonTitle:@"OK"
//                      otherButtonTitles:nil] show];
//    
}

- (IBAction)didTapCenterLocationButton:(id)sender {
    [self centerOnUserLocation];
}

#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
    }
}

#pragma mark - <MKMapViewDelegate>

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.pinImageView.superview == nil) {
        [self.view addSubview:self.pinImageView];
    }

    CLLocationCoordinate2D centerCoordinate = self.mapView.centerCoordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            CLPlacemark *placemark = [placemarks firstObject];
                            if (placemark) {
                                self.address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                                self.neighborhood = placemark.addressDictionary[@"SubLocality"];
                                NSString *street = placemark.addressDictionary[@"Street"];
                                if (street) {
                                    self.addressLabel.text = [NSString stringWithFormat:@"%@", street];
                                } else {
                                    self.addressLabel.text = @"Address unavailable";
                                }
                            }
                        }];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.centeredOnUserLocation) {
        self.centeredOnUserLocation = YES;
        [self centerOnUserLocation];
    }
}

#pragma mark - Private

- (void)centerOnUserLocation {
    MKCoordinateSpan span = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)reportCrisis {
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:UserNameKey];
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];

    [self.httpClient reportCrisisWithName:name
                              phoneNumber:phoneNumber
                               coordinate:self.mapView.centerCoordinate
                                  address:self.address
                             neighborhood:self.neighborhood
                                onSuccess:^(NSDictionary *reportJSON) {
                                    self.reportCrisisButton.enabled = YES;
                                    [self.spinner stopAnimating];

                                    UpdateCrisisViewController *updateCrisisVC = [[UpdateCrisisViewController alloc] initWithReportData:reportJSON
                                                                                                                           httpClient:self.httpClient];
                                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:updateCrisisVC];
                                    [self presentViewController:navController animated:YES completion:nil];

                                } failure:^(NSError *error) {
                                    self.reportCrisisButton.enabled = YES;
                                    [self.spinner stopAnimating];
                                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Something went wrong. Please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil] show];
                                }];
}

@end
