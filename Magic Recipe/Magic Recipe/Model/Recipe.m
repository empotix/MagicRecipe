//
//  Recipe.m
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 18/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe
-(void)initWithData:(NSDictionary *)recipe {
    self.title          =   recipe[@"title"];
    self.href           =   recipe[@"href"];
    self.ingredients    =   recipe[@"ingredients"];
    self.thumbnail      =   recipe[@"thumbnail"];
}
@end
