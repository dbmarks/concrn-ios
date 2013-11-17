#import "UpdateCrisisViewController.h"
#import <QuickDialog/QuickDialog.h>

@interface UpdateCrisisViewController ()

@property (nonatomic, assign) NSInteger reportID;
@property (nonatomic) NSArray *cellTitles;
@property (nonatomic) QuickDialogController *quickDialogController;

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

    QRootElement *rootElement = [[QRootElement alloc] init];

    QRadioElement *genderElement = [[QRadioElement alloc] initWithKey:@"gender"];
    genderElement.selected = -1;
    genderElement.title = @"Gender";
    genderElement.items = @[@"Male", @"Female", @"Other"];

    QRadioElement *ageElement = [[QRadioElement alloc] initWithKey:@"ageGroup"];
    ageElement.selected = -1;
    ageElement.title = @"Age Groups";
    ageElement.items = @[@"Youth (0-17)", @"Young Adult (18-34)", @"Adult (35-64)", @"Senior (65+)"];

    QRadioElement *raceElement = [[QRadioElement alloc] initWithKey:@"race"];
    raceElement.selected = -1;
    raceElement.title = @"Race/Ethniticy";
    raceElement.items = @[@"Hispanic or Latino",
                          @"American Indian or Alaska Native",
                          @"Asian",
                          @"Black or African America",
                          @"Native Hawaiian or Pacific Islander",
                          @"White",
                          @"Other/Unknown"];

    QRadioElement *settingElement = [[QRadioElement alloc] initWithKey:@"setting"];
    settingElement.selected = -1;
    settingElement.title = @"Crisis Setting";
    settingElement.items = @[@"Homeless", @"Workplace", @"School", @"Home", @"Other"];

    QSection *patientDescriptionSection = [[QSection alloc] initWithTitle:@"Patient Description"];
    [patientDescriptionSection addElement:genderElement];
    [patientDescriptionSection addElement:ageElement];
    [patientDescriptionSection addElement:raceElement];
    [patientDescriptionSection addElement:settingElement];

    QSelectSection *observationSection = [[QSelectSection alloc] init];
    observationSection.title = @"Crisis Observations: Is the patient...";
    observationSection.multipleAllowed = YES;
    observationSection.items = @[@"At risk of harm", @"Under the influence", @"Anxious", @"Depressed", @"Aggravated", @"Threatening"];

    QEntryElement *additionalDescription = [[QEntryElement alloc] initWithKey:@"description"];
    additionalDescription.placeholder = @"Write important information here.";

    QSection *additionalDescriptionSection = [[QSection alloc] initWithTitle:@"Additional Description..."];
    [additionalDescriptionSection addElement:additionalDescription];

    [rootElement addSection:patientDescriptionSection];
    [rootElement addSection:observationSection];
    [rootElement addSection:additionalDescriptionSection];

    self.quickDialogController = [QuickDialogController controllerForRoot:rootElement];
    self.quickDialogController.view.backgroundColor = [UIColor clearColor];
    self.quickDialogController.quickDialogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addChildViewController:self.quickDialogController];
    [self.formContainerView addSubview:self.quickDialogController.view];
    [self.quickDialogController didMoveToParentViewController:self];

    UIBarButtonItem *nineOneOneButton = [[UIBarButtonItem alloc] initWithTitle:@"911"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(didTapCall911:)];
    self.navigationItem.rightBarButtonItem = nineOneOneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.quickDialogController.view.frame = self.formContainerView.bounds;
}

#pragma mark - Action

- (void)didTapCall911:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
}

- (IBAction)didTapUpdateCrisisButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
