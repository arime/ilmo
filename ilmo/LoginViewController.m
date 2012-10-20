//
//  LoginViewController.m
//  ilmo
//
//  Created by Antti Palola on 10/20/12.
//
//

#import "LoginViewController.h"
#import "ServerConnector.h"

@interface LoginViewController ()
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation LoginViewController
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    NSString *username = [userSettings stringForKey:@"account"];
    NSString *password = [userSettings stringForKey:@"password"];
    
    [self.userNameTextField setText:username];
    [self.passwordTextField setText:password];
    
    // Success block for login
    /*[self login:^(void) {
        [self.activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"ToTableSegue" sender:self];
        
    }];*/
    

}

-login:(void (^)())successCallback {
    // Do async call to login
    //[ServerConnector logIn:successCallback]
}


- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)usernameTextFieldEditingDidEnd:(id)sender {
    // Save the changed username
    NSString *username = [self.userNameTextField text];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:username forKey:@"account"];
    [userDefaults synchronize];
}

- (IBAction)passwordTextFieldEditingDidEnd:(id)sender {
    // Save the changed password
    NSString *password = [self.passwordTextField text];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:password forKey:@"password"];
    [userDefaults synchronize];
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.userNameTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

- (IBAction)loginButtonPushed:(id)sender {
    
    [self performSegueWithIdentifier:@"TableSegue" sender:self];
}

- (IBAction)backgroundPushed:(id)sender {
    [self dismissKeyboard:sender];
}
@end
