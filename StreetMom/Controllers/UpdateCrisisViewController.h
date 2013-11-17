#import <UIKit/UIKit.h>

@interface UpdateCrisisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *formContainerView;

- (instancetype)initWithReportID:(NSInteger)reportID;

@end
