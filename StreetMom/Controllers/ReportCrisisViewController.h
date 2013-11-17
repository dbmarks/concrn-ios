#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class HTTPClient, MKMapView;

@interface ReportCrisisViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *reportCrisisButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *centerLocationButton;

- (instancetype)initWithHTTPClient:(HTTPClient *)httpClient;

@end
