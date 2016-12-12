//
//  Note.m
//  GestionNote
//
//  Created by Ameur Drira on 25/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import "Note.h"

@implementation Note

-(id) initNoteWithLibelle:(NSString *)mlibelle mNote:(NSString *)mNote mCoif:(NSString *)mCoif
{
    NSLog(@"metode init");
    if(self==[super init])
    {
        self.libelle=mlibelle;
        self.note=mNote;
        self.coif=mCoif;
    }
    return self;
}
-(void) addNoteList:(NSMutableArray*) list{
    [list addObject:self];
}

@end
