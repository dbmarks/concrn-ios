#import "ChooseLocationViewController.h"

@interface ChooseLocationViewController ()
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIBarButtonItem *nineOneOneButton;
@end

@implementation ChooseLocationViewController

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

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateSpan span = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake(manager.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    [self.locationManager stopUpdatingLocation];
}

@end
