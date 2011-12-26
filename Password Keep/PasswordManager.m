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
	}
    
	return self;
}

#pragma mark - Core Data Ops
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
    
    NSError *error;
    [context save:&error];
    
    // Now reload data again
    [self reloadData];
}

-(void)deletePassword:(NSManagedObject *)object
{
    [context deleteObject:object];
}

-(void)deletePasswordAtIndex:(int)index
{
    NSManagedObject* object = [data objectAtIndex:index];
    [self deletePassword:object];
    // reload data
    [self reloadData];
}

@end
