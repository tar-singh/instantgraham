//
//  Post.h
//  instantgraham
//
//  Created by Tarini Singh on 7/10/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import "PFObject.h"
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nullable postID;
@property (nonatomic, strong) NSString * _Nullable userID;
@property (nonatomic, strong) PFUser * _Nullable author;
@property (nonatomic, strong) NSString * _Nullable caption;
@property (nonatomic, strong) PFFile * _Nullable image;
@property (nonatomic, strong) NSNumber * _Nullable likeCount;
@property (nonatomic, strong) NSNumber * _Nullable commentCount;

+ (void) postUserImage:(UIImage * _Nullable)image withCaption:(NSString * _Nullable)caption withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end
