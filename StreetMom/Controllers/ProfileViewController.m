//
//  ProfileViewController.m
//  StreetMom
//
//  Created by Thomas Devol on 11/17/13.
//  Copyright (c) 2013 quavmo. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserInfoViewController.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];

        
    }
    return self;
}

- (void)doneTapped:(id)sender {
    NSString* availability = [self.availabilitySwitch isOn] ? @"available": @"unavailable";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserAvailabilityKey object:nil userInfo:@{@"availability": availability}];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* availability = [[NSUserDefaults standardUserDefaults] valueForKey:UserAvailabilityKey];
    BOOL isAvailable = [availability isEqualToString:@"available"];
    
    [self.availabilitySwitch setOn:isAvailable];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
