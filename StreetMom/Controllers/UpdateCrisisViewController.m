#import "UpdateCrisisViewController.h"

@interface UpdateCrisisViewController ()

@property (nonatomic, assign) NSInteger reportID;
@property (nonatomic) NSArray *cellTitles;

@end

@implementation UpdateCrisisViewController

- (instancetype)initWithReportID:(NSInteger)reportID {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.reportID = reportID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Street Mom";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.cellTitles = @[@[@"Gender", @"Age", @"Race"], @[@"Crisis Setting", @"Crisis Observation"]];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Action

- (IBAction)didTapUpdateCrisisButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 3 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Patient Description";
    } else {
        return @"Patient Nature";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    return cell;
}

@end
