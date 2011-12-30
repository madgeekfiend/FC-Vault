//
//  PasswordManager.h
//  Password Keep
//
//  Created by Sam Contapay on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordManager : NSObject
{
    NSManagedObjectContext* context;
    NSEntityDescription* passwordsEntity;
    NSArray* data;
    BOOL isPassword;
}


+(id)sharedApplication;

-(NSArray*)getAllPasswords;
-(void)reloadData;
-(void)SavePasswordWithName:(NSString*)name withLogin:(NSString*)login withURL:(NSString*)url withPassword:(NSString*)password;
-(void)deletePassword:(NSManagedObject*)object;
-(void)deletePasswordAtIndex:(int)index;
-(NSString *)genRandStringLength: (int)len;
-(void)saveContext;
-(void)eraseAll;

// Password stuff
-(BOOL)isPasswordRequired;
-(void)flipPasswordRequired:(BOOL)req;
-(void)setPassword:(NSInteger*)pwd;

@end
