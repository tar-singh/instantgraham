//
//  ChoosePictureController.m
//  instantgraham
//
//  Created by Tarini Singh on 7/11/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "ChoosePictureController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Post.h"

@interface ChoosePictureController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *theCaption;

@end

@implementation ChoosePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTouchPicture:(id)sender {
    [self imagePickerMethod];
}

- (IBAction)fromGallery:(id)sender {
    [self galleryPickerMethod];
}


- (void)galleryPickerMethod {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    [Post postUserImage:self.image withCaption:self.theCaption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            NSLog(@"image posted successfully");
            NSLog(@"%@", self.theCaption);
        }
        else{
            NSLog(@"image failed to post");
        }
    }];
    [self didTapCancel:(id)nil];
}
- (IBAction)captionMade:(id)sender {
    self.theCaption = self.captionField.text;
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
    
    // Do something with the images (based on your use case)
    
    self.image = resizedImage;
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
