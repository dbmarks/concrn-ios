#import <UIKit/UIKit.h>

@interface UpdateCrisisViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (instancetype)initWithReportID:(NSInteger)reportID;

@end
