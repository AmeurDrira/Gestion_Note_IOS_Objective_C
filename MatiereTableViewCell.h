//
//  MatiereTableViewCell.h
//  GestionNote
//
//  Created by Ameur Drira on 26/11/2016.
//  Copyright © 2016 IIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatiereTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel* libelle;
@property(nonatomic,strong)IBOutlet UILabel* note;
@property(nonatomic,strong)IBOutlet UILabel* coif;

@end
