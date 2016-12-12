//
//  TableViewController.m
//  GestionNote
//
//  Created by Ameur Drira on 27/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "TableViewController.h"
#import "MatiereTableViewCell.h"
#import "FormulaireViewController.h"
#import "ResultatViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "NSObject+BWJSONMatcher.h"
#import "BWJSONMatcher.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"plus.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void) handleBack:(id)sender
{
    
    FormulaireViewController* formulaireViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"FormulaireViewController"];
    [self.navigationController pushViewController:formulaireViewController animated:YES];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    return appd.listNote.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* simpleTableIdentifier=@"MatiereTableViewCell";
    MatiereTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    Note *note=[appd.listNote objectAtIndex:indexPath.row];
    
    cell.libelle.text=note.libelle;
    cell.coif.text=note.coif;
    cell.note.text=note.note;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app.listNote removeObjectAtIndex:indexPath.row];
        [self putData];
        [tableView reloadData];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(IBAction)AddNote:(id)sender{
    FormulaireViewController* formulaireViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"FormulaireViewController"];
    [self.navigationController pushViewController:formulaireViewController animated:YES];
    
    
}
-(IBAction)calculate:(id)sender{
    AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if(appd.listNote.count>0){
        ResultatViewController* resultatViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ResultatViewController"];
        [self.navigationController pushViewController:resultatViewController animated:YES];
    }else{
        [self addAlertView];
    }
}
-(void)addAlertView{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"Aucune Matiere saisie"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
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
