//
//  ViewController.m
//  GestionNote
//
//  Created by Ameur Drira on 22/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "InscriViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    status_label.hidden=YES;
    ar1 = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self reload_captcha];
    [captcha_field becomeFirstResponder];
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reload_captcha{
    
    @try {
        status_label.hidden=YES;
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        captcha_label.backgroundColor = color;
        
        i1 = arc4random() % [ar1 count];
        
        i2= arc4random() % [ar1 count];
        
        i3 = arc4random() % [ar1 count];
        
        i4 = arc4random() % [ar1 count];
        
        i5 = arc4random() % [ar1 count];
        
        captcha_string = [NSString stringWithFormat:@"%@%@%@%@%@",[ar1 objectAtIndex:i1-1],[ar1 objectAtIndex:i2-1],[ar1 objectAtIndex:i3-1],[ar1 objectAtIndex:i4-1],[ar1 objectAtIndex:i5-1]];
        
        captcha_label.text = captcha_string;
        captcha_field.text=@"";
        captcha_field.textColor=captcha_label.backgroundColor;
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)Reload_Action:(id)sender {
    
    [self reload_captcha];
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
{
    if (captcha_field.text.length >= 5 && range.length == 0)
        return NO;
    return YES;
}

- (IBAction)Submit_Action:(id)sender {
    
    NSString *loginfield=login.text;
    NSString *pwdfield=pwd.text;
    
    if([self fetchUser:loginfield :pwdfield]&&!(pwdfield.length==0)&&!(loginfield.length==0)){
        if([captcha_label.text isEqualToString: captcha_field.text]){
           
            [self fetchJson:login.text];
            AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appd.login=loginfield;
            
            TableViewController* liste=[self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
            [self.navigationController pushViewController:liste animated:YES];
            
            login.text=@"";
            pwd.text=@"";
            
        }else{
            
            status_label.hidden=NO;
        }
    }else{
        [self AlertLoginPassword];
    }
}
- (IBAction)inscrire:(id)sender {
    
    InscriViewController* inscr=[self.storyboard instantiateViewControllerWithIdentifier:@"InscriViewController"];
    [self.navigationController pushViewController:inscr animated:YES];
    
}
-(void) fetchJson:(NSString*)loginUser {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSString *url = @"http://localhost:1337/user/";
        url = [url stringByAppendingString:loginUser];
        
        NSData *jsonData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:url]];
        
        NSMutableArray *listNote2 = [[NSMutableArray alloc] init];
        AppDelegate* appd=(AppDelegate*)[[UIApplication sharedApplication]delegate];
       
        if ([appd.listNote count] != 0) {
            [appd.listNote removeAllObjects];
        
        }
        
        id jsonobject=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if ([jsonobject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict=(NSDictionary *)jsonobject;
            
            
            listNote2 = [dict valueForKey:@"notes"];
            
            Note* note;
            for (NSDictionary *groupDic in listNote2) {
                note= [[Note alloc] init];
                
                for (NSString *key in groupDic) {
                    
                    if ([note respondsToSelector:NSSelectorFromString(key)]) {
                        [note setValue:[groupDic valueForKey:key] forKey:key];
                    }
                }
                [note addNoteList:appd.listNote];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Im on the main thread");
        });
    });
}
-(BOOL) fetchUser:(NSString*)loginUser :(NSString*)passwordUser {
    
    
    NSError *error;
    NSString *loginfield=@"";
    NSString *passwordfield=@"";    
    
    NSString *url = @"http://localhost:1337/user/auth/";
    url = [url stringByAppendingString:loginUser];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:url]];
    
    if(!(jsonData.length==0)){
        
    id jsonobject=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonobject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict=(NSDictionary *)jsonobject;
        
        
        loginfield= [dict valueForKey:@"loginUser"];
        passwordfield= [dict valueForKey:@"password"];
    }
    }
    if([loginUser isEqualToString: loginfield]&&[passwordfield isEqualToString: passwordUser]){
        return YES;
        
    }else
    {
        return NO;
    }
    
}
-(void)AlertLoginPassword{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message d'erreur"
                                 message:@"Verfier votre login et mot de passe "
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
