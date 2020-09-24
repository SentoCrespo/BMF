//
//  BMFRegistrableProtocol.h
//  
//
//  Created by Jose Manuel Sánchez Peñarroja on 18/06/14.
//
//

#import <Foundation/Foundation.h>

/// This protocol defines a registrable class, where subclasses can be registered and listed. This is used for view configurators and themes, for example
@protocol BMFRegistrableProtocol <NSObject>

+ (NSArray *) registeredClasses;

+ (void) register;

@optional

+ (void) unregister;

@end
