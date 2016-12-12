//
//  InscriViewController.m
//  GestionNote
//
//  Created by Ameur Drira on 11/12/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "InscriViewController.h"
#import "ViewController.h"
#import "TableViewController.h"

@interface InscriViewController ()

@end

@implementation InscriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)inscrire_user:(id)sender {
    
    if((prenomNom.text.length==0)||(loginInscri.text.length==0)||(pwdInscri.text.length==0)||(verifPwdInscri.text.length==0)){
        
        [self addAlertViewlength];
        
    }else if((![verifPwdInscri.text isEqualToString:pwdInscri.text])){
        
        [self alertMotDePasse];
        
    }else{
       
            NSError *error;
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSString *url = @"http://localhost:1337/user/create";
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            NSDictionary* newDatasetInfo = @{@"loginUser":loginInscri.text,@"password":pwdInscri.text,@"nomPrenom":prenomNom.text};
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
            
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {}];
            
            [dataTask resume];
            
            ViewController* main=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:main animated:YES];
            
            
    }
    
    
    
}

-(void)addAlertViewlength{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"Plusieur champ oun un champ est vide  "
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)alertMotDePasse{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"Le champ confirmation du mot de passe ne correspond pas au champ mot de passe"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
