//
//  QDAddPassword.m
//  Password Keep
//
//  Created by Sam Contapay on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QDAddPassword.h"

@implementation QDAddPassword

-(void)loadView
{
    [super loadView];
    self.tableView.bounces = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

+(QRootElement*)addPasswordForm
{
    QRootElement* root = [[QRootElement alloc] init];
    root.controllerName = @"QDAddPassword";
    root.grouped = YES;
    root.title = @"Add Passowrd";
    
    QSection* main = [[QSection alloc] init];
    
    
    
    
    return root;
}

@end
