//
//  SettingsObject.h
//  Password Keep
//
//  Created by Sam Contapay on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsObject : NSObject
{
    BOOL usePassword;
    NSString* password;
}

@property BOOL usePassword;
@property(nonatomic,retain) NSString* password;

@end
