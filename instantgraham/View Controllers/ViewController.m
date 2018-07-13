//
//  ViewController.m
//  instantgraham
//
//  Created by Tarini Singh on 7/9/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)didTapLogin:(id)sender {
    // alert if fields not filled in
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        [self setUpAlertController];
    }
    else {
        [self loginUser];
    }
}

- (IBAction)didTapSignUp:(id)sender {
    //alert if fields not filled in
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        [self setUpAlertController];
    }
    else {
       [self registerUser];
    }
}

- (void) setUpAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blank Field" message:@"All fields must be filled" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    // handle response here.
        
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    // present alert
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            if ([error.localizedDescription isEqualToString:@"Invalid username/password."]){
                [self loginAlertController];
            }
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void) loginAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User does not exist" message:@"Please sign up" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    // present alert
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

-  (void)registerUser  {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
