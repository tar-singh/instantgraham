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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
- (IBAction)didTapCamera:(id)sender {
    [self imagePickerMethod];
    
    // TODO: have another method for picking image from gallery (tab view)
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

- (void)imagePickerMethod {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedImage = [self resizeImage:editedImage withSize:editedImage.size];
    // TODO: caption
    NSString *caption = @"this is a caption";
    
    // Do something with the images (based on your use case)
    
    [Post postUserImage:resizedImage withCaption:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            NSLog(@"image posted successfully");
        }
        else{
            NSLog(@"image failed to post");
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)didPost:(Post *)post {
//    [self.postArray insertObject:post atIndex:0];
//    [self.feedTable reloadData];
//}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    UITableViewCell *tappedCell = sender;
    NSIndexPath *tappedIndexPath = [self.feedTable indexPathForCell:tappedCell];
    Post *post = self.postArray[tappedIndexPath.row];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.detailPost = post;
//    [detailViewController setDetailPost:post];
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
