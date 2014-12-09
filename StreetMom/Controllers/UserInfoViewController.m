#import "UserInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface UserInfoViewController (){
    UITextField *activeField;
}

-(void)dismissKeyboard;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.continueButton.clipsToBounds = YES;
    self.continueButton.layer.cornerRadius = 3;
    //dismisses the keyboard on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - Action

- (IBAction)didTapContinueButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:UserEnteredUserInfoKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberTextField.text forKey:UserPhoneNumberKey];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UITextFieldDelegate>

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //calls super of textFieldShouldReturn which is in TPKeyboardAvoidingScrollView
    [self.scrollView textFieldShouldReturn:textField];
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO; 
}


@end
