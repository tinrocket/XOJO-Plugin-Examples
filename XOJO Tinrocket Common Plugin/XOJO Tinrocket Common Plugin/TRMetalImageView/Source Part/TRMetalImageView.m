// Based on: https://thume.ca/2019/06/19/glitchless-metal-window-resizing/

//
//  TRMetalImageView.m
//  Resizable Metal Layer
//
//  Created by John Balestrieri on 3/2/20.
//  Copyright © 2020 Tinrocket, LLC. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "TRMetalImageView.h"
#import "TRMetalImageViewLayer.h"



@interface TRMetalImageView () <CALayerDelegate>
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) CIContext *ciContext;
@property (nonatomic, strong) CIImageAccumulator *flattenedImage;
@property (nonatomic, nullable) id <MTLDevice> device;
@property (nonatomic, strong) CAMetalLayer *metalLayer;
@property (nonatomic, assign) CGSize viewportSize;
@end


@implementation TRMetalImageView

#pragma mark - Class

#if TARGET_OS_IPHONE
+ (Class)layerClass {
	return [TRMetalImageViewLayer class];
}
#else
#endif


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	if (self) {
		[self sharedInit];
	}
	
	return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	
	if (self) {
		[self sharedInit];
	}
	
	return self;
}


- (void)sharedInit {
#if TARGET_OS_IPHONE
	self.metalLayer = (TRMetalImageViewLayer *)self.layer;
	self.metalLayer.delegate = self;
	self.contentScaleFactor = [UIScreen mainScreen].scale;
//	self.contentScaleFactor = MIN([UIScreen mainScreen].scale, 2.0);
	self.metalLayer.contentsScale = self.contentScaleFactor;
	self.metalLayer.rasterizationScale = self.contentScaleFactor;
#else
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;
	self.layerContentsPlacement = NSViewLayerContentsPlacementTopLeft;
#endif
	
	self.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0);
	
	self.contentMode = kTRMetalImageViewContentModeDefault;
	self.transparencyGrid = YES;
	self.transparencyParallax = NO;
	self.rasterizeBeforeDrawing = YES;
	self.clearBeforeDrawing = YES;
	self.minificationFilter = kTRMetalImageViewScalingFilterPixelate;
	self.magnificationFilter = kTRMetalImageViewScalingFilterPixelate;
	self.imageRect = CGRectZero;
	self.imageZoom = 1.0;
	self.imageOffset = CGPointZero;
	self.orientation = kCGImagePropertyOrientationUp;
	self.device = self.metalLayer.device;
	self.commandQueue = [self.device newCommandQueue];
	
	NSDictionary *options = @{kCIContextWorkingColorSpace : [NSNull null]};
	self.ciContext = [CIContext contextWithMTLDevice:self.device options:options];
}


#pragma mark - Overridden

//- (void)setOrientation:(CGImagePropertyOrientation)orientation {
//	_orientation = orientation;
//}


#if TARGET_OS_IPHONE
- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.viewportSize = self.frame.size;
	[self recomputeDrawableSize];
	
	[self.layer setNeedsDisplay]; // Mark the layer as needing display
}
#else
#endif


- (void)setImage:(CIImage *)image {
	_image = image;

	[self displayLayer:self.metalLayer];
	
#if TARGET_OS_IPHONE
#else
	[self setNeedsDisplay:YES];
#endif
}


#if TARGET_OS_IPHONE
#else
- (CALayer *)makeBackingLayer {
	self.metalLayer = [[TRMetalImageViewLayer alloc] init];
	self.metalLayer.delegate = self;

	return self.metalLayer;
}


- (void)setFrameSize:(NSSize)newSize {
	[super setFrameSize:newSize];
	
	self.viewportSize = newSize;
	[self recomputeDrawableSize];
	
	[self viewDidChangeBackingProperties];
}
#endif


- (void)viewDidChangeBackingProperties {
#if TARGET_OS_IPHONE
	self.metalLayer.contentsScale = [UIScreen mainScreen].scale;
	[self recomputeDrawableSize];
	[self displayLayer:self.metalLayer];
#else
	self.metalLayer.contentsScale = self.window.backingScaleFactor;
	[self recomputeDrawableSize];
	[self displayLayer:self.metalLayer];
#endif
}


#pragma mark - Private

