#import "ChooseLocationViewController.h"
#import <MapKit/MapKit.h>

@interface ChooseLocationViewController ()
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    self.mapView = [[MKMapView alloc] init];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = NO;
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.locationManager startUpdatingLocation];

    self.mapView.frame = self.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.locationManager stopUpdatingLocation];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    MKCoordinateSpan span = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake(manager.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

@end
