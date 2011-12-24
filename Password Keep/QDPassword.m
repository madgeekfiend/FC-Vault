//
//  QDAddPassword.m
//  Password Keep
//
//  Created by Sam Contapay on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QDPassword.h"
#import "PasswordManager.h"
#import "PasswordObject.h"

@interface QDPassword()
    -(void)onSave:(QButtonElement*)buttonElement;
@end

@implementation QDPassword
@synthesize delegate, passwordObject;

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

-(void)onSave:(QButtonElement *)buttonElement
{
    PasswordObject* obj = [[PasswordObject alloc] init];
    
    [self.root fetchValueIntoObject:obj];
    // Save the object into the stuff
    [[PasswordManager sharedApplication] SavePasswordWithName:obj.name withLogin:obj.login withURL:obj.url withPassword:obj.password];
    
    [self dismissModalViewControllerAnimated:YES];
    [delegate didDismissQDialog];
}

+(QRootElement*)createPasswordForm
{
    QRootElement* root = [[QRootElement alloc] init];
    root.controllerName = @"QDPassword";
    root.grouped = YES;
    root.title = @"Add Passowrd";
    
    QSection* main = [[QSection alloc] init];
    
    QEntryElement *name = [[QEntryElement alloc] init];
    name.title = @"Name";
    name.key = @"name";
    name.placeholder = @"Enter a Name";
    [main addElement:name];
    
    [root addSection:main];
    
    QSection* detail = [[QSection alloc] init];
    detail.title = @"Details";
    
    QEntryElement* login = [[QEntryElement alloc] init];
    login.title = @"Login";
    login.key = @"login";
    login.placeholder = @"Login";
    [detail addElement:login];
    QEntryElement *password = [[QEntryElement alloc] init];
    password.title = @"Password";
    password.key = @"password";
    password.secureTextEntry = YES;
    password.placeholder = @"Enter password";
    [detail addElement:password];
    QEntryElement *url = [[QEntryElement alloc] init];
    url.title = @"URL";
    url.placeholder = @"URL (Optional)";
    url.key = @"url";
    [detail addElement:url];
    
    [root addSection:detail];

    // Button Section
    QSection* buttonSection = [[QSection alloc] init];
    QButtonElement* btnSave = [[QButtonElement alloc] init];
    btnSave.title = @"Save";
    btnSave.controllerAction = @"onSave:";
    [buttonSection addElement:btnSave];
    
    [root addSection:buttonSection];
    
    return root;
}

@end
