//
//  TextEntryFieldCell.h
//  Password Keep
//
//  Created by Sam Contapay on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextEntryFieldCell;

@protocol EditFieldCellDelegate <NSObject>

- (void)editDidFinish:(NSMutableDictionary *)result; 

@end

@interface TextEntryFieldCell : UITableViewCell <UITextFieldDelegate>
{
    UITextField* txtEntered;
    UILabel* lblName;
    id <EditFieldCellDelegate> delegate;
    NSString* key;
}

@property(nonatomic,retain)IBOutlet UITextField* txtEntered;
@property(nonatomic,retain)IBOutlet UILabel* lblName;
@property(nonatomic,retain)NSString* key;
@property(nonatomic,retain)id<EditFieldCellDelegate> delegate;

@end
