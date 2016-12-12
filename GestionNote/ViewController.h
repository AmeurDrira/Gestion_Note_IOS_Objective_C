//
//  ViewController.h
//  GestionNote
//
//  Created by Ameur Drira on 22/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    NSArray *ar1;
    NSString *captcha_string;
    NSUInteger i1,i2,i3,i4,i5;
    IBOutlet UILabel *captcha_label;
    IBOutlet UITextField *login;
    IBOutlet UITextField *pwd;
    IBOutlet UITextField *captcha_field;
    
    UIAlertView *captcha_alert;
    
    IBOutlet UILabel *status_label;
}
- (IBAction)Reload_Action:(id)sender;
- (IBAction)Submit_Action:(id)sender;
@end

