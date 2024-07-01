//
//  TRMetalImageViewLayer.m
//  TinrocketCommon
//
//  Created by John Balestrieri on 4/3/20.
//  Copyright © 2020 Tinrocket, LLC. All rights reserved.
//

#import "TRMetalImageViewLayer.h"



@implementation TRMetalImageViewLayer

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.pixelFormat = MTLPixelFormatBGRA8Unorm;
		self.device = MTLCreateSystemDefaultDevice();
		self.opaque = NO;
		self.framebufferOnly = NO;
//		self.displaySyncEnabled = YES;

#if TARGET_OS_IPHONE
		self.allowsNextDrawableTimeout = YES;
#else
		self.allowsNextDrawableTimeout = NO;
		// "These properties are crucial to resizing working"
//		self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//		self.needsDisplayOnBoundsChange = YES;
		self.presentsWithTransaction = YES; // Prevents flashing and jumping when the metal view is resizing
#endif
	}
	
	return self;
}

@end
