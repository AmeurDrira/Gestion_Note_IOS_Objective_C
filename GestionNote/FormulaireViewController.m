//
//  FormulaireViewController.m
//  GestionNote
//
//  Created by Ameur Drira on 27/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "FormulaireViewController.h"
#import "TableViewController.h"
#import "MatiereTableViewCell.h"
#import "AppDelegate.h"
#import "Note.h"
#import "NSObject+BWJSONMatcher.h"
#import "BWJSONMatcher.h"

@interface FormulaireViewController ()

@end

@implementation FormulaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)addAlertViewlength{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"Verifier le saisie"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)addAlertNote{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"La note doit etre entre 0 et 20"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addAlertCoif{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"La Coifficient  doit etre superieur a 0 "
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}


-(IBAction)clicToAnnuler:(id)sender{
    fieldCoif.text=@"";
    fieldNote.text=@"";
    fieldlibelle.text=@"";
    
}


-(IBAction)clicToTable:(id)sender{
    
    if((fieldlibelle.text.length==0)||(fieldNote.text.length==0)||(fieldCoif.text.length==0)){
        
        [self addAlertViewlength];
        
    }else if((fieldNote.text.floatValue<0)||(fieldNote.text.floatValue>=20)){
        
        [self addAlertNote];
        
    }else if((fieldCoif.text.floatValue<1)||(fieldCoif.text.floatValue>=99)){
        
        [self addAlertCoif];
        
    }else{
        
        Note* note=[[Note alloc]initNoteWithLibelle:fieldlibelle.text mNote:fieldNote.text mCoif:fieldCoif.text];
        
        AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [note addNoteList:appd.listNote];
        [self putData];
        TableViewController* liste=[self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
        [self.navigationController pushViewController:liste animated:YES];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void) putData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        
        AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *url = @"http://localhost:1337/user/";
        url = [url stringByAppendingString:appd.login];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSDictionary* newDatasetInfo = @{@"notes":[BWJSONMatcher convertObjectToJSON:appd.listNote]};
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
        
        
        [request setHTTPMethod:@"PUT"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {}];
        
        [dataTask resume];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Im on the main thread");
        });
    });
    
    
    
}

@end
