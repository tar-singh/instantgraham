//
//  FeedCell.h
//  instantgraham
//
//  Created by Tarini Singh on 7/10/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI/ParseUI.h"

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) NSArray *postArray;
@property (strong, nonatomic) Post *post;
@end
