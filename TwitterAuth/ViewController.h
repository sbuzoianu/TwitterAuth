//
//  ViewController.h
//  TwitterAuth
//
//  Created by Stefan on 12/01/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <Social/Social.h>
#import  <Accounts/Accounts.h>
#import  <Twitter/Twitter.h>

@interface ViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property (nonatomic, copy) NSString *query;


@end

