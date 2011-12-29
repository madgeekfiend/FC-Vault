//
//  PasswordkeepListController.h
//  Password Keep
//
//  Created by Sam Contapay on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDPassword.h"

@interface PasswordkeepListController : UITableViewController <QDPasswordDelegate>
{
}
- (IBAction)displaySettingsDialog:(id)sender;

- (IBAction)addPassword:(id)sender;
-(void)editPassword:(id)pw;

@end
