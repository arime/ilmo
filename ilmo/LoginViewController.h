//
//  LoginViewController.h
//  ilmo
//
//  Created by Antti Palola on 10/20/12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *backgroundImage;

- (IBAction)loginButtonPushed:(id)sender;
- (IBAction)backgroundPushed:(id)sender;

- (IBAction)usernameTextFieldEditingDidEnd:(id)sender;
- (IBAction)passwordTextFieldEditingDidEnd:(id)sender;

@end
