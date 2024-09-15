//
//  TRMetalImageView.h
//  Resizable Metal Layer
//
//  Created by John Balestrieri on 3/2/20.
//  Copyright © 2020 Tinrocket, LLC. All rights reserved.
//

#import <Metal/Metal.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
@class TRMetalImageView;



typedef NS_ENUM(NSUInteger, kTRMetalImageViewContentMode) {
	kTRMetalImageViewContentModeDefault,
	kTRMetalImageViewContentModeCenter,
	kTRMetalImageViewContentModeAspectFit,
	kTRMetalImageViewContentModeAspectFill,
};


typedef NS_ENUM(NSUInteger, kTRMetalImageViewScalingFilter) {
	kTRMetalImageViewScalingFilterUndefined,
	kTRMetalImageViewScalingFilterPixelate,
	kTRMetalImageViewScalingFilterSmooth
};


NS_ASSUME_NONNULL_BEGIN

@protocol TRMetalImageViewDelegate <NSObject>
- (CIImage *)overrideImageForMetalImageView:(TRMetalImageView *)theImageView cropRectPoints:(CGRect)theCropRect sourceRectPoints:(CGRect)theSourceRect magnification:(CGFloat)theMagnification backingScale:(CGFloat)theBackingScale;
@end


#if TARGET_OS_IPHONE
@interface TRMetalImageView : UIView
#else
@interface TRMetalImageView : NSView
#endif
@property (weak, nonatomic) IBOutlet id<TRMetalImageViewDelegate> imageViewDelegate;
@property (strong, nonatomic) CIImage *image;
@property (assign, nonatomic) BOOL transparencyGrid;
@property (assign, nonatomic) BOOL transparencyParallax;
@property (assign, nonatomic) BOOL rasterizeBeforeDrawing;
@property (assign, nonatomic) BOOL clearBeforeDrawing;
@property (assign, nonatomic) CGImagePropertyOrientation orientation;
@property (assign, nonatomic) kTRMetalImageViewContentMode contentMode;
@property (assign, nonatomic) kTRMetalImageViewScalingFilter minificationFilter;
@property (assign, nonatomic) kTRMetalImageViewScalingFilter magnificationFilter;
@property (assign, nonatomic) MTLClearColor clearColor;
@property (assign, nonatomic) BOOL isAnimating;
// TODO: Refactor to replace imageRect with imageZoom and imageOffset
@property (assign, nonatomic) CGRect imageRect; // In screen points
@property (assign, nonatomic) CGFloat imageZoom;
@property (assign, nonatomic) CGPoint imageOffset; // In screen points
- (void)recomputeDrawableSize;
- (void)configureForFasterDrawing;
- (void)configureForVideo;
- (CGFloat)scaleForContentMode:(kTRMetalImageViewContentMode)contentMode image:(CIImage *)image;
@end

NS_ASSUME_NONNULL_END
