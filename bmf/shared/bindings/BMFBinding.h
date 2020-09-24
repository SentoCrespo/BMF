//
//  BMFBinding.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 20/11/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFBindingProtocol.h"
#import "BMFAspect.h"
#import "BMFTypes.h"

@interface BMFBinding : BMFAspect <BMFBindingProtocol>

@property (nonatomic, weak) IBOutlet id model;
@property (nonatomic, weak) IBOutlet BMFIXControl *control;

@property (nonatomic, strong) NSString *propertyName;

@end
