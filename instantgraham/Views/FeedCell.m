//
//  FeedCell.m
//  instantgraham
//
//  Created by Tarini Singh on 7/10/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "FeedCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "ParseUI/ParseUI.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    self.pictureView.file = post[@"image"];
    self.captionLabel.text = post[@"caption"];
//    NSLog(@"%@", post[@"caption"]);
//    if ([post[@"caption"] isEqualToString:@""]){
//        NSLog(@"no caption!");
//    }
//    else{
//        NSLog(@"caption");
//    }
    [self.pictureView loadInBackground];
}


@end
