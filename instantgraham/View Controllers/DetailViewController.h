//
//  DetailViewController.h
//  instantgraham
//
//  Created by Tarini Singh on 7/10/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI/ParseUI.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *detailPictureView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimestampLabel;
@property (strong, nonatomic) Post *detailPost;

-(void)setDetailPost:(Post *)detailPost;
@end
