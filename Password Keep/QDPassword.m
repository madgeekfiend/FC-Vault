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
    -(void)onEdit;
    -(void)onSettings:(QButtonElement*)buttonElement;
    -(void)onCancel;
@end

@implementation QDPassword
@synthesize delegate, editObj;

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

#pragma mark - Button actions

-(void)onCancel
{
    NSLog(@"CANCELLED PUSHED");
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onSettings:(QButtonElement *)buttonElement
{
    
}

-(void)onSave:(QButtonElement *)buttonElement
{
    PasswordObject* obj = [[PasswordObject alloc] init];
    
    [self.root fetchValueIntoObject:obj];
    // Save the object into the stuff
    [[PasswordManager sharedApplication] SavePasswordWithName:obj.name withLogin:obj.login withURL:obj.url withPassword:obj.password];
    
    [self.navigationController popViewControllerAnimated:YES];
    [delegate didDismissQDialog];
}

-(void)onEdit
{
    if ( !editObj ) return; //Just get out of here this is broke
    
    PasswordObject *obj = [[PasswordObject alloc] init];
    [self.root fetchValueIntoObject:obj];
    
    [editObj setValue:obj.name forKey:@"name"];
    [editObj setValue:obj.login forKey:@"login"];
    [editObj setValue:obj.url forKey:@"url"];
    [editObj setValue:obj.password forKey:@"password"];
    
    editObj = nil;
    
    [[PasswordManager sharedApplication] saveContext];
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Form Creation

+(QRootElement*)createPasswordDisplayForm:(NSManagedObject*)pw
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"QDPassword";
    root.grouped = YES;
    root.title = @"Password Info";
    
    
    QSection *main = [[QSection alloc] init];
    QLabelElement *name = [[QLabelElement alloc] initWithTitle:@"Name" Value:[pw valueForKey:@"name"] ];
    [main addElement: name];
    [root addSection:main];
    
    QSection *details = [[QSection alloc] init];
    QLabelElement *login = [[QLabelElement alloc] initWithTitle:@"Login" Value:[pw valueForKey:@"login"]];
    [details addElement:login];
    QLabelElement *password = [[QLabelElement alloc] initWithTitle:@"Password" Value:[pw valueForKey: @"password"]];
    [details addElement: password];
    QLabelElement *url = [[QLabelElement alloc] initWithTitle:@"URL" Value:[pw valueForKey:@"url"]];
    [details addElement: url];
    [root addSection:details];
    
    return root;
    
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

+(QRootElement*)createGeneratePassword
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Generate Password";
    root.grouped = YES;
    root.controllerName = @"QDPassword";
    
    QSection *password = [[QSection alloc] init];
    QLabelElement *generated = [[QLabelElement alloc] initWithTitle:@"Password" Value:@"Not Generated"];
    [password addElement:generated];
    QEntryElement *length = [[QEntryElement alloc] initWithTitle:@"Length" Value:@"8"];
    [password addElement:length];    
    // Add Footer stuff to explain what is going on
    password.footer = @"Press generate to have the program create a random string for your password. The default length of the password is 8 characters long.";
    [root addSection:password];
    
    // Button section
    QSection *buttons = [[QSection alloc] init];
    QButtonElement *btnGenerate = [[QButtonElement alloc] initWithTitle:@"Generate"];
    [buttons addElement:btnGenerate];
    [root addSection:buttons];
    
    return root;
}

+(QRootElement*)createPasswordEditForm:(NSManagedObject*)pw
{
    QRootElement* root = [[QRootElement alloc] init];
    root.controllerName = @"QDPassword";
    root.grouped = YES;
    root.title = @"Edit Password";
    
    QSection* main = [[QSection alloc] init];

    QEntryElement *name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[pw valueForKey:@"name"] Placeholder:@"Name"];    
    name.key = @"name";
    [main addElement:name];
    
    [root addSection:main];
    
    QSection* detail = [[QSection alloc] init];
    detail.title = @"Details";
    
    QEntryElement* login = [[QEntryElement alloc] initWithTitle:@"Login" Value:[pw valueForKey:@"login"] Placeholder:@"Login Information"];
    login.key = @"login";
    [detail addElement:login];
    QEntryElement *password = [[QEntryElement alloc] initWithTitle:@"Password" Value:[pw valueForKey:@"password"] Placeholder:@"Your password"];
    password.key = @"password";
    [detail addElement:password];
    QEntryElement *url = [[QEntryElement alloc] initWithTitle:@"URL" Value:[pw valueForKey:@"url"] Placeholder:@"URL (OPTIONAL)"];
    url.key = @"url";
    [detail addElement:url];
    
    [root addSection:detail];
    
    // Button Section
    QSection* buttonSection = [[QSection alloc] init];
    QButtonElement* btnSave = [[QButtonElement alloc] init];
    btnSave.title = @"Save";
    btnSave.controllerAction = @"onEdit";
    [buttonSection addElement:btnSave];
    
    [root addSection:buttonSection];
    
    return root;    
}

+(QRootElement*)createSettingsPage
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Settings";
    root.controllerName = @"QDPassword";
    root.controllerAction = @"onSettings:";
    root.grouped = YES;
    
    QSection *detail = [[QSection alloc] init];
    QBooleanElement *usePassword = [[QBooleanElement alloc] initWithTitle:@"Use Password" BoolValue:NO];
    [detail addElement:usePassword];
    QEntryElement *password = [[QEntryElement alloc] initWithTitle:@"Password" Value:@"" Placeholder:@"Enter Password"];
    [detail addElement:password];
    [root addSection:detail];
    
    QSection *clear = [[QSection alloc] init];
    QButtonElement *ClearAll = [[QButtonElement alloc] initWithTitle:@"Clear All"];
    [clear addElement:ClearAll];
    [root addSection:clear];
    
    QSection *footer = [[QSection alloc] init];
    QButtonElement *save = [[QButtonElement alloc] initWithTitle:@"Save"];
    [footer addElement:save];
    QButtonElement *cancel = [[QButtonElement alloc] initWithTitle:@"Cancel"];
    cancel.controllerAction = @"onCancel";
    [footer addElement:cancel];
    [root addSection: footer];
    
    
    return root;
}

@end
