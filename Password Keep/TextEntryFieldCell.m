//
//  TextEntryFieldCell.m
//  Password Keep
//
//  Created by Sam Contapay on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextEntryFieldCell.h"

@implementation TextEntryFieldCell
@synthesize lblName, txtEntered, key, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // Add shit here for the delegate to be called
}


@end
