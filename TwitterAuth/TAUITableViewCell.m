//
//  TAUITableViewCell.m
//  TwitterAuth
//
//  Created by Stefan on 31/01/16.
//  Copyright © 2016 Stefan. All rights reserved.
//


#import "TAUITableViewCell.h"

@implementation TAUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.userTALabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 20)];
        self.userTALabel.textColor = [UIColor blackColor];
        self.userTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];

        self.dateTALabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 300, 25)];
        self.dateTALabel.textColor = [UIColor blackColor];
        self.dateTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];

        self.textTALabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 300, 50)];
        self.textTALabel.textColor = [UIColor blackColor];
        self.textTALabel.numberOfLines = 0;
        self.textTALabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textTALabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];


        self.imageTAView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 48, 48)];
        self.imageTAView.backgroundColor = [UIColor lightGrayColor];
        self.imageTAView.layer.cornerRadius = self.imageTAView.frame.size.width / 2;
        self.imageTAView.clipsToBounds = YES;
        self.imageTAView.layer.borderWidth = 1.0f;
        self.imageTAView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:self.textTALabel];
        [self addSubview:self.imageTAView];
        [self addSubview:self.userTALabel];
        [self addSubview:self.dateTALabel];

        
    }
    return self;
}




@end
