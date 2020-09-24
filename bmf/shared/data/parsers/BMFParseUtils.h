//
//  BMFParseUtils.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 07/07/14.
//
//

#import <Foundation/Foundation.h>

@interface BMFParseUtils : NSObject

- (BOOL) validateString:(id) presumedString;
- (BOOL) validateString:(id) presumedString fieldName:(NSString *) fieldName;
- (BOOL) validateNumber:(id) presumedNumber;
- (BOOL) validateNumber:(id) presumedNumber fieldName:(NSString *) fieldName;
- (BOOL) validateDictionary:(id) presumedDictionary;
- (BOOL) validateDictionary:(id) presumedDictionary fieldName:(NSString *) fieldName;
- (BOOL) validateArray:(id) presumedArray;
- (BOOL) validateArray:(id) presumedArray fieldName:(NSString *) fieldName;

- (BOOL) validateObject:(id) object class:(Class) wantedClass;
- (BOOL) validateObject:(id) object class:(Class) wantedClass fieldName:(NSString *) fieldName;

@end
