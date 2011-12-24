//
//  PasswordObject.h
//  Password Keep
//
//  Created by Sam Contapay on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordObject : NSObject
{
    
@private
    NSString* _name;
    NSString* _login;
    NSString* _password;
    NSString* _url;
}

@property(nonatomic,strong)NSString* name;
@property(nonatomic, strong)NSString* login;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* url;

@end
