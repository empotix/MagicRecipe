//
//  DetailedRecipe.h
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 19/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedRecipe : UIViewController
@property (strong, nonatomic) NSString *hrefSource;
@property (strong, nonatomic) IBOutlet UIWebView *detailedWebView;

@end
