//
//  LoginObject.h
//  Password Keep
//
//  Created by Sam Contapay on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginObject : NSObject
{
@private
    NSString* _password;
}

@property(nonatomic,strong) NSString* password;

@end
