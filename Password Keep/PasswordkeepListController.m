//
//  PasswordkeepListController.m
//  Password Keep
//
//  Created by Sam Contapay on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PasswordkeepListController.h"
#import "PasswordManager.h"


@implementation PasswordkeepListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load ads for the table view
    adview = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adview.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    adview.delegate = self;

    // Check to see if I should login
    // Let's check if login is required
    if ( [[PasswordManager sharedApplication] isPasswordRequired] && [[PasswordManager sharedApplication] shouldLoginSinceLastTime] )
    {
        // Password is required pop the login box
        QDPassword *loginDlg = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createLoginPage]];
        [self presentModalViewController:loginDlg animated:NO];
        
    }
    
    // Register for notifcation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(awakeFromBackground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Let's get the list of objects to display
    [[PasswordManager sharedApplication] reloadData];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation) )
        adview.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        adview.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[PasswordManager sharedApplication] getAllPasswords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"password";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSManagedObject* object = (NSManagedObject*)[[[PasswordManager sharedApplication] getAllPasswords] objectAtIndex:indexPath.row];
    NSString* nameText = 0 == [[object valueForKey:@"name"] length] ? @"(NO NAME)" : [object valueForKey:@"name"];
    cell.textLabel.text = nameText;
    NSString* urlText = 0 == [[object valueForKey:@"url"] length] ? @"NONE" : [object valueForKey:@"url"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"URL: %@", urlText];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[PasswordManager sharedApplication] deletePasswordAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - ADBannerView delegate
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.tableView.tableHeaderView = adview;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSManagedObject* pwo =  [[[PasswordManager sharedApplication] getAllPasswords] objectAtIndex:indexPath.row];
    QDPassword* passwordDetail = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createPasswordDisplayForm:pwo] ];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPassword:) ];
    editButton.tag = indexPath.row;
    passwordDetail.navigationItem.rightBarButtonItem = editButton;
    
    [self.navigationController pushViewController:passwordDetail animated:YES];
}

#pragma mark - QDPassword Delegate

-(void)didDismissQDialog
{
    NSLog(@"Reloading data in case anything has fired");
    [self.tableView reloadData];
}

#pragma mark - Delegate functions

// The tag of the button will have the array
-(void)editPassword:(id)sender
{
    UIBarButtonItem* btn = (UIBarButtonItem*)sender;
    NSManagedObject* pwo =  [[[PasswordManager sharedApplication] getAllPasswords] objectAtIndex:btn.tag];
    QDPassword *editForm = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createPasswordEditForm:pwo]];
    editForm.editObj = pwo;
    [self.navigationController pushViewController:editForm animated:YES];
}

- (IBAction)addPassword:(id)sender 
{
    // Display the add password dialog

    QDPassword* addPassword = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createPasswordForm]];
    addPassword.delegate = self;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:addPassword animated:YES];

}

- (IBAction)displaySettingsDialog:(id)sender {

    QDPassword *settingsDlg = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createSettingsPage]];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = cancel;
    [self.navigationController pushViewController:settingsDlg animated:YES];
    
}

#pragma mark - Application Delegate
-(void)awakeFromBackground
{
    if ( [[PasswordManager sharedApplication] isPasswordRequired] && [[PasswordManager sharedApplication] shouldLoginSinceLastTime] )
    {
        // Password is required pop the login box
        QDPassword *loginDlg = (QDPassword*)[QuickDialogController controllerForRoot:[QDPassword createLoginPage]];
        [self presentModalViewController:loginDlg animated:NO];
        
    }
}

@end
