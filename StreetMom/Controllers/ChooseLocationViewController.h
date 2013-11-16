#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ChooseLocationViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *reportCrisisButton;

@end