- (id <MTLCommandBuffer>)draw:(id<CAMetalDrawable>)drawable {
	CGFloat screenScale = 1.0;
#if TARGET_OS_IPHONE
	screenScale = self.metalLayer.contentsScale;
#else
	screenScale = MAX(1.0, self.window.screen.backingScaleFactor);
#endif
	
	id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
	commandBuffer.label = @"MetalCommandBuffer";

	MTLRenderPassDescriptor *currentRenderPassDescriptor = [MTLRenderPassDescriptor new];

	if (self.clearBeforeDrawing) {
		// Clear with self.clearColor
		currentRenderPassDescriptor.colorAttachments[0].texture = drawable.texture;
		currentRenderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
		currentRenderPassDescriptor.colorAttachments[0].clearColor = self.clearColor;
		id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:currentRenderPassDescriptor];
		[encoder endEncoding];
	}
	
	CIImage *renderImage = self.image;
	
	if (!renderImage)
		return commandBuffer;

	renderImage = [renderImage imageByApplyingCGOrientation:_orientation];

	CGSize sourceSize = renderImage.extent.size;
	CGSize drawableSize = self.metalLayer.drawableSize;
	CGRect displayRect = CGRectMake(0, 0, drawableSize.width, drawableSize.height);

	static CGColorSpaceRef cs;
	if (cs == NULL) cs = CGColorSpaceCreateDeviceRGB();
	
	if (self.rasterizeBeforeDrawing) {
		// Optionally flatten renderImage and all it's scale and translation transforms
		// Helps to resolve renderImage's coordinate system transforms that happened along the way
		// May not be good if renderImage's is large
		// May not be helful if renderImage is simple or doesn't have coordinate system origin offsets
		// TODO: Help with caching (e.g., use cached image if there was no change from previous image)
		if (!self.flattenedImage || !CGSizeEqualToSize(renderImage.extent.size, self.flattenedImage.extent.size))
			self.flattenedImage = [CIImageAccumulator imageAccumulatorWithExtent:CGRectMake(0, 0, sourceSize.width, sourceSize.height) format:kCIFormatRGBA8];
	
		renderImage = [renderImage imageByApplyingTransform:CGAffineTransformMakeTranslation(-renderImage.extent.origin.x, -renderImage.extent.origin.y)];
		[self.flattenedImage setImage:renderImage];
	
		renderImage = self.flattenedImage.image;
	}
	
	if (!CGSizeEqualToSize(self.imageRect.size, CGSizeZero)) {
		_imageZoom = (self.imageRect.size.width / self.image.extent.size.width) * screenScale;
		_imageOffset = CGPointMake(self.imageRect.origin.x, self.imageRect.origin.y);
	}
	
	CGAffineTransform t = CGAffineTransformIdentity;
	
#if TARGET_OS_SIMULATOR
//	Reverse coordinate system
//	t = CGAffineTransformMakeScale(1.0, -1.0);
//	t = CGAffineTransformTranslate(t, 0.0, -renderImage.extent.size.height);
//	renderImage = [renderImage imageByApplyingTransform:t];
#else
#endif
	
//	NSLog(@"renderImage.extent: %@", NSStringFromRect(renderImage.extent));
//	NSLog(NSStringFromPoint(_imageOffset));

	CGPoint offset = _imageOffset;
	CGFloat scale = _imageZoom;
	CGFloat scaleInv = 1.0 / scale;
	CGFloat temp = 0.0;
	switch (_contentMode) {
		case kTRMetalImageViewContentModeDefault:
			t = CGAffineTransformScale(t, scale, scale);
			break;
			
		case kTRMetalImageViewContentModeCenter:
			temp = floor((drawableSize.width - sourceSize.width * scale) * 0.5);
			t = CGAffineTransformTranslate(t, floor((drawableSize.width - sourceSize.width * scale) * 0.5), floor((drawableSize.height - sourceSize.height * scale) * 0.5));
			t = CGAffineTransformTranslate(t, offset.x * screenScale, offset.y * screenScale);
			t = CGAffineTransformScale(t, scale, scale);
			break;
		
		case kTRMetalImageViewContentModeAspectFit:
			scale = MIN(drawableSize.width / sourceSize.width, drawableSize.height / sourceSize.height);
			scaleInv = 1.0 / scale;

			t = CGAffineTransformMakeScale(scale, scale);
			sourceSize = CGSizeApplyAffineTransform(sourceSize, t);
			sourceSize.width = floor(sourceSize.width);
			sourceSize.height = floor(sourceSize.height);

			t = CGAffineTransformTranslate(t, (drawableSize.width - sourceSize.width) * 0.5 * scaleInv, (drawableSize.height - sourceSize.height) * 0.5 * scaleInv);
			break;
			
		case kTRMetalImageViewContentModeAspectFill:
			scale = MAX(drawableSize.width / sourceSize.width, drawableSize.height / sourceSize.height);
			scaleInv = 1.0 / scale;

			t = CGAffineTransformMakeScale(scale, scale);
			sourceSize = CGSizeApplyAffineTransform(sourceSize, t);
			sourceSize.width = floor(sourceSize.width);
			sourceSize.height = floor(sourceSize.height);

			t = CGAffineTransformTranslate(t, (drawableSize.width - sourceSize.width) * 0.5 * scaleInv, (drawableSize.height - sourceSize.height) * 0.5 * scaleInv);
			break;
			
		default:
			break;
	}

	// Scaling filter
	kTRMetalImageViewScalingFilter f = kTRMetalImageViewScalingFilterUndefined;
	if (scale > 1.0) {
		f = self.magnificationFilter;
	} else if (scale < 1.0) {
		f = self.minificationFilter;
	}
	
	switch (f) {
		case kTRMetalImageViewScalingFilterPixelate:
			renderImage = [renderImage imageBySamplingNearest];
			break;
			
		case kTRMetalImageViewScalingFilterSmooth:
			renderImage = [renderImage imageBySamplingLinear];
			break;

		default:
			break;
	}
	//
	
	if (_transparencyGrid) {
		// TODO: Align the grid to the upper left corner
		CGFloat gridSize = 8.0 * screenScale * scaleInv;
		CGPoint parallax = CGPointZero;
		if (self.transparencyParallax)
			parallax = CGPointMake(-self.imageRect.origin.x * screenScale, -self.imageRect.origin.y * screenScale);
		CGAffineTransform t = CGAffineTransformMakeTranslation(parallax.x, parallax.y); // TODO: Align the grid to the upper left corner
		
		CIImage *transparentGrid = [[[CIFilter filterWithName:@"CICheckerboardGenerator" keysAndValues:
									  @"inputColor0", [CIColor colorWithRed:1.0 green:1.0 blue:1.0],
									  @"inputColor1", [CIColor colorWithRed:0.8 green:0.8 blue:0.8],
									  @"inputWidth", @(gridSize),
									  nil].outputImage imageByApplyingTransform:t] imageByCroppingToRect:renderImage.extent];
		
		renderImage = [renderImage imageByCompositingOverImage:transparentGrid];
	}
	
	renderImage = [renderImage imageByApplyingTransform:t];
	renderImage = [renderImage imageByCroppingToRect:displayRect];
	
	[_ciContext render:renderImage
		  toMTLTexture:drawable.texture
		 commandBuffer:commandBuffer
				bounds:displayRect
			colorSpace:cs];
	
	return commandBuffer;
}


