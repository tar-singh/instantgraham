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
#import "InfiniteScrollActivityView.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation FeedViewController

NSArray *data;
NSString *CellIdentifier = @"feedCell";
NSString *HeaderViewIdentifier = @"TableViewHeaderView";

bool isMoreDataLoading = false;
InfiniteScrollActivityView* loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set up Infinite Scroll loading indicator
    [self activityViewSetUp];
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    self.feedTable.rowHeight = UITableViewAutomaticDimension;
    [self getPostsHUD];
    [self refreshControlSetUp];
}

- (void) activityViewSetUp {
    CGRect frame = CGRectMake(0, self.feedTable.contentSize.height, self.feedTable.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.feedTable addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.feedTable.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.feedTable.contentInset = insets;
}


- (void) refreshControlSetUp {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.feedTable insertSubview:self.refreshControl atIndex:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.feedTable.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.feedTable.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.feedTable.isDragging) {
            self.isMoreDataLoading = true;
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.feedTable.contentSize.height, self.feedTable.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            // load more results
            [self getPosts];
        }
    }
}

// with progress HUD
- (void)getPostsHUD{
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (!error) {
            NSLog(@"there are posts");
            // do something with the data fetched
            self.postArray = [NSMutableArray arrayWithArray:posts];
            self.isMoreDataLoading = false;
            // Stop the loading indicator
            [loadingMoreView stopAnimating];
            [self.feedTable reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

// without progress HUD
- (void)getPosts{
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"there are posts");
            // do something with the data fetched
            self.postArray = [NSMutableArray arrayWithArray:posts];
            self.isMoreDataLoading = false;
            // Stop the loading indicator
            [loadingMoreView stopAnimating];
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
    // set the image if nil
    if (post.image == nil){
        cell.pictureView.image = nil;
        UIImage *defaultImage = [UIImage imageNamed:@"file-picture.png"];
        cell.pictureView.image = defaultImage;
    };
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}



@end
