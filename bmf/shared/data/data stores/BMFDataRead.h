//
//  BMFDataRead.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 01/07/14.
//
//

#import <Foundation/Foundation.h>

#import "BMFTypes.h"
#import "BMFDataReadProtocol.h"

@interface BMFDataRead : NSObject <BMFDataReadProtocol>

@property (nonatomic, strong) BMFActionBlock applyValueBlock;
@property (nonatomic, strong) BMFActionBlock signalBlock;

@property (nonatomic, strong) BMFProgress *progress;

/// For subclasses
- (void) notifyDataChanged;

@end
