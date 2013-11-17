#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class HTTPClient, MKMapView;

@interface ReportCrisisViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *reportCrisisButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (instancetype)initWithHTTPClient:(HTTPClient *)httpClient;

@end
