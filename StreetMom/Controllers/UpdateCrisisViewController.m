#import "UpdateCrisisViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HTTPClient.h"

@interface UpdateCrisisViewController ()

@property (nonatomic, assign) NSInteger reportID;
@property (nonatomic) HTTPClient *httpClient;
@property (nonatomic) NSArray *cellTitles;
@property (nonatomic) QuickDialogController *quickDialogController;
@property (nonatomic) QRootElement *rootElement;
@property (nonatomic) QSection *patientDescriptionSection;
@property (nonatomic) QSelectSection *observationSection;
@property (nonatomic) NSArray *genderValues;
@property (nonatomic) NSArray *ageValues;
@property (nonatomic) NSArray *raceValues;
@property (nonatomic) NSArray *settingValues;
@property (nonatomic) NSArray *observationValues;

@end

@implementation UpdateCrisisViewController

- (instancetype)initWithReportID:(NSInteger)reportID
                      httpClient:(HTTPClient *)httpClient {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.reportID = reportID;
        self.httpClient = httpClient;
    }
    return self;
}

-(void)setPersonState:(id)sender {
    self.patientDescriptionSection.hidden = ![self.isPersonSwitch isOn];
        [self.quickDialogController.quickDialogTableView reloadData];
}


- (QSection*)patientDescriptionSection
{
    if (_patientDescriptionSection) return _patientDescriptionSection;
    
    
    self.genderValues = @[@"Male", @"Female", @"Other"];
    self.ageValues = @[@"Youth (0-17)", @"Young Adult (18-34)", @"Adult (35-64)", @"Senior (65+)"];
    self.raceValues = @[@"Hispanic or Latino",
                        @"American Indian or Alaska Native",
                        @"Asian",
                        @"Black or African American",
                        @"Native Hawaiian or Pacific Islander",
                        @"White",
                        @"Other/Unknown"];
    self.settingValues = @[@"Public Space", @"Workplace", @"School", @"Home", @"Other"];

    
    QSection *patientDescriptionSection = [[QSection alloc] initWithTitle:@"Description"];
    
    QRadioElement *genderElement = [[QRadioElement alloc] initWithKey:@"gender"];
    genderElement.selected = -1;
    genderElement.title = @"Gender";
    genderElement.items = self.genderValues;
    
    QRadioElement *ageElement = [[QRadioElement alloc] initWithKey:@"age"];
    ageElement.selected = -1;
    ageElement.title = @"Age Group";
    ageElement.items = self.ageValues;
    
    QRadioElement *raceElement = [[QRadioElement alloc] initWithKey:@"race"];
    raceElement.selected = -1;
    raceElement.title = @"Race/Ethniticy";
    raceElement.items = self.raceValues;
    
    QRadioElement *settingElement = [[QRadioElement alloc] initWithKey:@"setting"];
    settingElement.selected = -1;
    settingElement.title = @"Setting";
    settingElement.items = self.settingValues;
    
    
    [patientDescriptionSection addElement:genderElement];
    [patientDescriptionSection addElement:ageElement];
    [patientDescriptionSection addElement:raceElement];
    [patientDescriptionSection addElement:settingElement];
    patientDescriptionSection.hidden = YES;
    
    return _patientDescriptionSection = patientDescriptionSection;
}

- (QSection*)observationSection
{
    if (_observationSection) return _observationSection;
    
    self.observationValues = @[@"At risk of harm", @"Under the influence", @"Anxious", @"Depressed", @"Aggravated", @"Threatening"];

    _observationSection = [[QSelectSection alloc] init];
    _observationSection.title = @"Incident Observations: The person is...";
    _observationSection.multipleAllowed = YES;
    _observationSection.items = self.observationValues;
    return _observationSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Create Report";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:277/255.0 green:107/255.0 blue:110/255.0 alpha:1];

    self.updateCrisisButton.clipsToBounds = YES;
    self.updateCrisisButton.layer.cornerRadius = 3;
    
    [self.isPersonSwitch addTarget:self action:@selector(setPersonState:) forControlEvents:UIControlEventValueChanged];

    self.rootElement = [[QRootElement alloc] init];
 
    
    QSection *additionalDescriptionSection = [[QSection alloc] initWithTitle:@"Additional Description..."];
    QEntryElement *additionalDescription = [[QEntryElement alloc] initWithKey:@"nature"];
    additionalDescription.placeholder = @"Add important information here.";
    QImageElement *imageElement = [[QImageElement alloc] initWithKey:@"image"];
    imageElement.title = @"Incident Picture";
    imageElement.source = UIImagePickerControllerSourceTypeCamera;
    imageElement.imageMaxLength = 640;
    
    [additionalDescriptionSection addElement:imageElement];
    
    [additionalDescriptionSection addElement:additionalDescription];
    [self.rootElement addSection:self.patientDescriptionSection];
    [self.rootElement addSection:self.observationSection];
    [self.rootElement addSection:additionalDescriptionSection];
    
    self.quickDialogController = [QuickDialogController controllerForRoot:self.rootElement];
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
    [[[UIAlertView alloc] initWithTitle:@"Tap OK to call 911"
                                message:nil
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"OK", nil] show];
}

- (IBAction)didTapUpdateCrisisButton:(id)sender {
    self.updateCrisisButton.enabled = NO;
    [self.spinner startAnimating];
    [self updateCrisis];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://911"]];
    }
}

#pragma mark - Private

- (void)updateCrisis {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.rootElement fetchValueIntoObject:params];
    NSData* imageData;
    if (params[@"image"]) {
        imageData = UIImageJPEGRepresentation(params[@"image"], 0.75);
        [params removeObjectForKey:@"image"];
    }

    if ([self.isPersonSwitch isOn]) {
        params[@"gender"] = self.genderValues[[params[@"gender"] intValue]];
        params[@"age"] = self.ageValues[[params[@"age"] intValue]];
        params[@"race"] = self.raceValues[[params[@"race"] intValue]];
        params[@"setting"] = self.settingValues[[params[@"setting"] intValue]];
        params[@"observations"] = [self.observationSection.selectedItems componentsJoinedByString:@", "];
    }

    [self.httpClient updateCrisisWithReportID:self.reportID
                                       params:params
                                        image:imageData
                                    onSuccess:^(id object) {
                                        self.updateCrisisButton.enabled = YES;
                                        [self.spinner stopAnimating];

                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    } failure:^(NSError *error) {
                                        self.updateCrisisButton.enabled = YES;
                                        [self.spinner stopAnimating];

                                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Something went wrong. Please try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil] show];
                                    }];
}

@end
