//
//  BMFIXFont+BMF.h
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/06/14.
//
//

#import "BMFTypes.h"
#import <CoreText/CoreText.h>

@interface BMFIXFont (BMF)

- (CTFontRef) BMF_ctFont;

- (BMFIXFont *) BMF_boldFont;
- (BMFIXFont *) BMF_italicFont;

- (BMFIXFont *) BMF_regularFont;

@end
