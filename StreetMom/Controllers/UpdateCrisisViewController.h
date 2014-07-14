#import <UIKit/UIKit.h>
#import <QuickDialog/QuickDialog.h>
#import <QuickDialog/QuickDialogController+Animations.h>
@class HTTPClient;

@interface UpdateCrisisViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *formContainerView;
@property (weak, nonatomic) IBOutlet UIButton *updateCrisisButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISwitch *isPersonSwitch;

- (instancetype)initWithReportID:(NSInteger)reportID httpClient:(HTTPClient *)httpClient;

@end
