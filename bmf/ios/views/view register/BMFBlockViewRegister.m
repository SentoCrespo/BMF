//
//  BMFBlockViewRegister.m
//  Pods
//
//  Created by Jose Manuel Sánchez Peñarroja on 14/5/15.
//
//

#import "BMFBlockViewRegister.h"

#import "BMFTypes.h"

@interface BMFBlockViewRegister()

@property (nonatomic, copy) BMFViewRegisterBlock registerBlock;
@property (nonatomic, copy) BMFViewIdBlock viewIdBlock;

@end

@implementation BMFBlockViewRegister

- (instancetype) initWithRegisterBlock:(BMFViewRegisterBlock)registerBlock dequeueBlock:(BMFViewIdBlock)viewIdBlock {
	BMFAssertReturnNil(viewIdBlock);
	
	self = [super init];
	if (self) {
		self.registerBlock = registerBlock;
		self.viewIdBlock = viewIdBlock;
	}
	return self;
}

- (NSString *) viewIdentifierForKind:(NSString *) kind indexPath:(NSIndexPath *)indexPath {
	return self.viewIdBlock(kind,indexPath);
}

- (id) classOrUINibForKind:(NSString *) kind IndexPath:(NSIndexPath *) indexPath {
	return self.retrieveCellBlock(kind,indexPath);
}

- (void) registerViews:(UIView *) view {
	self.registerBlock(view);
}

@end
