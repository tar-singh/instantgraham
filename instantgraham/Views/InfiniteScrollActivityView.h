//
//  InfiniteScrollActivityView.h
//  instantgraham
//
//  Created by Tarini Singh on 7/12/18.
//  Copyright © 2018 Tarini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;
- (void)startAnimating;
- (void)stopAnimating;
@end
