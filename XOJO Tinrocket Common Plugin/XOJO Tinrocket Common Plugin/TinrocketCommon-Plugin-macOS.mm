//
//  XOJO_TRMetalImageView_Plugin.cpp
//  XOJO TRMetalImageView Plugin
//
//  Created by John Balestrieri on 6/9/24.
//

#include <stdio.h>
#include "rb_plugin.h"
#include "TinrocketCommon-Plugin-iOS.h"
#import "TRMetalImageView-Plugin-macOS.h"
#import "TRFoundation-Plugin.h"



#if COCOA
	// To keep this example simple, this file will need to be compiled as Obj-C++
	// in Xcode. In your shipping plugin, you will most likely want to separate
	// out the Cocoa-specific Objective-C code such that the .cpp file is just
	// C++ and reduce the number of #if preprocessor directives.
	#if !defined(__OBJC__) || !defined(__cplusplus)
		#error This file must be compiled as Objective-C++.
	#endif
#endif



void PluginEntry( void ) {
	// Cross-platform
	RegisterTRFoundation();

	// macOS
	RegisterTRMetalImageView_macOS();
		
	// iOS
	RegisteriOSPlugin();
}
