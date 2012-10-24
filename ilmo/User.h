//
//  User.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/28/12.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSString* sessionId;

-(id) initWithJSON: (NSDictionary*) data;

@end
