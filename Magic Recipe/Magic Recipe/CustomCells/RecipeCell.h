//
//  RecipeCell.h
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 18/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;

@end
