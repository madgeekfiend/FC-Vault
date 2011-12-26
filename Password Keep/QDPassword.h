//
//  QDAddPassword.h
//  Password Keep
//
//  Created by Sam Contapay on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QDPassword;

@protocol QDPasswordDelegate <NSObject>

@optional
-(void)didDismissQDialog; // The dialog has been dismissed

@end


@interface QDPassword : QuickDialogController
  {
      id<QDPasswordDelegate> delegate;
  }

@property(nonatomic, retain) id<QDPasswordDelegate> delegate;

+(QRootElement*)createPasswordForm;
+(QRootElement*)createPasswordDisplayForm:(NSManagedObject*)pw;
+(QRootElement*)createGeneratePassword;

@end
