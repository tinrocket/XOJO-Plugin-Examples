//
//  TRMetalImageViewLayer.h
//  TinrocketCommon
//
//  Created by John Balestrieri on 4/3/20.
//  Copyright © 2020 Tinrocket, LLC. All rights reserved.
//

#import <Metal/Metal.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#import <QuartzCore/QuartzCore.h>



NS_ASSUME_NONNULL_BEGIN

@interface TRMetalImageViewLayer : CAMetalLayer
@end

NS_ASSUME_NONNULL_END
