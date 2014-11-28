//
//  PCFViewController.m
//  vzero
//
//  Created by Alberto López on 11/11/14.
//  Copyright (c) 2014 Commerce Factory. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <BTDropInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self getToken];
}

- (void)getToken {
    [self.manager GET:@"http://127.0.0.1:3000/token"
          parameters: nil
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            self.clientToken = responseObject[@"clientToken"];
            self.startPaymentButton.enabled = TRUE;
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
          }];
}

- (IBAction)startPayment:(id)sender {
    Braintree *braintree = [Braintree braintreeWithClientToken:self.clientToken];
    BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];
    
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                             target:self
                                                             action:@selector(userDidCancelPayment)];
    
    //Customize the UI
    dropInViewController.summaryTitle = @"A Braintree Mug";
    dropInViewController.summaryDescription = @"Enough for a good cup of coffee";
    dropInViewController.displayAmount = @"$10";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
    
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    [self postNonceToServer:paymentMethod.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidCancelPayment{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark POST NONCE TO SERVER method
- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    [self.manager POST:@"http://127.0.0.1:3000/payment"
       parameters:@{@"payment_method_nonce": paymentMethodNonce}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSString *transactionID = responseObject[@"transaction"][@"id"];
              self.transactionIDLabel.text = [[NSString alloc] initWithFormat:@"Transaction ID: %@", transactionID];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}

@end
