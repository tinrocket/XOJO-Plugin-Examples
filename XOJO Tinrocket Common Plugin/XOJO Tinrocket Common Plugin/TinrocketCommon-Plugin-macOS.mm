//
//  XOJO_TRMetalImageView_Plugin.cpp
//  XOJO TRMetalImageView Plugin
//
//  Created by John Balestrieri on 6/9/24.
//

#include <stdio.h>
#include "rb_plugin.h"
#import "TRMetalImageView-Plugin-macOS.h"
#include "TinrocketCommon-Plugin-iOS.h"

#if COCOA
	// To keep this example simple, this file will need to be compiled as Obj-C++
	// in Xcode. In your shipping plugin, you will most likely want to separate
	// out the Cocoa-specific Objective-C code such that the .cpp file is just
	// C++ and reduce the number of #if preprocessor directives.
	#if !defined(__OBJC__) || !defined(__cplusplus)
		#error This file must be compiled as Objective-C++.
	#endif
#endif

//#define GET_CONTROL_DATA(A) (TRMetalImageView_Data *)REALGetControlData( A, &TRMetalImageView_Struct );

void PluginEntry( void ) {
	RegisterTRMetalImageView();
	RegisteriOSControl();
}
