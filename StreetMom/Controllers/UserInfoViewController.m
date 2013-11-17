#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action

- (IBAction)didTapContinueButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:UserEnteredUserInfoKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberTextField.text forKey:UserPhoneNumberKey];
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phoneNumberTextField becomeFirstResponder];
    return NO;
}

@end
