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
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
        // do alert
    }
    else {
        [self loginUser];
    }
    
}
- (IBAction)didTapSignUp:(id)sender {
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
//        do alert
    }
    else {
       [self registerUser];
    }

}
- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    
        }
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