#pragma mark - Public

- (void)recomputeDrawableSize {
	CGFloat contentScaleFactor = 1.0;
	
#if TARGET_OS_IPHONE
	contentScaleFactor = self.contentScaleFactor;
#else
	contentScaleFactor = self.window.backingScaleFactor;
#endif
	
//	NSLog(@"%f", self.viewportSize.width);
	
	self.metalLayer.drawableSize = CGSizeMake(self.viewportSize.width * contentScaleFactor, self.viewportSize.height * contentScaleFactor);
}


- (void)configureForVideo {
	self.clearBeforeDrawing = NO;
	
	NSDictionary *options = @{kCIContextWorkingColorSpace : [NSNull null],
							  kCIContextCacheIntermediates : @(NO) // Best for video, based on WWDC 20 video recs ("Optimize the Core Image pipeline for your video app")
	};

	self.ciContext = [CIContext contextWithMTLDevice:self.device options:options];
}


- (void)configureForFasterDrawing {
	NSDictionary *options = @{kCIContextWorkingColorSpace : [NSNull null],
							  kCIContextCacheIntermediates : @(NO) // Best for video, based on WWDC 20 video recs ("Optimize the Core Image pipeline for your video app")
	};

	self.ciContext = [CIContext contextWithMTLDevice:self.device options:options];
}


- (CGFloat)scaleForContentMode:(kTRMetalImageViewContentMode)contentMode image:(CIImage *)image {
	if (!image)
		return 1.0;

	CGSize drawableSize = self.metalLayer.drawableSize;
//	CGFloat screenScale = self.metalLayer.contentsScale;
//	drawableSize.width *= 1.0 / screenScale;
//	drawableSize.height *= 1.0 / screenScale;
	
	image = [image imageByApplyingCGOrientation:_orientation];
	CGSize sourceSize = image.extent.size;

	switch (contentMode) {
		case kTRMetalImageViewContentModeDefault:
			return self.imageZoom;
			
		case kTRMetalImageViewContentModeCenter:
			return self.imageZoom;
		
		case kTRMetalImageViewContentModeAspectFit:
			return MIN(drawableSize.width / sourceSize.width, drawableSize.height / sourceSize.height);
			
		case kTRMetalImageViewContentModeAspectFill:
			return MAX(drawableSize.width / sourceSize.width, drawableSize.height / sourceSize.height);
			
		default:
			return self.imageZoom;
	}
}


#pragma mark - Delegates
#pragma mark CALayerDelegate

- (void)displayLayer:(CALayer *)layer {
	id<CAMetalDrawable> drawable = [self.metalLayer nextDrawable];
	if (!drawable)
		return;
	
	id <MTLCommandBuffer> commandBuffer = [self draw:drawable];
	
	if (self.metalLayer.presentsWithTransaction) {
		[commandBuffer commit];
		[drawable present];
	} else {
		[commandBuffer commit];
//		[commandBuffer waitUntilScheduled]; // TODO: Is this needed? (Is it slowing things down?) // WWDC '22 Lab, Don't think this is needed
		[drawable present];
	}
}

@end
