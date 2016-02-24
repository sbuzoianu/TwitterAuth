//
//  MainViewController.h
//  NewTweetAuth
//
//  Created by admin on 22/02/16.
//  Copyright © 2016 admin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import  <Social/Social.h>
#import  <Accounts/Accounts.h>
#import  <Twitter/Twitter.h>

@interface MainViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property (nonatomic, copy) NSString *query;


@end