//
//  FeedViewController.m
//  instantgraham
//
//  Created by Tarini Singh on 7/9/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Post.h"
#import "FeedCell.h"
#import "DetailViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.rowHeight = 300;
    [self getPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.feedTable insertSubview:self.refreshControl atIndex:0];
}

- (void)getPosts{
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"there are posts");
            // do something with the data fetched
            self.postArray = [NSMutableArray arrayWithArray:posts];
            [self.feedTable reloadData];
            [self.refreshControl endRefreshing];
            
        }
        else {
            // handle error
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            // PFUser.current() will now be nil
            NSLog(@"User logged out successfully");
            
            // return to login screen
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = viewController;
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"DetailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *tappedIndexPath = [self.feedTable indexPathForCell:tappedCell];
        Post *post = self.postArray[tappedIndexPath.row];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.detailPost = post;
        //    [detailViewController setDetailPost:post];
    }
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    Post *post = self.postArray[indexPath.row];
    [cell setPost:post];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}



@end
