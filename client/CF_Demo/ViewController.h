//
//  PCFViewController.h
//  CF_Demo
//
//  Created by Alberto López on 11/11/14.
//  Copyright (c) 2014 Commerce Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Braintree/Braintree.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *transactionIDLabel;
@property (strong, nonatomic) NSString *clientToken;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) IBOutlet UIButton *startPaymentButton;


- (IBAction)startPayment:(id)sender;
@end
