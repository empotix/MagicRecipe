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
#import "DetailedRecipe.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger pageNumber;
    BOOL loading;
    NSString *dataLoadedBy;
}
@property(nonatomic, strong)NSMutableArray *recipeArray;
@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) IBOutlet UITextField *ingredientTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipeArray = [NSMutableArray new];
    pageNumber=1;
    NSString *urlWithPageNo1 = [NSString stringWithFormat:@"%@=%ld",RECIPE_API_PAGE,pageNumber];
    loading=true;
    dataLoadedBy = @"All";
    [self makeAPICall:urlWithPageNo1];
    // Auto Resize Cell
    self.recipeTableView.estimatedRowHeight = 100;
    self.recipeTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Making API Call with Page Number
#pragma mark

-(void)makeAPICall:(NSString *)urlStringWithPageNo {
    [self showHUD];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStringWithPageNo] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
             [self hideHUD];
            //Need to show Alert when error occures
        }else {
            NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:data options:1 error:nil];
            
            for(NSDictionary *recipe in responseResult[@"results"]) {
                loading=false;
                Recipe *recObject = [[Recipe alloc] init];
                [recObject initWithData:recipe];
                [self.recipeArray addObject:recObject];
            }
            
            [self hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recipeTableView reloadData];
            });
        }
    }];
    [task resume];
}

#pragma mark - MBProgress HUB Methdos
#pragma mark

-(void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
}

#pragma mark - Table DataSource
#pragma mark

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
#pragma mark - Table Delegate
#pragma mark

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Recipe *recObject = (Recipe *)self.recipeArray[indexPath.row];
    NSString *href = recObject.href;
    [self performSegueWithIdentifier:@"showDetailsSegue" sender:href];
}

#pragma mark -
#pragma mark

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetailsSegue"]) {
        DetailedRecipe *detailedVC = (DetailedRecipe *)segue.destinationViewController;
        detailedVC.hrefSource = (NSString *)sender;
    }
}

#pragma mark- UIScroll View Method: Pagination
#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(!loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            
            [self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:0];
        }
    }
}

-(void) loadDataDelayed {
    NSString *urlWithPageNo = [NSString stringWithFormat:@"%@=%ld",RECIPE_API_PAGE,++pageNumber];
    loading=true;
    [self makeAPICall:urlWithPageNo];
}
- (IBAction)loadAllRecipes:(id)sender {
    if([dataLoadedBy isEqualToString:@"All"]) return;
    dataLoadedBy = @"All";
    self.ingredientTextField.text = @"";
    self.recipeArray = [NSMutableArray new];
    pageNumber=0;
    NSString *urlWithPageNo = [NSString stringWithFormat:@"%@=%ld",RECIPE_API_PAGE,++pageNumber];
    loading=true;
    [self makeAPICall:urlWithPageNo];
}
- (IBAction)searchByIngredients:(id)sender {
    dataLoadedBy = @"Search";
    self.recipeArray = [NSMutableArray new];
    NSString *searchIngredients = self.ingredientTextField.text;
    pageNumber=0;
    NSString *urlWithPageNo = [NSString stringWithFormat:@"%@=%@&p=%ld",RECIPE_SEARCH_API,searchIngredients,++pageNumber];
    loading=true;
    [self makeAPICall:urlWithPageNo];
}

#pragma mark - Memory Management
#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
