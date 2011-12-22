//
//  PasswordGeneratorController.h
//  Password Keep
//
//  Created by Sam Contapay on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordGeneratorController : UIViewController
{
    BOOL hasGeneratedPassword;
    NSString* password;
}



@property (weak, nonatomic) IBOutlet UITextField *txtLength;
@property (weak, nonatomic) IBOutlet UILabel *passwordDisplay;


// Actions
- (IBAction)generatePassword:(id)sender;

-(NSString *) genRandStringLength: (int) len;
-(void)resetPassword;

@end
