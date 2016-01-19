//
//  Recipe.h
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 18/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *href;
@property(nonatomic, strong) NSString *ingredients;
@property(nonatomic, strong) NSString *thumbnail;
-(void)initWithData:(NSDictionary *)recipe;
@end
