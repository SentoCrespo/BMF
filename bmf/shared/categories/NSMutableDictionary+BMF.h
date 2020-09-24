//
//  NSMutableDictionary+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (BMF)

- (void) BMF_setValueSafe:(id)value forKey:(id)key;

@end
