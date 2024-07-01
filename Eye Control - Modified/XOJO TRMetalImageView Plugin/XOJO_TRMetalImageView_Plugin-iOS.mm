//
//  XOJO_TRMetalImageView_Plugin.cpp
//  XOJO TRMetalImageView Plugin
//
//  Created by John Balestrieri on 6/9/24.
//

#include <stdio.h>
#include "rb_plugin.h"

#if COCOA
	// To keep this example simple, this file will need to be compiled as Obj-C++
	// in Xcode. In your shipping plugin, you will most likely want to separate
	// out the Cocoa-specific Objective-C code such that the .cpp file is just
	// C++ and reduce the number of #if preprocessor directives.
	#if !defined(__OBJC__) || !defined(__cplusplus)
		#error This file must be compiled as Objective-C++.
	#endif
#endif

#define GET_CONTROL_DATA(A) (TRMetalImageView_Data *)REALGetMobileControlData( A, &TRMetalImageView_Struct );


static void TRMetalImageView_initializer(REALcontrolInstance);
static void TRMetalImageView_finalizer(REALcontrolInstance);

static void * TRMetalImageView_handle_getter(REALcontrolInstance);
static void * TRMetalImageView_image_getter(REALcontrolInstance);
static void TRMetalImageView_image_setter(REALcontrolInstance, void *, void *);
static NSUInteger TRMetalImageView_contentMode_getter(REALcontrolInstance);
static void TRMetalImageView_contentMode_setter(REALcontrolInstance, void *, NSUInteger);
static BOOL TRMetalImageView_rasterizeBeforeDrawing_getter(REALcontrolInstance);
static void TRMetalImageView_rasterizeBeforeDrawing_setter(REALcontrolInstance, void *, BOOL);
static BOOL TRMetalImageView_clearBeforeDrawing_getter(REALcontrolInstance);
static void TRMetalImageView_clearBeforeDrawing_setter(REALcontrolInstance, void *, BOOL);
static void TRMetalImageView_configureForFasterDrawing(REALcontrolInstance);
static void TRMetalImageView_configureForVideo(REALcontrolInstance);

#pragma mark - Data Structures

struct TRMetalImageView_Data {
	TRMetalImageView *view;
};


static REALproperty TRMetalImageView_Properties[] = {
	{"", "CIImage", "Ptr", 0, (REALproc)TRMetalImageView_image_getter, (REALproc)TRMetalImageView_image_setter},
	{"", "ContentMode", "UInteger", 0, (REALproc)TRMetalImageView_contentMode_getter, (REALproc)TRMetalImageView_contentMode_setter},
	{"", "RasterizeBeforeDrawing", "Boolean", 0, (REALproc)TRMetalImageView_rasterizeBeforeDrawing_getter, (REALproc)TRMetalImageView_rasterizeBeforeDrawing_setter},
	{"", "ClearBeforeDrawing", "Boolean", 0, (REALproc)TRMetalImageView_clearBeforeDrawing_getter, (REALproc)TRMetalImageView_clearBeforeDrawing_setter},
};


REALmethodDefinition TRMetalImageView_Methods[] = {
	{ (REALproc)TRMetalImageView_configureForFasterDrawing, REALnoImplementation, "ConfigureForFasterDrawing()", REALpropRuntimeOnly },
	{ (REALproc)TRMetalImageView_configureForVideo, REALnoImplementation, "ConfigureForVideo()", REALpropRuntimeOnly },
};



static REALmobileControlBehaviour TRMetalImageView_Behaviour = {
	TRMetalImageView_initializer,
	TRMetalImageView_finalizer,
	TRMetalImageView_handle_getter,
	NULL,
	NULL,
	NULL,
	NULL,
};



static REALmobileControl TRMetalImageView_Struct = {
	kCurrentREALControlVersion,
	"TRMetalImageView",
	sizeof(TRMetalImageView_Data),
	REALenabledControl,
	0, 0, // toolbar icons
	200, 200, // width/height
	TRMetalImageView_Properties, sizeof(TRMetalImageView_Properties) / sizeof(REALproperty),
	TRMetalImageView_Methods, sizeof(TRMetalImageView_Methods) / sizeof(REALmethodDefinition),
	NULL, 0,
	&TRMetalImageView_Behaviour,
	
	
//	kCurrentREALControlVersion,
//	"MobileEyeControl",
//	sizeof(TRMetalImageView_Data),
//	REALenabledControl | REALcontrolIsHIViewCompatible,
//	0, 0,	// This is the BMP name, so the IDE will try and find 0.bmp in IDE Resources->Controls Palette folder in the RBX plugin
//	80, 50,
//	TRMetalImageView_Properties, sizeof(TRMetalImageView_Properties) / sizeof(REALproperty),
//	TRMetalImageView_Methods, sizeof(TRMetalImageView_Methods) / sizeof(REALmethodDefinition),
//	NULL, 0,
//	&TRMetalImageView_Behaviour,
};


#pragma mark - Properties

static void * TRMetalImageView_image_getter( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	return (__bridge void *)[data->view image];
}


static void TRMetalImageView_image_setter( REALcontrolInstance control, void *, void * val ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view setImage:(__bridge CIImage *)val];
}


static NSUInteger TRMetalImageView_contentMode_getter( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	return (kTRMetalImageViewContentMode)[data->view contentMode];
}


static void TRMetalImageView_contentMode_setter( REALcontrolInstance control, void *, NSUInteger val ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view setContentMode:(kTRMetalImageViewContentMode)val];
}


static BOOL TRMetalImageView_rasterizeBeforeDrawing_getter( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	return [data->view rasterizeBeforeDrawing];
}


static void TRMetalImageView_rasterizeBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view setRasterizeBeforeDrawing:val];
}


static BOOL TRMetalImageView_clearBeforeDrawing_getter( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	return [data->view clearBeforeDrawing];
}


static void TRMetalImageView_clearBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view setClearBeforeDrawing:val];
}


#pragma mark - Methods

static void TRMetalImageView_configureForFasterDrawing(REALcontrolInstance control) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view configureForFasterDrawing];
}


static void TRMetalImageView_configureForVideo(REALcontrolInstance control) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	[data->view configureForVideo];
}


#pragma mark - Lifecycle

static void TRMetalImageView_initializer( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	// No need to calculate what frame to intialize the view with - the RB
	// framework will move it around as needed.
	TRMetalImageView *view = [[TRMetalImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	
	[view setTransparencyGrid:FALSE];
	
	data->view = view;
}


static void TRMetalImageView_finalizer( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	data->view = nil;
}


static void * TRMetalImageView_handle_getter( REALcontrolInstance control ) {
	TRMetalImageView_Data *data = GET_CONTROL_DATA(control)

	return (__bridge void *)data->view;
}


void RegisteriOSControl( void ) {
	REALRegisterMobileControl(&TRMetalImageView_Struct);
}
