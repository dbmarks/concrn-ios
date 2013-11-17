#import <UIKit/UIKit.h>

static NSString *UserEnteredUserInfoKey = @"UserEnteredUserInfo";
static NSString *UserNameKey = @"UserName";
static NSString *UserPhoneNumberKey = @"UserPhoneNumber";
static NSString *UserAvailabilityKey = @"UserAvailability";

@interface UserInfoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
