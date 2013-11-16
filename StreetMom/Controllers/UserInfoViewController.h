#import <UIKit/UIKit.h>

static NSString *UserEnteredUserInfoKey = @"UserEnteredUserInfo";
static NSString *UserNameKey = @"UserName";
static NSString *UserPhoneNumberKey = @"UserPhoneNumber";

@interface UserInfoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end
