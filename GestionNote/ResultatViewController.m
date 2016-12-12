//
//  ResultatViewController.m
//  GestionNote
//
//  Created by Ameur Drira on 27/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "ResultatViewController.h"
#import "AppDelegate.h"
#import "Note.h"

@interface ResultatViewController ()

@end

@implementation ResultatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    int i=0;
    float totaleMoy = 0.0;
    float totaleCoif= 0.0;
    
    for (i = 0 ; i < [appd.listNote count] ; i++) {
        
        Note* objet = [appd.listNote objectAtIndex:i];
        totaleMoy+=([objet.coif floatValue] * [objet.note floatValue]);
        totaleCoif+=[objet.coif floatValue];
    }
    
    NSString* stringResultat = [NSString stringWithFormat:@"%0.2f", totaleMoy/totaleCoif];
    
    
    if (stringResultat.floatValue>=10){
        
        resulat.textColor=[UIColor greenColor];
        resulat.text=stringResultat;
        
    }else{
        
        resulat.textColor=[UIColor redColor];
        resulat.text=stringResultat;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
