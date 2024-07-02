//
//  XOJO_TRMetalImageView_Plugin.cpp
//  XOJO TRMetalImageView Plugin
//
//  Created by John Balestrieri on 6/9/24.
//

#include <stdio.h>
#include "rb_plugin.h"
#import "TRMetalImageView.h"
#include "XOJO_TRMetalImageView_Plugin-iOS.h"

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


static void TRMetalImageView_initializer(REALcontrolInstance);
static void TRMetalImageView_finalizer(REALcontrolInstance);

static void * TRMetalImageView_handle_getter(REALcontrolInstance);
static void * TRMetalImageView_image_getter(REALcontrolInstance, RBInteger param);
static void TRMetalImageView_image_setter(REALcontrolInstance, RBInteger param, void *);
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


static REALmethodDefinition TRMetalImageView_Methods[] = {
	{ (REALproc)TRMetalImageView_configureForFasterDrawing, REALnoImplementation, "ConfigureForFasterDrawing()" },
	{ (REALproc)TRMetalImageView_configureForVideo, REALnoImplementation, "ConfigureForVideo()" },
};


static REALcontrolBehaviour TRMetalImageView_Behaviour = {
	TRMetalImageView_initializer,
	TRMetalImageView_finalizer,
	NULL, // redrawFunction
	NULL, // clickFunction
	NULL, // mouseDragFunction
	NULL, // mouseUpFunction
	NULL, // gainedFocusFunction
	NULL, // lostFocusFunction
	NULL, // keyDownFunction
	NULL, // openFunction
	NULL, // closeFunction
	NULL, // backgroundIdleFunction
	NULL, // drawOffscreenFunction
	NULL, // setSpecialBackground
	NULL, // constantChanging
	NULL, // droppedNewInstance
	NULL, // mouseEnterFunction
	NULL, // mouseExitFunction
	NULL, // mouseMoveFunction
	NULL, // stateChangedFunction
	NULL, // actionEventFunction
	TRMetalImageView_handle_getter, // RatingControlHandle_getter
};


static REALcontrol TRMetalImageView_Struct = {
	kCurrentREALControlVersion,
	"TRMetalImageView",
	sizeof(TRMetalImageView_Data),
	REALdesktopControl, // flags
	0, 0, // toolbar icons
	200, 200, // width/height
	TRMetalImageView_Properties, _countof(TRMetalImageView_Properties),
	TRMetalImageView_Methods, _countof(TRMetalImageView_Methods),
	NULL, 0,
	&TRMetalImageView_Behaviour
};


#pragma mark - Properties

static void * TRMetalImageView_image_getter( REALcontrolInstance control, RBInteger ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (__bridge void *)[data->view image];
}


static void TRMetalImageView_image_setter( REALcontrolInstance control, RBInteger, void * val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setImage:(__bridge CIImage *)val];
}


static NSUInteger TRMetalImageView_contentMode_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (kTRMetalImageViewContentMode)[data->view contentMode];
}


static void TRMetalImageView_contentMode_setter( REALcontrolInstance control, void *, NSUInteger val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setContentMode:(kTRMetalImageViewContentMode)val];
}


static BOOL TRMetalImageView_rasterizeBeforeDrawing_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return [data->view rasterizeBeforeDrawing];
}


static void TRMetalImageView_rasterizeBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setRasterizeBeforeDrawing:val];
}


static BOOL TRMetalImageView_clearBeforeDrawing_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return [data->view clearBeforeDrawing];
}


static void TRMetalImageView_clearBeforeDrawing_setter( REALcontrolInstance control, void *, BOOL val ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view setClearBeforeDrawing:val];
}


#pragma mark - Methods

static void TRMetalImageView_configureForFasterDrawing(REALcontrolInstance control) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view configureForFasterDrawing];
}


static void TRMetalImageView_configureForVideo(REALcontrolInstance control) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	[data->view configureForVideo];
}


#pragma mark - Lifecycle

static void TRMetalImageView_initializer( REALcontrolInstance control ) {
#if !TARGET_OS_IPHONE
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	// No need to calculate what frame to intialize the view with - the RB
	// framework will move it around as needed.
	TRMetalImageView *view = [[TRMetalImageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
	
	[view setTransparencyGrid:FALSE];
	
	data->view = view;
#endif
}


static void TRMetalImageView_finalizer( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	data->view = nil;
}


static void * TRMetalImageView_handle_getter( REALcontrolInstance control ) {
	ControlData(TRMetalImageView_Struct, control, TRMetalImageView_Data, data);

	return (__bridge void *)data->view;
}


void PluginEntry( void ) {
	REALRegisterControl(&TRMetalImageView_Struct);

//	RegisteriOSControl();
	
#if TARGET_OS_IPHONE
//	REALRegisterControl(&TRMetalImageView_Struct);
	RegisteriOSControl();
//#else
//	REALRegisterControl(&TRMetalImageView_Struct);
#endif
}
