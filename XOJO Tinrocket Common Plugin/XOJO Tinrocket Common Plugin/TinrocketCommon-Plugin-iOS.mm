//
//  XOJO_TRMetalImageView_Plugin.cpp
//  XOJO TRMetalImageView Plugin
//
//  Created by John Balestrieri on 6/9/24.
//

#include <stdio.h>
#include "rb_plugin.h"
#include "TinrocketCommon-Plugin-iOS.h"
#import "TRMetalImageView-Plugin-iOS.h"
#import "NSValueTRC-Plugin.h"


void RegisteriOSPlugin( void ) {
	// Cross-platform
	Register_NSValueTRC();

	// iOS
	RegisterTRMetalImageView_iOS();
}
