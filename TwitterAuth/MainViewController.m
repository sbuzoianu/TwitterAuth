//
//  MainViewController.m
//  TwitterAuth
//
//  Created by Stefan on 12/01/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "MainViewController.h"
#import "TAUITableViewCellWithoutImage.h"
#import "TAUITableViewCellWithImage.h"

@interface MainViewController ()

@property (strong, nonatomic) UITableView * tableView;

@property (nonatomic,strong) ACAccountStore *accountStore;
@property NSString *searchText;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UITextField *searchTextField;
@property (nonatomic,strong) NSMutableData *buffer;
@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic,strong) NSRegularExpression *regex;

@end

@implementation MainViewController

static NSString *CellIdentifierWithoutImage = @"CellWithoutImage";
static NSString *CellIdentifierWithImage = @"CellWithImage";

- (ACAccountStore *)accountStore
{
    if (_accountStore == nil)
    {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //customizari pe NavigationBar
    UIColor * twitterColor=[UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:twitterColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary
                                                dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationItem setTitle:@"Twitter"];
    
    
    [self drawForms];
    [self.tableView setEstimatedRowHeight:300.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    NSError *error;
    self.regex=[NSRegularExpression regularExpressionWithPattern:@"(#(\\w+)|@(\\w+))" options:NSRegularExpressionCaseInsensitive  error:&error];
    
    [self interogareTwitter];
    
}


- (void) drawForms{
    
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[TAUITableViewCellWithoutImage class] forCellReuseIdentifier:@"CellWithoutImage"];
    [self.tableView registerClass:[TAUITableViewCellWithImage class] forCellReuseIdentifier:@"CellWithImage"];
    [self.view addSubview:self.tableView];
    //constraints pentru tableView
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0f
                              constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0f
                              constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:0.0f]];
    
    // definim un searchTextField
    //    UITextField *searchTextField = [[UITextField alloc] init];
    //    searchTextField.backgroundColor=[UIColor colorWithRed:14.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1];
    //    searchTextField.font = [UIFont systemFontOfSize:15];
    //    searchTextField.textAlignment=NSTextAlignmentCenter;
    //    searchTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"#hashtag" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    searchTextField.textColor=[UIColor whiteColor];
    //    searchTextField.keyboardType = UIKeyboardTypeDefault;
    //    searchTextField.returnKeyType = UIReturnKeyDone;
    //    searchTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    //    self.searchTextField=searchTextField;
    //    //  VC este delegate-ul pentru searchTextField
    //    searchTextField.delegate=self;
    //    [self.view addSubview:searchTextField];
    //
    //
    //
    //    //constraints pentru searchTextField
    //    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.view addConstraint:[NSLayoutConstraint
    //                              constraintWithItem:self.searchTextField
    //                              attribute:NSLayoutAttributeLeading
    //                              relatedBy:NSLayoutRelationEqual
    //                              toItem:self.view
    //                              attribute:NSLayoutAttributeLeading
    //                              multiplier:1.0f
    //                              constant:0.0f]];
    //    [self.view addConstraint:[NSLayoutConstraint
    //                              constraintWithItem:self.searchTextField
    //                              attribute:NSLayoutAttributeTrailing
    //                              relatedBy:NSLayoutRelationEqual
    //                              toItem:self.view
    //                              attribute:NSLayoutAttributeTrailing
    //                              multiplier:1.0f
    //                              constant:0.0f]];
    //    [self.view addConstraint:[NSLayoutConstraint
    //                              constraintWithItem:self.searchTextField
    //                              attribute:NSLayoutAttributeTop
    //                              relatedBy:NSLayoutRelationEqual
    //                              toItem:self.view
    //                              attribute:NSLayoutAttributeTop
    //                              multiplier:1.0f
    //                              constant:20.0f]];
    //    [self.view addConstraint: [NSLayoutConstraint
    //                               constraintWithItem:self.searchTextField
    //                               attribute:NSLayoutAttributeHeight
    //                               relatedBy:NSLayoutRelationEqual
    //                               toItem:nil
    //                               attribute:NSLayoutAttributeNotAnAttribute
    //                               multiplier:1
    //                               constant:34]];
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self interogareTwitter];
    [refreshControl endRefreshing];
}



#pragma mark - Conectare->Interogare Twitter

#define RESULTS_PERPAGE @"20"


- (void)interogareTwitter
{
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             self.tableView.hidden=NO; // activez daca merge autentificare
             
             NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
             
             if ([self.searchText length] == 0){
                 self.searchText=@"barcelona";
             }
             
             NSString *encodedQuery = [self.searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             
             NSDictionary *parameters = @{@"count" : RESULTS_PERPAGE,
                                          @"q" : encodedQuery};
             
             SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:url
                                                          parameters:parameters];
             NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
             slRequest.account = [accounts lastObject];
             NSURLRequest *request = [slRequest preparedURLRequest];
             
             [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
             NSURLSession *session = [NSURLSession sharedSession];
             NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                               {
                                                   if (data)
                                                   {
                                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                       NSError *jsonParsingError = nil;
                                                       NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                                                       if (jsonParsingError)
                                                       {
                                                           NSLog(@"Eroare la JSON=%@", jsonParsingError);
                                                       }
                                                       //din JSON in NSDictionary doar itemul STATUSES
                                                       self.results = jsonResults[@"statuses"];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self.tableView reloadData];
                                                           
                                                           if ([[NSThread currentThread] isMainThread]){
                                                               NSLog(@"Sunt in main thread");
                                                           }
                                                           else{
                                                               NSLog(@"Nu sunt in main thread");
                                                           }
                                                       });
                                                   } // if (data)
                                               }];
             [dataTask resume];
         }
         
         else {
             NSLog(@"Nu s-a reusit logarea!");
         }
     }];
}



