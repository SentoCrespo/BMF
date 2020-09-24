//
//  NSMutableDictionary+BMF.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 6/11/14.
//
//

#import "NSMutableDictionary+BMF.h"

@implementation NSMutableDictionary (BMF)

- (void) BMF_setValueSafe:(id)value forKey:(id)key {
	if (!value || !key) return;
	[self setValue:value forKey:key];
}

@end
