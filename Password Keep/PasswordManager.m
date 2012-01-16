//
//  PasswordManager.m
//  Password Keep
//
//  Created by Sam Contapay on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PasswordManager.h"
#import "AppDelegate.h"

static PasswordManager* _onlyInstance = nil;
NSString* const USE_PASSWORD_KEY = @"usePassword";
NSString* const PASSWORD_VALUE = @"password";

@interface PasswordManager()
    -(void)saveContext;
@end

@implementation PasswordManager

#pragma mark - Object Instantiation

+(id)sharedApplication
{
    @synchronized([PasswordManager class])
    {
        if ( nil == _onlyInstance )
            _onlyInstance = [[PasswordManager alloc] init];
    
        return _onlyInstance;
    }
    
    return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
        NSLog(@"Initializing Core Data");
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        context = [delegate managedObjectContext];
        NSLog(@"Setting entity description");
        passwordsEntity = [NSEntityDescription entityForName:@"Password" inManagedObjectContext:context];
        NSLog(@"Getting user defaults");
        defaults = [NSUserDefaults standardUserDefaults];
        // get the password and if they're using it
        usePassword = [defaults boolForKey:USE_PASSWORD_KEY];
        passowrd = [defaults stringForKey:PASSWORD_VALUE];
        
        // Now get the delay time
        delay_time = [defaults doubleForKey:@"delaytime"] == 0 ? 5.0 : [defaults doubleForKey:@"lastlogin"];
	}
    
	return self;
}

#pragma mark - Password Generator

-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    }
    
    return randomString;
}

#pragma mark - Core Data Ops

-(void)eraseAll
{
    for (NSManagedObject *obj in data)
    {
        [context deleteObject:obj];
    }
    
    // Now save the context
    [self saveContext];
    [self reloadData];
}

-(NSArray*)getAllPasswords
{
    return data;
}

-(void)reloadData
{
    NSLog(@"Retrieving all passwords");
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:passwordsEntity];
    NSError *error;    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSLog(@"Retrieved %d records", [results count]);
    data = results;
}

-(void)SavePasswordWithName:(NSString *)name withLogin:(NSString *)login withURL:(NSString *)url withPassword:(NSString *)password
{
    NSManagedObject *newPassword = [NSEntityDescription insertNewObjectForEntityForName:@"Password" inManagedObjectContext:context];
    // Fill in attributes for object
    [newPassword setValue:name forKey:@"name"];
    [newPassword setValue:login forKey:@"login"];
    [newPassword setValue:url forKey:@"url"];
    [newPassword setValue:password forKey:@"password"];
    [self saveContext];
    // Now reload data again
    [self reloadData];
}

-(void)deletePassword:(NSManagedObject *)object
{
    [context deleteObject:object];
    [self saveContext];
}

-(void)deletePasswordAtIndex:(int)index
{
    NSManagedObject* object = [data objectAtIndex:index];
    [self deletePassword:object];
    // reload data
    [self reloadData];
}

-(void)saveContext
{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

#pragma mark - Password

-(BOOL)loginWithPassword:(NSString*)pw
{
    if ([pw length] < 4 ) return NO;
    
    // Now compare it after getting the information from the form
    
    return [pw isEqualToString:pw];
}

-(BOOL)isPasswordRequired
{
   
    return usePassword;
}

-(void)flipPasswordRequired:(BOOL)req
{
    usePassword = req;
    [defaults setBool:req forKey:USE_PASSWORD_KEY];
}

-(void)setPassword:(NSString*)pwd
{
    passowrd = pwd;
    [defaults setValue:pwd forKey:PASSWORD_VALUE];
}

-(NSString*)getPassword
{
    return passowrd;
}

-(double)getDelayTime
{
    return delay_time;
}

-(BOOL)shouldLoginSinceLastTime
{
    BOOL shouldLogin = YES;
    
    // Should we require login since last time
    // Get last time
    double last_login = [defaults doubleForKey:@"lastlogin"];
    
    // Current time
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
  
    // Now find out what we should do I want a login 
    // Time interval goes here
    if ( last_login > 0  ) // a value exists
    {
        if ( timeStamp - last_login < 3.0 )
            return NO;
    }
    
    
    return shouldLogin;
}

-(void)updateLastLoginTime
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
   
    [defaults setDouble:timeStamp forKey:@"lastlogin"];
}

-(void)setDelayTime:(double)t
{
    delay_time = t;
    [defaults setDouble:t forKey:@"delaytime"];
}

@end