#pragma mark - UITableView delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSLog(@"Numarul de inreg este %lu", (unsigned long)[self.results count]);
    return [self.results count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %ld",(long)indexPath.row);
    // Either load your url here using the UIWebView or use the below code to open URL in safari.
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:hereURLYouWantToOpen]];
    if([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TAUITableViewCellWithImage class]]){
        TAUITableViewCellWithImage *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"continut cu imag %@", cell.userTALabel.text);
       }
    else {
        TAUITableViewCellWithoutImage *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"continut fara imag %@", cell.userTALabel.text);
        
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweet = (self.results)[indexPath.row];
    NSDictionary *entities =[tweet objectForKey:@"entities"];
    NSArray *media = [entities objectForKey:@"media"];
    
    if([media count] == 0)
    {
        TAUITableViewCellWithoutImage *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifierWithoutImage forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TAUITableViewCellWithoutImage alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierWithoutImage];
        }
        cell.contentView.layer.borderColor=[[UIColor grayColor] CGColor];
        cell.contentView.layer.borderWidth=0.5f;
        cell.userTALabel.text = [[tweet objectForKey:@"user"] objectForKey:@"name"];
        cell.textTALabel.attributedText=[self addAttributedTags:tweet[@"text"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageTAView.image = [UIImage imageWithData:data];
                
            });
        });
        
        NSString *dateString = tweet[@"created_at"];
        cell.dateTALabel.text=[self configTweetDate:dateString];
        //      [cell layoutIfNeeded]; // daca o activez am probleme legate de constraints. Nu inteleg momentan de ce!
        return cell;
    }
    else
    {
        TAUITableViewCellWithImage *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifierWithImage forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TAUITableViewCellWithImage alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierWithImage];
        }
        cell.contentView.layer.borderColor=[[UIColor grayColor] CGColor];
        cell.contentView.layer.borderWidth=0.5f;
        
        cell.userTALabel.text = [[tweet objectForKey:@"user"] objectForKey:@"name"];
        cell.textTALabel.attributedText=[self addAttributedTags:tweet[@"text"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageTAView.image = [UIImage imageWithData:data];
                
            });
        });
        
        NSString *dateString = tweet[@"created_at"];
        cell.dateTALabel.text=[self configTweetDate:dateString];
        
        NSDictionary *imageObject = media[0];
        NSString *mediaImag = [imageObject objectForKey:@"media_url_https"];
        mediaImag = [mediaImag stringByAppendingString:@":thumb"];
        NSURL *url = [NSURL URLWithString:mediaImag];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.mediaView.image =image;
                        [cell setNeedsLayout];
                    
                    });
                }
            }
        }];
        [task resume];
        
        
        //      [cell layoutIfNeeded]; // daca o activez am probleme legate de constraints. Nu inteleg momentan de ce!
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}





#pragma mark - Formatare  data afisata

- (NSString *)formattedDate:(NSDate *)date
{
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    
    if(timeSinceDate < 24.0 * 60.0 * 60.0)
    {
        NSUInteger hoursSinceDate = (NSUInteger)(timeSinceDate / (60.0 * 60.0));
        switch(hoursSinceDate)
        {
            default: return [NSString stringWithFormat:@"%lu hours ago", (unsigned long)hoursSinceDate];
            case 1: return @"1 hour ago";
            case 0:{
                NSUInteger minutesSinceDate = (NSUInteger)(timeSinceDate / 60.0);
                switch(minutesSinceDate)
                {
                    default:return [NSString stringWithFormat:@"%lu minutes ago", (unsigned long)minutesSinceDate];
                    case 1: return @"one minute ago";
                    case 0:{
                        return [NSString stringWithFormat:@"%lu seconds ago", (unsigned long)timeSinceDate];
                    }
                }
            }
                
        }
    }
    
    else
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSString *theDate = [dateFormat stringFromDate:date];
        return theDate;
    }
}



- (NSString *)configTweetDate:(NSString*)item
{
    NSDateFormatter *dateFormatter= [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:item];
    NSString *finalDate=[self formattedDate:date];
    return finalDate;
}


#pragma mark - Formatare  URL, Hash si @

-(BOOL) sirul:(NSString *)string contineCaracter:(char)character
{
    if ([string rangeOfString:[NSString stringWithFormat:@"%c",character]].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}


-(NSMutableAttributedString*)addAttributedTags:(NSString *)stringWithTags {
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:stringWithTags];
    
    //identifica  URLs in tweet.
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *matchesOfURLS = [detector matchesInString:stringWithTags
                                               options:0
                                                 range:NSMakeRange(0, [stringWithTags length])];
    for (NSTextCheckingResult *match in matchesOfURLS) {
        NSRange wordRange = [match range];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:wordRange];
    }
    
    //identifica  # si @ in tweet.
    NSArray *matches = [self.regex matchesInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)];
    for (NSTextCheckingResult *match in matches) {
        // wordRange -> length= lungime cuvant si location=poz in string
        NSRange wordRange = [match rangeAtIndex:1];
        NSString* word = [stringWithTags substringWithRange:wordRange];
        
        if ([self sirul:word contineCaracter:'@']){
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:wordRange];
        }
        else
        {
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:wordRange];
            
        }
        
    }
    
    return attString;
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.searchTextField){
        [textField resignFirstResponder];
        self.searchText=textField.text;
        NSLog(@"s-a introdus %@", self.searchText);
        [self interogareTwitter];
    }
    return true;
    
}

@end
