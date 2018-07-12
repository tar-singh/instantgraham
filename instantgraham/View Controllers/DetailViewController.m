//
//  DetailViewController.m
//  instantgraham
//
//  Created by Tarini Singh on 7/10/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "DetailViewController.h"
#import "ParseUI/ParseUI.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDetailPost:self.detailPost];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailPost:(Post *)detailPost{
    _detailPost = detailPost;
    self.detailPictureView.file = detailPost[@"image"];
    self.detailLabel.text = detailPost[@"caption"];
    self.detailTimestampLabel.text = detailPost[@"date"];
    [self.detailPictureView loadInBackground];
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
