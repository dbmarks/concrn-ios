#import "ReportCrisisViewController.h"
#import "HTTPClient.h"
#import "UpdateCrisisViewController.h"
#import "UserInfoViewController.h"
#import "ProfileViewController.h"

@interface ReportCrisisViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) HTTPClient *httpClient;
@property (nonatomic) UIImageView *pinImageView;

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
    self.mapView.delegate = self;

    self.pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];

    UIBarButtonItem *nineOneOneButton = [[UIBarButtonItem alloc] initWithTitle:@"911"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(didTapCall911:)];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserAvailabilityKey object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self updateProfile:note.userInfo];
        
    }];

    
    self.navigationItem.rightBarButtonItem = nineOneOneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGPoint mapCenter = self.mapView.center;
    self.pinImageView.center = CGPointMake(mapCenter.x, mapCenter.y - CGRectGetHeight(self.pinImageView.frame)/2);
    self.spinner.center = mapCenter;

    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserEnteredUserInfoKey] == nil) {
        UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
        [self presentViewController:userInfoViewController animated:NO completion:nil];
    } else {
        NSString* phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];
        
        [self.httpClient getResponderProfileForPhoneNumber:phoneNumber onSuccess:^(id object) {
            NSDictionary* responder = object;
            [self setResponderProfile: responder];
            

        } onFailure:^(NSError *error) {
            
            
        }];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)updateProfile:(NSDictionary*)updates {
    [self.httpClient updateResponder:updates onSuccess:^(id object) {
        [self setResponderProfile: object];
    } onFailure:^(NSError *error) {
        
        
    }];
    
}

- (void)setResponderProfile:(NSDictionary*)profile {
    NSString* title = [profile[@"availability"] isEqualToString:@"available"] ? @"Available" : @"Unavailable";
    [[NSUserDefaults standardUserDefaults] setValue: profile[@"availability"] forKey:UserAvailabilityKey];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: title
                                                                             style: UIBarButtonItemStylePlain
                                                                            target: self
                                                                            action: @selector(didTapAvailable:)];
}


- (void)didTapAvailable:(id)sender {
    ProfileViewController* profileViewController = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.locationManager stopUpdatingLocation];
    [self.pinImageView removeFromSuperview];
}

#pragma mark - Actions

- (void)didTapCall911:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
}

- (IBAction)didTapReportCrisisButton:(id)sender {
    self.reportCrisisButton.enabled = NO;
    [self.spinner startAnimating];
    [self reportCrisis];
}

#pragma mark - <MKMapViewDelegate>

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.pinImageView.superview == nil) {
        [self.view addSubview:self.pinImageView];
    }
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateSpan span = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake(manager.location.coordinate, span);
    [self.httpClient getCrisisListAroundCoordinate:manager.location.coordinate onSuccess:^(NSArray* crisisList) {
        
    } onFailure:^(NSError *error) {
        
        
    }];
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Private

- (void)reportCrisis {
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:UserNameKey];
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:UserPhoneNumberKey];

    [self.httpClient reportCrisisWithName:name
                              phoneNumber:phoneNumber
                               coordinate:self.mapView.centerCoordinate
                                onSuccess:^(NSDictionary *reportJSON) {
                                    self.reportCrisisButton.enabled = YES;
                                    [self.spinner stopAnimating];

                                    NSInteger reportID = [reportJSON[@"id"] integerValue];
                                    UpdateCrisisViewController *updateCrisisVC = [[UpdateCrisisViewController alloc] initWithReportID:reportID
                                                                                                                           httpClient:self.httpClient];
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

@end
