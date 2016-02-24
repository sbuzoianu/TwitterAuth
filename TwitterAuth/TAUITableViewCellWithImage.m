//
//  TAUITableViewCellWithImage.m
//  TwitterAuth
//
//  Created by Stefan on 11/02/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAUITableViewCellWithImage.h"

@implementation TAUITableViewCellWithImage

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userTALabel = [[UILabel alloc] init];
        self.userTALabel.textColor = [UIColor blackColor];
        //      self.userTALabel.backgroundColor= [UIColor greenColor];
        self.userTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        
        self.dateTALabel = [[UILabel alloc] init];
        //      self.dateTALabel.backgroundColor= [UIColor orangeColor];
        self.dateTALabel.textColor = [UIColor blackColor];
        self.dateTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        
        self.textTALabel = [[UILabel alloc] init];
        self.textTALabel.textColor = [UIColor blackColor];
        //      self.textTALabel.backgroundColor= [UIColor redColor];
        self.textTALabel.numberOfLines = 0;
        self.textTALabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        self.textTALabel.preferredMaxLayoutWidth = self.frame.size.width;
        
        self.imageTAView=[[UIImageView alloc] init];
        //      self.imageTAView.backgroundColor = [UIColor lightGrayColor];
        self.imageTAView.layer.cornerRadius = self.imageTAView.frame.size.width / 2;
        self.imageTAView.clipsToBounds = YES;
        self.imageTAView.layer.borderWidth = 1.0f;
        self.imageTAView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.mediaView = [[UIImageView alloc] init];
        //      [self.mediaView setContentMode: UIViewContentModeScaleAspectFit]; - VREAU SA CITESC DESPRE EA!
        
        [self addSubview:self.textTALabel];
        [self addSubview:self.imageTAView];
        [self addSubview:self.userTALabel];
        [self addSubview:self.dateTALabel];
        [self addSubview:self.mediaView];
        
        
        // self.mediaView constraints
        self.mediaView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.mediaView
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterX
                             multiplier:1.0f constant:0.0f]];
        
        //[self addConstraint:[NSLayoutConstraint constraintWithItem:self.self.mediaView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.mediaView
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:self.textTALabel
                             attribute:NSLayoutAttributeBottom
                             multiplier:1.0f
                             constant:10.0f]];
        
        [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f]];
        
        [self addConstraint: [NSLayoutConstraint
                              constraintWithItem:self.mediaView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                              constant:150]];
        
        
        
        
        
        // self.imageTAView constraints
        self.imageTAView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.imageTAView
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0f
                             constant:10.0f]];
        //        [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.userTALabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:self.imageTAView
                             attribute:NSLayoutAttributeLeading
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeLeading
                             multiplier:1.0f constant:5.0f]];
        //        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.self.imageTAView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        
        [self addConstraint: [NSLayoutConstraint
                              constraintWithItem:self.imageTAView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1
                              constant:48]];
        
        
        // dateTALabel constraints
        self.dateTALabel.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateTALabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userTALabel attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateTALabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:60.0f]];
        
        // textTALabel constraints
        self.textTALabel.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textTALabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:60.0f]];
        //    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.textTALabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textTALabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:5.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textTALabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        
        // userTAlabel constraints
        self.userTALabel.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userTALabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userTALabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:60.0f]];
        
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self.contentView layoutIfNeeded];
//}



@end
