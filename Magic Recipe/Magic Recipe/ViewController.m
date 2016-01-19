//
//  ViewController.m
//  Magic Recipe
//
//  Created by Narendra Bokkasam on 18/01/16.
//  Copyright © 2016 GlowTouch. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "RecipeCell.h"
#import "Recipe.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray *recipeArray;
@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *urlWithPage = [NSString stringWithFormat:@"%@=1",RECIPE_API_PAGE];

    [self showHUD];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlWithPage] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            
        }else {
            NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            self.recipeArray = [NSMutableArray new];
            for(NSDictionary *recipe in responseResult[@"results"]) {
                Recipe *recObject = [[Recipe alloc] init];
                [recObject initWithData:recipe];
                [self.recipeArray addObject:recObject];

            }
            
                    [self hideHUD];
                    [self.recipeTableView reloadData];
        }
    }];
    [task resume];
    self.recipeTableView.estimatedRowHeight = 100;
    self.recipeTableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[RecipeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Recipe *recObject = (Recipe *)self.recipeArray[indexPath.row];
    cell.titleLabel.text        = recObject.title;
    cell.ingredientsLabel.text  = recObject.ingredients;
    [cell.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:recObject.thumbnail]
    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
