//
//  Note.h
//  GestionNote
//
//  Created by Ameur Drira on 25/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (strong,nonatomic)NSString* libelle;
@property (strong,nonatomic)NSString* note;
@property (strong,nonatomic)NSString* coif;

-(id) initNoteWithLibelle:(NSString*) mlibelle mNote:(NSString*)mNote mCoif:(NSString*)mCoif;
-(void) addNoteList:(NSMutableArray*) list;

@end
