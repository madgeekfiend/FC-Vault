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
#import "SettingsObject.h"
#import "LoginObject.h"

@interface QDPassword()
    -(void)onSave:(QButtonElement*)buttonElement;
    -(void)onEdit;
    -(void)onSettings:(QButtonElement*)buttonElement;
    -(void)onCancel;
    -(void)onClearAll;
    -(void)onLogin;
    -(void)onRandom;
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

-(void)onLogin
{
    NSLog(@"LOGGING IN");   
    // Compare with login and do other stuff
    LoginObject *lo = [[LoginObject alloc] init];
    [self.root fetchValueIntoObject: lo];
    
    NSLog(@"Password entered: %@", lo.password);
    if ( ![[PasswordManager sharedApplication] loginWithPassword: lo.password] )
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"The login you typed is incorrect. Please double check our login and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    // Ya login is correct
    [[PasswordManager sharedApplication] updateLastLoginTime];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onCancel
{
    NSLog(@"CANCELLED PUSHED");
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onSettings:(QButtonElement *)buttonElement
{
    NSLog(@"Settings Saved");
    // Now let's get stuff and see what we can do
    SettingsObject *so = [[SettingsObject alloc] init];
    
    [self.root fetchValueIntoObject:so];
    
    // Now validate what's in here
    if ( [so.password length] < 4 && so.usePassword )
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Unable to Save" message:@"Your password must be 4 characters or longer to save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    if ( so.delay > 0 )
    {
        [[PasswordManager sharedApplication] setDelayTime:so.delay];
    }
    
    // Now just save the info
    [[PasswordManager sharedApplication] flipPasswordRequired: so.usePassword];
    [[PasswordManager sharedApplication] setPassword: so.password];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onClearAll
{
    UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Clear All" message:@"This will erase all your data. This can not be undone." delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Erase Data", nil];
    confirm.tag = 100;
    [confirm show];
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

-(void)onRandom
{
    NSLog(@"Generating Random Password");
    // Get element with key password
    QEntryElement *password = (QEntryElement*)[self.root elementWithKey:@"password"];
    password.textValue = [[PasswordManager sharedApplication] genRandStringLength:8];
    [self.tableView reloadData];
}

#pragma mark - Form Creation

+(QRootElement*)createLoginPage
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"QDPassword";
    root.grouped = YES;
    root.title = @"Login";
    
    // Only section
    QSection *login = [[QSection alloc] init];
    QEntryElement *loginBox = [[QEntryElement alloc] initWithTitle:nil Value:@"" Placeholder:@"Enter your password"];
    loginBox.key = @"password";
    loginBox.secureTextEntry = YES;
    [login addElement:loginBox];
    [root addSection: login];
    
    QSection *input = [[QSection alloc] init];
    QButtonElement *loginButton = [[QButtonElement alloc] initWithTitle:@"LOGIN"];
    loginButton.controllerAction = @"onLogin";
    [input addElement: loginButton];
    [root addSection: input];
    
    
    return root;
}

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
    QSection *randomSection = [[QSection alloc] init];
    
    QButtonElement* btnRandom = [[QButtonElement alloc] init];
    btnRandom.title = @"Generate Random Password";
    btnRandom.controllerAction = @"onRandom";
    [randomSection addElement:btnRandom];
    
    
    QButtonElement* btnSave = [[QButtonElement alloc] init];
    btnSave.title = @"Save";
    btnSave.controllerAction = @"onSave:";
    [buttonSection addElement:btnSave];
    
    [root addSection:randomSection];
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
    usePassword.key = @"usePassword";
    usePassword.boolValue = [[PasswordManager sharedApplication] isPasswordRequired];
    [detail addElement:usePassword];
    QEntryElement *password = [[QEntryElement alloc] initWithTitle:@"Password" Value:@"" Placeholder:@"Enter Password"];
    password.key = @"password";
    NSString* pw = [[PasswordManager sharedApplication] getPassword];
    if ( [pw length] > 3 )
    {
        password.textValue = pw;
    }
    [detail addElement:password];
    
    QDecimalElement *delay = [[QDecimalElement alloc] initWithTitle:@"Delay" value:[[PasswordManager sharedApplication] getDelayTime] ];
    delay.key = @"delay";
    delay.keyboardType = UIKeyboardTypeNumberPad;
    [detail addElement:delay];
    [detail setFooter:@"Delay defaults to 5 seconds"];
    [root addSection:detail];
    
    QSection *clear = [[QSection alloc] init];
    QButtonElement *ClearAll = [[QButtonElement alloc] initWithTitle:@"Clear All"];
    ClearAll.controllerAction = @"onClearAll";
    [clear addElement:ClearAll];
    [root addSection:clear];
    
    QSection *footer = [[QSection alloc] init];
    QButtonElement *save = [[QButtonElement alloc] initWithTitle:@"Save"];
    save.controllerAction = @"onSettings:";
    [footer addElement:save];
    [root addSection: footer];
    
    return root;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( 100 == alertView.tag )
    {
        if ( 1 == buttonIndex )
        {
            NSLog(@"Erasing all data");
            [[PasswordManager sharedApplication] eraseAll];
        }
    }
}

@end
