#import <UIKit/UIKit.h>

@class HTTPClient;

@interface UpdateCrisisViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UIButton *updateCrisisButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (instancetype)initWithReportID:(NSInteger)reportID httpClient:(HTTPClient *)httpClient;

@end
