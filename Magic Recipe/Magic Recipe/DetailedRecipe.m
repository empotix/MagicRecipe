//
//  DetailedRecipe.m
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 19/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import "DetailedRecipe.h"

@implementation DetailedRecipe
-(void)viewDidLoad {
    [super viewDidLoad];
    NSURL* nsUrl = [NSURL URLWithString:self.hrefSource];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.detailedWebView loadRequest:request];
}
@end
